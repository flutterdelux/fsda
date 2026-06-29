import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;

import '../constants/cli_messages.dart';
import '../constants/cli_rules.dart';
import '../generated/bricks/app_bundle.dart';
import '../models/gen_argument.dart';
import '../services/process_service.dart';
import '../services/sdk_service.dart';
import 'base_generator.dart';

const _dependencies = [
  'logging',
  'flutter_bloc',
  'get_it',
  'go_router',
  'collection',
  'intl',
  'dio',
];

const _devDependencies = [
  'flutter_lints',
  'flutter_launcher_icons',
  'package_rename',
];

const _postHooks = <String>[];

class AppGenerator extends BaseGenerator<void, GenArgument> {
  static const appTemplate = 'main';
  final ProcessService processService;
  final SdkService sdkService;

  AppGenerator({
    required this.processService,
    required this.sdkService,
    required super.pubspecService,
    required super.hookService,
    required super.logger,
    required super.fileService,
  });

  @override
  Future<void> generate(GenArgument args) async {
    final appName = args.app;

    if (appName == null || appName.isEmpty) {
      logger.error('App name is required');
      return;
    }

    final appNameRegExp = RegExp(CliRules.appNamePattern);
    if (!appNameRegExp.hasMatch(appName)) {
      logger.error(
        'Invalid app name "$appName"\n'
        '${CliRules.appNameRule}',
      );
      return;
    }

    final targetDir = Directory(
      p.join(Directory.current.path, 'apps', appName),
    );

    if (await targetDir.exists()) {
      logger.error('App "$appName" already exists');
      return;
    }

    try {
      /// Create flutter app using flutter create command
      final createAppProgress = logger.progress(
        'Creating Flutter app template for "$appName"',
      );

      await processService.run(
        label: 'Create App',
        executable: 'flutter',
        arguments: ['create', '--project-name', appName, targetDir.path],
        workingDirectory: Directory.current.path,
      );

      createAppProgress.complete('App template created successfully');

      /// remove folder test
      final testDir = Directory(p.join(targetDir.path, 'test'));
      if (await testDir.exists()) {
        await testDir.delete(recursive: true);
      }

      /// Baked template using Mason
      final progress = logger.progress('Baking app "$appName"...');
      final generator = await MasonGenerator.fromBundle(appBundle);
      final target = DirectoryGeneratorTarget(targetDir);

      await generator.generate(
        target,
        vars: <String, dynamic>{
          'app': appName,
          'dart_sdk': sdkService.dartVersion,
        },
      );
      progress.complete('Baked app template successfully');

      final bundleSuccess = await generateTemplatePipeline(
        name: appName,
        targetDir: targetDir,
        dependencies: _dependencies,
        devDependencies: _devDependencies,
        postHooks: _postHooks,
      );
      if (!bundleSuccess) return;

      logger.success('App "$appName" created successfully');

      logger.log(CliMessages.appGeneratedNextSteps(appName));
    } catch (e) {
      logger.error(e.toString());
    }
  }
}
