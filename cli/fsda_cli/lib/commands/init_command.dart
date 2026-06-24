import 'package:args/command_runner.dart';

import '../generators/package_generator.dart';
import '../models/generation_result.dart';
import '../services/logger_service.dart';

class InitCommand extends Command {
  final PackageGenerator generator;
  final LoggerService logger;

  @override
  final String name = 'init';

  @override
  final String description = 'Initialize package base';

  InitCommand({required this.generator, required this.logger});

  @override
  Future<void> run() async {
    final result = await Future.wait([
      generator.generate({'name': 'app_core'}),
      generator.generate({'name': 'app_l10n'}),
      generator.generate({'name': 'app_ui'}),
    ]);

    final allSuccess = result.every(
      (r) => r.when(failure: (_) => false, success: (_, _) => true),
    );
    if (allSuccess) {
      logger.success('All base packages generated successfully.');
    } else {
      for (final r in result) {
        r.when(success: (_, _) {}, failure: (message) => logger.error(message));
      }
    }
  }
}
