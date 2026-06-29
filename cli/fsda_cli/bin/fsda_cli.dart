import 'package:args/command_runner.dart';
import 'package:fsda_cli/commands/add_command.dart';
import 'package:fsda_cli/commands/create_command.dart';
import 'package:fsda_cli/commands/gen_command.dart';
import 'package:fsda_cli/commands/init_command.dart';
import 'package:fsda_cli/commands/list_command.dart';
import 'package:fsda_cli/commands/reg_command.dart';
import 'package:fsda_cli/constants/cli_info.dart';
import 'package:fsda_cli/generators/app_generator.dart';
import 'package:fsda_cli/generators/feature_generator.dart';
import 'package:fsda_cli/generators/init_generator.dart';
import 'package:fsda_cli/generators/module_generator.dart';
import 'package:fsda_cli/generators/package_generator.dart';
import 'package:fsda_cli/generators/slice_generator.dart';
import 'package:fsda_cli/generators/workspace_generator.dart';
import 'package:fsda_cli/services/bundle_service.dart';
import 'package:fsda_cli/services/file_service.dart';
import 'package:fsda_cli/services/hook_service.dart';
import 'package:fsda_cli/services/logger_service.dart';
import 'package:fsda_cli/services/process_service.dart';
import 'package:fsda_cli/services/pubspec_service.dart';
import 'package:fsda_cli/services/sdk_service.dart';
import 'package:fsda_cli/services/workspace_service.dart';

void main(List<String> arguments) async {
  final sdkService = SdkService();

  // Initialize services
  final logger = LoggerService();
  final processService = ProcessService();
  final pubspecService = PubspecService(processService: processService);
  final fileService = FileService(sdkService: sdkService);
  final hookService = HookService(processService: processService);
  final bundleService = BundleService(fileService: fileService);
  final workspaceService = WorkspaceService();

  // Initialize generators
  final workspaceGenerator = WorkspaceGenerator(logger: logger);

  final packageGenerator = PackageGenerator(
    logger: logger,
    pubspecService: pubspecService,
    fileService: fileService,
    hookService: hookService,
    processService: processService,
    bundleService: bundleService,
  );
  final initGenerator = InitGenerator(
    logger: logger,
    packageGenerator: packageGenerator,
  );
  final appGenerator = AppGenerator(
    logger: logger,
    pubspecService: pubspecService,
    fileService: fileService,
    hookService: hookService,
    processService: processService,
    sdkService: sdkService,
  );
  final moduleGenerator = ModuleGenerator(
    logger: logger,
    fileService: fileService,
    sdkService: sdkService,
    pubspecService: pubspecService,
    hookService: hookService,
  );
  final featureGenerator = FeatureGenerator(
    logger: logger,
    fileService: fileService,
  );
  final sliceGenerator = SliceGenerator(
    logger: logger,
    fileService: fileService,
    hookService: hookService,
  );

  // Initialize command runner
  final runner = CommandRunner('fsda', 'Feature Slice Driven Architecture CLI')
    ..addCommand(CreateCommand(workspaceGenerator: workspaceGenerator))
    ..addCommand(
      InitCommand(
        initGenerator: initGenerator,
        logger: logger,
        workspaceService: workspaceService,
      ),
    )
    ..addCommand(ListCommand(logger: logger))
    ..addCommand(
      AddCommand(
        packageGenerator: packageGenerator,
        logger: logger,
        workspaceService: workspaceService,
      ),
    )
    ..addCommand(
      GenCommand(
        appGenerator: appGenerator,
        moduleGenerator: moduleGenerator,
        featureGenerator: featureGenerator,
        workspaceService: workspaceService,
        sliceGenerator: sliceGenerator,
        logger: logger,
      ),
    )
    ..addCommand(
      RegCommand(logger: logger, workspaceService: workspaceService),
    );

  runner.argParser.addFlag(
    'version',
    negatable: false,
    help: 'Print the tool version.',
  );

  try {
    final parsedArgs = runner.argParser.parse(arguments);
    if (parsedArgs.flag('version')) {
      logger.log('fsda version: ${CliInfo.version}');
      return;
    }

    await runner.run(arguments);
  } on UsageException catch (e) {
    logger.error(e.message);
    logger.log('');
    logger.log(e.usage);
  } catch (e) {
    logger.error('An unexpected error occurred: $e');
  }
}
