import 'package:args/command_runner.dart';

import '../generators/app_generator.dart';
import '../generators/feature_generator.dart';
import '../generators/module_generator.dart';
import '../generators/slice_generator.dart';
import '../models/generation_result.dart';
import '../services/logger_service.dart';

class GenCommand extends Command {
  final AppGenerator appGenerator;
  final ModuleGenerator moduleGenerator;
  final FeatureGenerator featureGenerator;
  final SliceGenerator sliceGenerator;
  final LoggerService logger;

  @override
  final String name = 'gen';

  @override
  final String description = 'Generate an app, module, feature, or slice.';

  GenCommand({
    required this.appGenerator,
    required this.moduleGenerator,
    required this.featureGenerator,
    required this.sliceGenerator,
    required this.logger,
  });

  @override
  Future<void> run() async {
    final args = argResults!.rest;

    if (args.isEmpty) {
      throw UsageException('Missing type', usage);
    }

    final type = args[0];

    final generator = switch (type) {
      'app' => appGenerator,
      'module' => moduleGenerator,
      'feature' => featureGenerator,
      'slice' => sliceGenerator,
      _ => null,
    };

    if (generator == null) {
      logger.error(
        'Generator "$type" not found. Available generators for gen: app, module, feature, slice.',
      );
      return;
    }

    final result = await generator.generate({
      'name': args[1],
      'module': argResults!['m'],
      'feature': argResults!['f'],
      'code': argResults!['code'],
    });
    result.when(
      success: (message, _) => logger.success(message),
      failure: (message) => logger.error(message),
    );
  }
}
