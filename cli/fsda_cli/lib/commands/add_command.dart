import 'package:args/command_runner.dart';

import '../constants/cli_rules.dart';
import '../generators/package_generator.dart';
import '../services/logger_service.dart';
import '../services/workspace_service.dart';

class AddCommand extends Command {
  final LoggerService logger;
  final WorkspaceService workspaceService;
  final PackageGenerator packageGenerator;

  AddCommand({
    required this.workspaceService,
    required this.packageGenerator,
    required this.logger,
  });

  @override
  final String name = 'add';

  @override
  final String description = 'Add a package or infra adapter to the project.';

  @override
  String get invocation => 'fsda add <package|infra> <name>';

  @override
  Future<void> run() async {
    workspaceService.ensureInsideWorkspace(usage);

    final args = argResults!.rest;

    if (args.length != 2) {
      throw UsageException('Usage: fsda add <package|infra> <name>', usage);
    }

    final type = args[0];
    final name = args[1];

    if (type != 'package' && type != 'infra') {
      throw UsageException(
        'Invalid type "$type". Use "package" or "infra".',
        usage,
      );
    }

    final packageName = type == 'infra'
        ? name.startsWith('infra_')
              ? name
              : 'infra_$name'
        : name;

    final nameRegExp = RegExp(CliRules.packageNamePattern);
    if (!nameRegExp.hasMatch(packageName)) {
      throw UsageException(
        'Invalid name "$packageName".\n'
        '${CliRules.packageNameRule}',
        usage,
      );
    }

    await packageGenerator.generate(packageName);
  }
}
