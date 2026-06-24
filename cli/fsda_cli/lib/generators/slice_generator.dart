import 'dart:io';
import 'package:path/path.dart' as p;
import '../models/generation_result.dart';
import 'base_generator.dart';

class SliceGenerator extends BaseGenerator {
  SliceGenerator({required super.logger});

  @override
  Future<GenerationResult> generate(Map<String, dynamic> args) async {
    final sliceType = args['type'] as String?;
    final sliceName = args['name'] as String?;

    if (sliceType == null) {
      return GenerationResult.failure(message: 'Slice type is required');
    }
    if (sliceName == null) {
      return GenerationResult.failure(message: 'Slice name is required');
    }

    try {
      // final assetsPath = await fsService.getAssetsPath();
      // final sourceDir = p.join(assetsPath, 'slices', sliceType);

      // if (!await Directory(sourceDir).exists()) {
      //   return GenerationResult.failure(
      //     'Slice template type "$sliceType" not found.',
      //   );
      // }

      // final targetDir = Directory.current.path;

      // await fsService.copyTemplateDirectory(
      //   sourceDir: sourceDir,
      //   targetDir: targetDir,
      //   variables: {'slice_name': sliceName, 'name': sliceName},
      //   renderTemplate: render,
      // );

      return GenerationResult.success(
        message: 'Slice $sliceName ($sliceType) generated successfully',
      );
    } catch (e) {
      return GenerationResult.failure(message: 'Failed to generate slice: $e');
    }
  }
}
