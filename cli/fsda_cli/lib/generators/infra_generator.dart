import 'dart:io';
import 'package:path/path.dart' as p;
import '../models/generation_result.dart';
import '../services/file_service.dart';
import '../services/hook_service.dart';
import '../services/pubspec_service.dart';
import '../services/seed_service.dart';
import 'base_generator.dart';

class InfraGenerator extends BaseGenerator {
  final PubspecService pubspecService;
  final FileService fileService;
  final HookService hookService;
  final SeedService seedService;

  InfraGenerator({
    required super.logger,
    required this.pubspecService,
    required this.fileService,
    required this.hookService,
    required this.seedService,
  });

  @override
  Future<GenerationResult> generate(Map<String, dynamic> args) async {
    final infraType = args['name'] as String?;

    if (infraType == null) {
      return GenerationResult.failure(message: 'Infra type is required');
    }

    try {
      final packageName = 'infra_$infraType';

      final targetDir = Directory(
        p.join(Directory.current.path, 'packages', packageName),
      );

      await targetDir.create(recursive: true);

      final seed = await seedService.loadInfra(infraType);

      await fileService.copyDirectory(
        source: seed.workingDirectory,
        target: targetDir,
      );

      await pubspecService.generatePubspec(
        path: targetDir.path,
        name: packageName,
        dependencies: seed.spec.dependencies,
        devDependencies: seed.spec.devDependencies,
        dependenciesManual: seed.spec.dependenciesManual,
        devDependenciesManual: seed.spec.devDependenciesManual,
      );

      await pubspecService.installDependencies(
        path: targetDir.path,
        dependencies: seed.spec.dependencies,
        devDependencies: seed.spec.devDependencies,
      );

      await hookService.run(seed.spec.postHooks, cwd: targetDir.path);

      return GenerationResult.success(
        message: 'Infra $infraType created successfully',
      );
    } catch (e) {
      return GenerationResult.failure(message: 'Failed to create infra: $e');
    }
  }
}
