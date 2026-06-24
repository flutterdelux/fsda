import 'package:args/command_runner.dart';

import '../generators/infra_generator.dart';
import '../generators/package_generator.dart';
import '../models/generation_result.dart';
import '../services/logger_service.dart';

class AddCommand extends Command {
  final PackageGenerator packageGenerator;
  final InfraGenerator infraGenerator;
  final LoggerService logger;

  @override
  final String name = 'add';

  @override
  final String description = 'Add a package or infra adapter to the project.';

  AddCommand({
    required this.packageGenerator,
    required this.infraGenerator,
    required this.logger,
  });

  @override
  Future<void> run() async {
    final args = argResults!.rest;

    if (args.length < 2) {
      throw UsageException('Usage: fsda add <package|infra> <name>', usage);
    }

    final type = args[0]; // package | infra
    final name = args[1];

    final generator = switch (type) {
      'package' => packageGenerator,
      'infra' => infraGenerator,
      _ => null,
    };

    if (generator == null) {
      logger.error(
        'Generator "$type" not found. Available generators for add: package, infra.',
      );
      return;
    }

    final result = await generator.generate({'name': name});
    result.when(
      success: (message, _) => logger.success(message),
      failure: (message) => logger.error(message),
    );
  }
}
