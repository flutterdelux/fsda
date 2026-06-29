import 'package:args/command_runner.dart';
import '../generated/package_bundle.dart';
import '../services/logger_service.dart';

class ListCommand extends Command<void> {
  final LoggerService logger;

  ListCommand({required this.logger});

  @override
  String get name => 'list';

  @override
  String get description => 'List available templates';

  @override
  String get invocation => 'fsda list <package|infra>';

  @override
  Future<void> run() async {
    final args = argResults!.rest;

    // Rule: Mandatory argument, no "blank" list allowed
    if (args.isEmpty) {
      logger.info('Missing argument. Please specify the type:');
      logger.log('  - fsda list package');
      logger.log('  - fsda list infra');
      return;
    }

    final type = args.first;
    final allPackages = packageBundle.keys.toList()..sort();

    switch (type) {
      case 'package':
        final list = allPackages.where((e) => !e.startsWith('infra_')).toList();
        _renderSection(
          'Available Packages (Use full name for "fsda add package <package_name>"):',
          list,
        );
        break;

      case 'infra':
        final list = allPackages
            .where((e) => e.startsWith('infra_'))
            .map((e) => e.replaceFirst('infra_', ''))
            .toList();
        _renderSection(
          'Available Infrastructure (Use short name for "fsda add infra <infra_name>"):',
          list,
        );
        break;

      default:
        throw UsageException(
          'Unknown list type "$type". Use "package" or "infra".',
          usage,
        );
    }
  }

  void _renderSection(String title, List<String> items) {
    logger.info(title);
    if (items.isEmpty) {
      logger.info('  (none)');
      return;
    }
    for (final item in items) {
      logger.log('  - $item');
    }
  }
}
