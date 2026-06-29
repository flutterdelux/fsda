import 'package:args/command_runner.dart';

import '../services/logger_service.dart';
import '../services/workspace_service.dart';

class RegCommand extends Command {
  final LoggerService logger;
  final WorkspaceService workspaceService;

  RegCommand({required this.logger, required this.workspaceService});

  @override
  final String name = 'reg';

  @override
  final String description = 'Register a module to the project.';

  @override
  Future<void> run() async {
    workspaceService.ensureInsideWorkspace(usage);

    final args = argResults!.rest;

    final type = args[0]; // module
    final name = args[1];

    final app = argResults?['app'];

    // final generator = registry.getGenerator('registry');

    // await generator.generate({'type': type, 'name': name, 'app': app});
  }
}
