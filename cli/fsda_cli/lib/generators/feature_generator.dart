import 'dart:convert';
import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;

import '../constants/cli_info.dart';
import '../constants/cli_rules.dart';
import '../generated/bricks/feature_bundle.dart';
import '../models/gen_argument.dart';
import 'base_generator.dart';

const _postHooks = ['flutter gen-l10n'];

class FeatureGenerator extends BaseGenerator<void, GenArgument> {
  FeatureGenerator({
    required super.logger,
    required super.fileService,
    required super.hookService,
  });

  @override
  Future<void> generate(GenArgument args) async {
    final genArgument = args;
    final featureName = genArgument.feature;
    final moduleName = genArgument.module;

    // Validation
    if (featureName == null || featureName.isEmpty) {
      logger.error('Feature name is required');
      return;
    }

    if (moduleName == null || moduleName.isEmpty) {
      logger.error('Module name is required');
      return;
    }

    final nameRegExp = RegExp(CliRules.featureNamePattern);
    if (!nameRegExp.hasMatch(featureName)) {
      logger.error(
        'Invalid feature name "$featureName". Must be snake_case (e.g., wallet, transaction_category).',
      );
      return;
    }
    if (!nameRegExp.hasMatch(moduleName)) {
      logger.error(
        'Invalid module name "$moduleName". Must be snake_case (e.g., auth, finance).',
      );
      return;
    }

    final barrelFilePath = p.join(
      Directory.current.path,
      'modules',
      moduleName,
      'lib',
      '$moduleName.dart',
    );

    // Taruh di baris paling atas FeatureGenerator.generate():
    final barrelFile = File(barrelFilePath);
    if (!barrelFile.existsSync()) {
      logger.error(
        '$barrelFilePath does not exist. Please ensure the "$moduleName" barrel file exists.',
      );
      return;
    }

    final targetDir = Directory(
      p.join(
        Directory.current.path,
        'modules',
        moduleName,
        'lib',
        'src',
        'features',
        featureName,
      ),
    );

    if (await targetDir.exists()) {
      logger.error(
        'Feature "$featureName" already exists at ${targetDir.path}',
      );
      return;
    }

    try {
      final progress = logger.progress(
        'Baking feature "$featureName" via Mason...',
      );

      final generator = await MasonGenerator.fromBundle(featureBundle);
      final target = DirectoryGeneratorTarget(targetDir);

      final generatedFiles = await generator.generate(
        target,
        vars: <String, dynamic>{
          'feature': featureName,
          'module': moduleName,
          'retrieval_check_point': CliInfo.retrievalCheckpoint,
          'mutation_check_point': CliInfo.mutationCheckpoint,
        },
      );
      progress.complete(
        'Baked ${generatedFiles.length} files into modules/$moduleName/src/features/$featureName',
      );

      final arbInjected = await _injectArbBoundary(
        moduleName: moduleName,
        featureName: featureName,
      );
      if (arbInjected) {
        final progress = logger.progress(
          'Running post-hooks for "$featureName"',
        );
        await hookService!.runHook(
          hooks: _postHooks,
          workingDirectory: p.join(
            Directory.current.path,
            'modules',
            moduleName,
          ),
        );
        progress.complete('Completed post-hooks for "$featureName"');
      }

      await _updateModuleBarrel(
        moduleBarrelPath: barrelFilePath,
        moduleSnake: moduleName,
        featureSnake: featureName,
      );
    } catch (e) {
      logger.error('$e');
      return;
    }
  }

  Future<void> _updateModuleBarrel({
    required String moduleBarrelPath,
    required String moduleSnake,
    required String featureSnake,
  }) async {
    if (fileService == null) {
      logger.error('FileService is required to update module barrel file');
      return;
    }

    final exportStatement =
        "export 'src/features/$featureSnake/${featureSnake}_feature.dart';";

    return fileService!.updateFile(
      path: moduleBarrelPath,
      cancelWhen: (content) => content.contains(exportStatement),
      updateLines: (lines) {
        // find the last export statement for features to insert after it
        final insertIndex = lines.lastIndexWhere(
          (line) => line.contains("export 'src/features/"),
        );

        if (insertIndex != -1) {
          lines.insert(insertIndex + 1, exportStatement);
        } else {
          lines.insert(0, exportStatement);
        }
      },
    );
  }

  Future<bool> _injectArbBoundary({
    required String moduleName,
    required String featureName,
  }) async {
    final l10nDir = Directory(
      p.join(Directory.current.path, 'modules', moduleName, 'lib', 'l10n'),
    );

    if (!await l10nDir.exists()) {
      logger.info(
        'L10n directory not found in module "$moduleName", skipping ARB injection.',
      );
      return false;
    }

    final arbFiles = l10nDir
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.arb'))
        .toList();

    if (arbFiles.isEmpty) return false;

    final featureCamel = featureName.camelCase;
    final featureTitle = featureName.titleCase;

    final metaKey = '@${featureCamel}Alt';
    final textKey = '${featureCamel}Alt';

    const encoder = JsonEncoder.withIndent('  ');

    for (final file in arbFiles) {
      final fileName = p.basename(file.path);
      try {
        final rawJson = await file.readAsString();

        final arbMap = Map<String, dynamic>.from(jsonDecode(rawJson) as Map);

        // Idempotent Guard: If @walletAlt already exists, skip!
        if (arbMap.containsKey(metaKey)) {
          logger.info(
            'ARB boundary for "$featureName" already exists in $fileName',
          );
          continue;
        }

        // Inject header boundary to the end of the Map
        arbMap[metaKey] = {
          'description':
              '========================= $featureTitle =========================',
        };

        // Inject dummy text
        // (Both EN and ID texts are automatically set to "Wallet" first, developer translates manually)
        arbMap[textKey] = featureTitle;

        // Convert the Map back to a pure JSON string
        final prettyJson = encoder.convert(arbMap);

        await file.writeAsString('$prettyJson\n');
        logger.success('Injected ARB boundary for "$featureName" to $fileName');
      } catch (e) {
        logger.error(
          'Failed to inject ARB boundary for "$featureName" in $fileName: $e',
        );
        return false;
      }
    }

    return true;
  }
}
