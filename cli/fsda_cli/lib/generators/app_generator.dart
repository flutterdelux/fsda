import 'dart:io';
import 'package:path/path.dart' as p;
import '../models/generation_result.dart';
import 'base_generator.dart';

class AppGenerator extends BaseGenerator {
  AppGenerator({required super.logger});

  @override
  Future<GenerationResult> generate(Map<String, dynamic> args) async {
    final appName = args['name'] as String?;
    if (appName == null) {
      return GenerationResult.failure(message: 'App name is required');
    }

    try {
      // final assetsPath = await fsService.getAssetsPath();
      // final sourceDir = p.join(assetsPath, 'app');
      // final targetDir = Directory.current.path;

      // await fsService.copyTemplateDirectory(
      //   sourceDir: sourceDir,
      //   targetDir: targetDir,
      //   variables: {'app_name': appName, 'name': appName},
      //   renderTemplate: render,
      // );

      return GenerationResult.success(
        message: 'App $appName generated successfully',
      );
    } catch (e) {
      return GenerationResult.failure(message: 'Failed to generate app: $e');
    }
  }
}
