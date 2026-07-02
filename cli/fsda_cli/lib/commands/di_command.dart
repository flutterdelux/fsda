import 'package:args/command_runner.dart';

import '../generators/di_generator.dart';
import '../models/di_argument.dart';

class DiCommand extends Command {
  final DiGenerator diGenerator;

  @override
  final String name = 'di';

  @override
  final String description =
      'Scan and inject feature dependencies into Module DI.';

  DiCommand({required this.diGenerator}) {
    argParser
      ..addOption(
        'app',
        abbr: 'a',
        help: 'Target application name (e.g., fsda_demo)',
      )
      ..addOption(
        'module',
        abbr: 'm',
        help: 'Target module name (e.g., finance)',
      );
  }

  @override
  Future<void> run() async {
    final app = argResults?['app'] as String?;
    final module = argResults?['module'] as String?;

    if (app == null || module == null) {
      diGenerator.logger.error(
        'Error: Both --app (-a) and --module (-m) options are required.',
      );
      diGenerator.logger.info(usage);
      return;
    }

    await diGenerator.generate(DiArgument(app: app, module: module));
  }
}
