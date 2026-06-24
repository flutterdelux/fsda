import 'package:args/command_runner.dart';

import '../services/logger_service.dart';

class RegCommand extends Command {
  final LoggerService logger;

  @override
  final String name = 'reg';

  @override
  final String description = 'Register a module to the project.';

  RegCommand({required this.logger});

  @override
  Future<void> run() async {
    final args = argResults!.rest;

    final type = args[0]; // module
    final name = args[1];

    final app = argResults?['app'];

    // final generator = registry.getGenerator('registry');

    // await generator.generate({'type': type, 'name': name, 'app': app});
  }
}
