import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fsda_cli/commands/add_command.dart';
import 'package:fsda_cli/commands/gen_command.dart';
import 'package:fsda_cli/commands/init_command.dart';
import 'package:fsda_cli/commands/reg_command.dart';
import 'package:fsda_cli/generators/app_generator.dart';
import 'package:fsda_cli/generators/feature_generator.dart';
import 'package:fsda_cli/generators/infra_generator.dart';
import 'package:fsda_cli/generators/module_generator.dart';
import 'package:fsda_cli/generators/package_generator.dart';
import 'package:fsda_cli/generators/slice_generator.dart';
import 'package:fsda_cli/services/file_service.dart';
import 'package:fsda_cli/services/file_system_seed_service.dart';
import 'package:fsda_cli/services/hook_service.dart';
import 'package:fsda_cli/services/logger_service.dart';
import 'package:fsda_cli/services/process_service.dart';
import 'package:fsda_cli/services/pubspec_service.dart';
import 'package:fsda_cli/services/sdk_version_service.dart';
import 'package:fsda_cli/services/zip_seed_service.dart';
import 'package:path/path.dart' as p;

const String version = '0.0.2';

void main(List<String> arguments) async {
  final sdk = SdkVersionService();

  // Initialize services
  final logger = LoggerService();
  final processService = ProcessService();
  final pubspecService = PubspecService(sdk: sdk, process: processService);
  final fileService = FileService();
  final hookService = HookService(processService);
  final seedService = ZipSeedService(zipPath: zipPath, zipDecoder: zipDecoder);

  // Initialize generators
  final packageGenerator = PackageGenerator(
    logger: logger,
    pubspecService: pubspecService,
    fileService: fileService,
    hookService: hookService,
    seedService: seedService,
  );
  final infraGenerator = InfraGenerator(
    logger: logger,
    pubspecService: pubspecService,
    fileService: fileService,
    hookService: hookService,
    seedService: seedService,
  );
  final appGenerator = AppGenerator(logger: logger);
  final moduleGenerator = ModuleGenerator(logger: logger);
  final featureGenerator = FeatureGenerator(logger: logger);
  final sliceGenerator = SliceGenerator(logger: logger);

  // Initialize command runner
  final runner = CommandRunner('fsda', 'Feature Slice Driven Architecture CLI')
    ..addCommand(InitCommand(generator: packageGenerator, logger: logger))
    ..addCommand(
      AddCommand(
        packageGenerator: packageGenerator,
        logger: logger,
        infraGenerator: infraGenerator,
      ),
    )
    ..addCommand(
      GenCommand(
        appGenerator: appGenerator,
        moduleGenerator: moduleGenerator,
        featureGenerator: featureGenerator,
        sliceGenerator: sliceGenerator,
        logger: logger,
      ),
    )
    ..addCommand(RegCommand(logger: logger));

  runner.argParser.addFlag(
    'version',
    negatable: false,
    help: 'Print the tool version.',
  );

  try {
    final parsedArgs = runner.argParser.parse(arguments);
    if (parsedArgs.flag('version')) {
      logger.log('fsda version: $version');
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
