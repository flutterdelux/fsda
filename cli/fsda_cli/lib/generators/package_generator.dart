import 'dart:io';
import 'package:path/path.dart' as p;
import '../models/generation_result.dart';
import '../services/file_service.dart';
import '../services/hook_service.dart';
import '../services/pubspec_service.dart';
import '../services/seed_service.dart';
import 'base_generator.dart';

class PackageGenerator extends BaseGenerator {
  final PubspecService pubspecService;
  final FileService fileService;
  final HookService hookService;
  final SeedService seedService;

  PackageGenerator({
    required super.logger,
    required this.pubspecService,
    required this.fileService,
    required this.hookService,
    required this.seedService,
  });

  @override
  Future<GenerationResult> generate(Map<String, dynamic> args) async {
    final packageName = args['name'] as String?;

    if (packageName == null) {
      return GenerationResult.failure(message: 'Package name is required');
    }

    try {
      final targetDir = Directory(
        p.join(Directory.current.path, 'packages', packageName),
      );

      await targetDir.create(recursive: true);

      // load seed
      final seed = await seedService.loadPackage(packageName);

      // copy files
      await fileService.copyDirectory(
        source: seed.workingDirectory,
        target: targetDir,
      );

      // generate pubspec
      await pubspecService.generatePubspec(
        path: targetDir.path,
        name: packageName,
        dependencies: seed.spec.dependencies,
        devDependencies: seed.spec.devDependencies,
        dependenciesManual: seed.spec.dependenciesManual,
        devDependenciesManual: seed.spec.devDependenciesManual,
      );

      // install dependencies
      await pubspecService.installDependencies(
        path: targetDir.path,
        dependencies: seed.spec.dependencies,
        devDependencies: seed.spec.devDependencies,
      );

      // run hooks
      await hookService.run(seed.spec.postHooks, cwd: targetDir.path);

      return GenerationResult.success(
        message: 'Package $packageName created successfully',
      );
    } catch (e) {
      return GenerationResult.failure(message: 'Failed to create package: $e');
    }
  }
}
