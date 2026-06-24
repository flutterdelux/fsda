import 'dart:io';
import 'package:path/path.dart' as p;
import '../models/generation_result.dart';
import 'base_generator.dart';

class FeatureGenerator extends BaseGenerator {
  FeatureGenerator({required super.logger});

  @override
  Future<GenerationResult> generate(Map<String, dynamic> args) async {
    final featureName = args['name'] as String?;
    if (featureName == null) {
      return GenerationResult.failure(message: 'Feature name is required');
    }

    try {
      // final assetsPath = await fsService.getAssetsPath();
      // final sourceDir = p.join(assetsPath, 'feature');
      // final targetDir = Directory.current.path;

      // await fsService.copyTemplateDirectory(
      //   sourceDir: sourceDir,
      //   targetDir: targetDir,
      //   variables: {'feature_name': featureName, 'name': featureName},
      //   renderTemplate: render,
      // );

      return GenerationResult.success(
        message: 'Feature $featureName generated successfully',
      );
    } catch (e) {
      return GenerationResult.failure(
        message: 'Failed to generate feature: $e',
      );
    }
  }
}
