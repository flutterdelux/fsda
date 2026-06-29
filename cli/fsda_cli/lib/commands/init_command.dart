import 'package:args/command_runner.dart';

import '../generators/init_generator.dart';
import '../services/logger_service.dart';
import '../services/workspace_service.dart';

class InitCommand extends Command {
  final InitGenerator initGenerator;
  final LoggerService logger;
  final WorkspaceService workspaceService;

  InitCommand({
    required this.initGenerator,
    required this.logger,
    required this.workspaceService,
  });

  @override
  final String name = 'init';

  @override
  final String description = 'Initialize package base';

  @override
  String get invocation => 'fsda init';

  @override
  Future<void> run() async {
    workspaceService.ensureInsideWorkspace(usage);

    final args = argResults!.rest;

    if (args.isNotEmpty) {
      throw UsageException(
        'This command does not accept any arguments.\n'
        'Use the standard format: fsda init',
        usage,
      );
    }

    await initGenerator.generate();
  }
}
