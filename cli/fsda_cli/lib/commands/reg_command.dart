import 'package:args/command_runner.dart';

import '../generators/reg_module_generator.dart';
import '../models/reg_argument.dart';
import '../services/logger_service.dart';
import '../services/workspace_service.dart';

class RegCommand extends Command {
  final RegModuleGenerator regModuleGenerator;
  final WorkspaceService workspaceService;
  final LoggerService logger;

  RegCommand({
    required this.regModuleGenerator,
    required this.workspaceService,
    required this.logger,
  }) {
    argParser
      ..addOption('app', abbr: 'a', help: 'The name of the target app.')
      ..addOption('module', abbr: 'm', help: 'The name of the target module.');
  }

  @override
  final String name = 'reg';

  @override
  final String description = 'Compose module, feature to target app.';

  @override
  String get invocation => 'fsda reg <module> [options]';

  @override
  Future<void> run() async {
    workspaceService.ensureInsideWorkspace(usage);

    final args = argResults!.rest;

    if (args.isEmpty) {
      throw UsageException('Missing generation type (module).', usage);
    }

    if (args.isNotEmpty) {
      final strayArgs = args.skip(1).join(' ');
      throw UsageException(
        'Unexpected argument(s): "$strayArgs".\n'
        'Only one positional argument is allowed: the module name.',
        usage,
      );
    }

    final regArgument = RegArgument(
      app: argResults?['app'] as String?,
      module: argResults?['module'] as String?,
    );

    _validateRequirements(regArgument);

    await regModuleGenerator.generate(regArgument);
  }

  /// Validates required flags dynamically depending on the generation [type].
  void _validateRequirements(RegArgument arg) {
    final missingFlags = <String>[];

    if (arg.module == null) missingFlags.add('--module');
    if (arg.app == null) missingFlags.add('--app');

    if (missingFlags.isNotEmpty) {
      throw UsageException(
        'Missing required flag(s): ${missingFlags.join(', ')}',
        usage,
      );
    }
  }
}
