import 'package:args/command_runner.dart';

import '../enums/gen_type.dart';
import '../generators/app_generator.dart';
import '../generators/feature_generator.dart';
import '../generators/module_generator.dart';
import '../generators/slice_generator.dart';
import '../models/gen_argument.dart';
import '../services/logger_service.dart';
import '../services/workspace_service.dart';

class GenCommand extends Command {
  final AppGenerator appGenerator;
  final ModuleGenerator moduleGenerator;
  final FeatureGenerator featureGenerator;
  final WorkspaceService workspaceService;
  final SliceGenerator sliceGenerator;
  final LoggerService logger;

  GenCommand({
    required this.appGenerator,
    required this.moduleGenerator,
    required this.featureGenerator,
    required this.workspaceService,
    required this.logger,
    required this.sliceGenerator,
  }) {
    argParser
      ..addOption('app', abbr: 'a', help: 'The name of the target app.')
      ..addOption('module', abbr: 'm', help: 'The name of the target module.')
      ..addOption('feature', abbr: 'f', help: 'The name of the target feature.')
      ..addOption('slice', abbr: 's', help: 'The name of the target slice.')
      ..addOption(
        'sequence',
        abbr: 'c',
        help: 'The sequence code (e.g., M, Mp, Rpag).',
      )
      ..addOption(
        'method',
        abbr: 'd',
        help: 'Optional custom method name for slice.',
      );
  }

  @override
  final String name = 'gen';

  @override
  final String description = 'Generate an app, module, feature, or slice.';

  @override
  String get invocation => 'fsda gen <app|module|feature|slice> [options]';

  @override
  Future<void> run() async {
    workspaceService.ensureInsideWorkspace(usage);

    final args = argResults!.rest;

    if (args.isEmpty) {
      throw UsageException(
        'Missing generation type (app, module, feature, slice).',
        usage,
      );
    }

    if (args.length > 1) {
      final strayArgs = args.skip(1).join(' ');
      throw UsageException(
        'Unexpected argument(s): "$strayArgs".\n'
        'Tip: If your option value contains spaces, make sure to wrap it in quotes (e.g., -a "my app").',
        usage,
      );
    }

    GenType type;
    try {
      type = GenType.fromValue(args[0]);
    } catch (e) {
      logger.error(
        'Invalid generation type "${args[0]}". Available types: app, module, feature, slice.',
      );
      return;
    }

    // 2. Capture arguments (Added sequence parameter)
    final genArgument = GenArgument(
      app: argResults?['app'] as String?,
      module: argResults?['module'] as String?,
      feature: argResults?['feature'] as String?,
      slice: argResults?['slice'] as String?,
      sequence: argResults?['sequence'] as String?,
      method: argResults?['method'] as String?,
    );

    // 3. Dynamic runtime validation based on positional type
    _validateRequirements(type, genArgument);

    await switch (type) {
      GenType.app => appGenerator.generate(genArgument),
      GenType.module => moduleGenerator.generate(genArgument),
      GenType.feature => featureGenerator.generate(genArgument),
      GenType.slice => sliceGenerator.generate(genArgument),
    };
  }

  /// Validates required flags dynamically depending on the generation [type].
  void _validateRequirements(GenType type, GenArgument arg) {
    final missingFlags = <String>[];

    switch (type) {
      case GenType.app:
        if (arg.app == null) missingFlags.add('--app');
        break;
      case GenType.module:
        if (arg.module == null) missingFlags.add('--module');
        break;
      case GenType.feature:
        if (arg.feature == null) missingFlags.add('--feature');
        if (arg.module == null) missingFlags.add('--module');
        break;
      case GenType.slice:
        if (arg.slice == null) missingFlags.add('--slice');
        if (arg.feature == null) missingFlags.add('--feature');
        if (arg.module == null) missingFlags.add('--module');
        if (arg.sequence == null) missingFlags.add('--sequence');
        break;
    }

    if (missingFlags.isNotEmpty) {
      throw UsageException(
        'Missing required flag(s) for "$type": ${missingFlags.join(', ')}',
        usage,
      );
    }
  }
}
