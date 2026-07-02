import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import '../constants/cli_info.dart';
import '../constants/cli_rules.dart';
import '../enums/sequence_code.dart';
import '../generated/bricks/sequence_m_bundle.dart';
import '../models/gen_argument.dart';
import '../services/memory_generator_target.dart';
import 'base_generator.dart';

class SliceGenerator extends BaseGenerator<void, GenArgument> {
  SliceGenerator({
    required super.logger,
    required super.fileService,
    required super.hookService,
  });

  @override
  Future<void> generate(GenArgument args) async {
    final sliceName = args.slice;
    final featureName = args.feature;
    final moduleName = args.module;
    final sequence = args.sequence;
    final methodName = args.resolvedMethodName;

    final isModuleValid = await _validateModule(moduleName);
    if (!isModuleValid) return;

    final isFeatureValid = await _validateFeature(moduleName!, featureName);
    if (!isFeatureValid) return;

    final isSliceValid = await _validateSlice(
      moduleName,
      featureName!,
      sliceName,
    );
    if (!isSliceValid) return;

    if (sequence == null || sequence.isEmpty) {
      logger.error('Sequence code is required (--sequence, e.g., M, R)');
      logger.info(
        'Available sequence codes: ${SequenceCode.values.map((e) => e.code).join(', ')}',
      );
      return;
    }
    final sequenceCode = SequenceCode.fromValue(sequence);
    final isMutation = sequenceCode.isMutation;

    if (fileService == null) {
      logger.error('FileService is required for weaving code.');
      return;
    }

    logger.info(
      'Weaving slice "$sliceName" -> "$moduleName/$featureName" as ${isMutation ? 'mutation' : 'retrieval'} sequence...',
    );
    final progress = logger.progress('Baking slice "$sliceName" in memory...');
    final memoryGeneratorTarget = MemoryGeneratorTarget();

    try {
      final generator = await MasonGenerator.fromBundle(
        _resolveSequenceBundle(sequenceCode),
      );
      await generator.generate(
        memoryGeneratorTarget,
        vars: <String, dynamic>{
          'slice': sliceName,
          'feature': featureName,
          'module': moduleName,
          'sequence': sequenceCode.code,
          'method': methodName,
        },
      );

      String? sequenceYamlRaw;
      final standaloneFilesToSave = <String, List<int>>{};

      for (final entry in memoryGeneratorTarget.files.entries) {
        final filePath = entry.key;
        final fileBytes = entry.value;
        final fileName = p.basename(filePath);

        if (fileName == 'sequence.yaml') {
          sequenceYamlRaw = utf8.decode(fileBytes);
          continue;
        }

        standaloneFilesToSave[filePath] = fileBytes;
      }

      if (sequenceYamlRaw == null) {
        throw Exception(
          'sequence.yaml not found in the generated slice files.',
        );
      }

      final featureRoot = p.join(
        Directory.current.path,
        'modules',
        args.module!,
        'lib',
        'src',
        'features',
        args.feature!,
      );

      progress.update('Writing standalone slice files to disk...');
      await fileService!.generateTemplate(
        path: featureRoot,
        files: standaloneFilesToSave,
      );

      progress.update('Parsing sequence manifest & weaving checkpoint...');
      final doc = loadYaml(sequenceYamlRaw) as YamlMap;

      final dsContractCode = doc['data_source_contract'] as String?;
      final dsImplCode = doc['data_source_impl'] as String?;
      final repoContractCode = doc['repository_contract'] as String?;
      final repoImplCode = doc['repository_impl'] as String?;
      final exportsMap = doc['exports'] as YamlMap?;
      final postHooks = List<String>.from(doc['post_hooks'] as List? ?? []);

      if (dsContractCode != null) {
        await _injectCode(
          path: p.join(
            featureRoot,
            'data',
            'datasources',
            '${args.feature}_remote_data_source.dart',
          ),
          code: dsContractCode,
          isMutation: isMutation,
        );
      }
      if (dsImplCode != null) {
        await _injectCode(
          path: p.join(
            featureRoot,
            'data',
            'datasources',
            '${args.feature}_remote_data_source_impl.dart',
          ),
          code: dsImplCode,
          isMutation: isMutation,
        );
      }
      if (repoContractCode != null) {
        await _injectCode(
          path: p.join(
            featureRoot,
            'domain',
            'repositories',
            '${args.feature}_repository.dart',
          ),
          code: repoContractCode,
          isMutation: isMutation,
        );
      }
      if (repoImplCode != null) {
        await _injectCode(
          path: p.join(
            featureRoot,
            'data',
            'repositories',
            '${args.feature}_repository_impl.dart',
          ),
          code: repoImplCode,
          isMutation: isMutation,
        );
      }

      if (exportsMap != null && exportsMap.isNotEmpty) {
        progress.update('Registering exports to feature barrel...');
        await _updateFeatureBarrelStructured(
          path: p.join(featureRoot, '${featureName}_feature.dart'),
          exportsMap: exportsMap,
        );
      }

      if (postHooks.isNotEmpty) {
        progress.update('Running post hooks...');
        await hookService!.runHook(
          hooks: postHooks,
          workingDirectory: p.join(
            Directory.current.path,
            'modules',
            moduleName,
          ),
        );
      }

      progress.complete(
        'Slice "$sliceName" successfully woven into "$featureName" feature! 🧵✨',
      );
    } catch (e) {
      progress.fail('Failed to stitch slice: $e');
    }
  }

