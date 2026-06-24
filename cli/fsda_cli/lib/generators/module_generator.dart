import 'dart:io';
import 'package:path/path.dart' as p;
import '../models/generation_result.dart';
import 'base_generator.dart';

class ModuleGenerator extends BaseGenerator {
  ModuleGenerator({required super.logger});

  @override
  Future<GenerationResult> generate(Map<String, dynamic> args) async {
    final moduleName = args['name'] as String?;
    if (moduleName == null) {
      return GenerationResult.failure(message: 'Module name is required');
    }

    try {
      // final assetsPath = await fsService.getAssetsPath();
      // final sourceDir = p.join(assetsPath, 'module');
      // final targetDir = Directory.current.path;

      // await fsService.copyTemplateDirectory(
      //   sourceDir: sourceDir,
      //   targetDir: targetDir,
      //   variables: {'module_name': moduleName, 'name': moduleName},
      //   renderTemplate: render,
      // );

      return GenerationResult.success(
        message: 'Module $moduleName generated successfully',
      );
    } catch (e) {
      return GenerationResult.failure(message: 'Failed to generate module: $e');
    }
  }
}