  Future<bool> _validateModule(String? module) async {
    if (module == null || module.isEmpty) {
      logger.error('Module name is required (--module)');
      return false;
    }
    if (!RegExp(CliRules.moduleNamePattern).hasMatch(module)) {
      logger.error(
        'Module name "$module" is invalid.\n'
        '${CliRules.moduleNameRule}',
      );
      return false;
    }
    final targetDir = Directory(
      p.join(Directory.current.path, 'modules', module),
    );

    if (!await targetDir.exists()) {
      logger.error('Module "$module" does not exist');
      return false;
    }

    return true;
  }

  Future<bool> _validateFeature(String module, String? feature) async {
    if (feature == null || feature.isEmpty) {
      logger.error('Feature name is required (--feature)');
      return false;
    }
    if (!RegExp(CliRules.featureNamePattern).hasMatch(feature)) {
      logger.error(
        'Feature name "$feature" is invalid.\n'
        '${CliRules.featureNameRule}',
      );
      return false;
    }
    final targetDir = Directory(
      p.join(
        Directory.current.path,
        'modules',
        module,
        'lib',
        'src',
        'features',
        feature,
      ),
    );
    if (!await targetDir.exists()) {
      logger.error('Feature "$feature" does not exist in module "$module"');
      return false;
    }
    return true;
  }

  Future<bool> _validateSlice(
    String module,
    String feature,
    String? slice,
  ) async {
    if (slice == null || slice.isEmpty) {
      logger.error('Slice name is required (--slice)');
      return false;
    }
    if (!RegExp(CliRules.sliceNamePattern).hasMatch(slice)) {
      logger.error(
        'Slice name "$slice" is invalid.\n'
        '${CliRules.sliceNameRule}',
      );
      return false;
    }

    return true;
  }

  Future<void> _injectCode({
    required String path,
    required String code,
    required bool isMutation,
  }) async {
    final file = File(path);
    if (!await file.exists()) return;

    String content = await file.readAsString();
    final targetCheckpoint = isMutation
        ? CliInfo.mutationCheckpoint
        : CliInfo.retrievalCheckpoint;

    final formattedCode = code.trimRight().split('\n').join('\n  ');

    if (content.contains(targetCheckpoint)) {
      // Scenario A: Checkpoint comment exists, insert code below it!
      content = content.replaceFirst(
        targetCheckpoint,
        '$targetCheckpoint\n\n  $formattedCode',
      );
    } else {
      // Scenario B: Checkpoint comment missing (removed by user)
      final closingOffset = _findClassClosingBraceAST(content);

      if (closingOffset == -1) {
        logger.error(
          'Failed to find class closing brace in $path. Cannot inject code.',
        );
        return;
      }

      final beforeBrace = content.substring(0, closingOffset);
      final afterBrace = content.substring(closingOffset);

      content = '$beforeBrace  $formattedCode\n$afterBrace';
    }

    await file.writeAsString(content);
  }

  Future<void> _updateFeatureBarrelStructured({
    required String path,
    required YamlMap exportsMap,
  }) async {
    final file = File(path);
    if (!await file.exists()) return;

    final content = await file.readAsString();
    final lines = content.split('\n');

    for (final layer in ['data', 'domain', 'logic', 'ui']) {
      final yamlList = exportsMap[layer];
      if (yamlList == null || yamlList is! YamlList) continue;

      final validExports = yamlList
          .map((e) => e.toString().trim())
          .where((stmt) => stmt.isNotEmpty && !content.contains(stmt))
          .toList();

      if (validExports.isEmpty) continue;

      final markerIndex = lines.indexWhere((l) => l.trim() == '// $layer');

      if (markerIndex != -1) {
        lines.insertAll(markerIndex + 1, validExports);
      } else {
        lines.addAll(validExports);
      }
    }

    await file.writeAsString('${lines.join('\n')}\n');
  }

  int _findClassClosingBraceAST(String content) {
    final parseResult = parseString(content: content);

    final classNode = parseResult.unit.declarations
        .whereType<ClassDeclaration>()
        .firstOrNull;

    return classNode?.endToken.offset ?? -1;
  }

  MasonBundle _resolveSequenceBundle(SequenceCode sequence) {
    return switch (sequence) {
      SequenceCode.m => sequenceMBundle,
      _ => throw Exception('Unsupported sequence code: ${sequence.code}'),
    };
  }
}
