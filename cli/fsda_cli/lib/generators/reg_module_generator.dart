import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import '../generated/bricks/reg_module_bundle.dart';
import '../models/reg_argument.dart';
import '../services/memory_generator_target.dart';
import '../visitors/app_router_visitor.dart';
import '../visitors/di_visitor.dart';
import '../visitors/failure_x_visitor.dart';
import '../visitors/main_app_visitor.dart';
import 'base_generator.dart';

class RegModuleGenerator extends BaseGenerator<void, RegArgument> {
  RegModuleGenerator({required super.logger, required super.fileService});

  @override
  Future<void> generate(RegArgument arg) async {
    final appName = arg.app!;
    final moduleName = arg.module!;

    final appPath = p.join(Directory.current.path, 'apps', appName);
    final appLibPath = p.join(appPath, 'lib');

    final moduleSnake = moduleName;

    logger.info(
      'Genering module structure for "$moduleName" into "$appName"...',
    );
    final memoryGeneratorTarget = MemoryGeneratorTarget();
    final generator = await MasonGenerator.fromBundle(regModuleBundle);
    await generator.generate(
      memoryGeneratorTarget,
      vars: <String, dynamic>{'app': appName, 'module': moduleName},
    );

    String? regYamlRaw;
    final standaloneFilesToSave = <String, List<int>>{};

    for (final entry in memoryGeneratorTarget.files.entries) {
      final filePath = entry.key;
      final fileBytes = entry.value;
      final fileName = p.basename(filePath);

      if (fileName == 'reg.yaml') {
        regYamlRaw = utf8.decode(fileBytes);
        continue;
      }

      standaloneFilesToSave[filePath] = fileBytes;
    }

    if (regYamlRaw == null) {
      throw Exception('reg.yaml not found in the generated reg_module files.');
    }

    if (fileService == null) {
      throw Exception('fileService is not initialized.');
    }

    await fileService!.generateTemplate(
      path: p.join(appLibPath, 'modules', moduleSnake),
      files: standaloneFilesToSave,
    );

    logger.info('Injecting module configuration into $appName...');

    await _injectDependency(
      filePath: p.join(appPath, 'pubspec.yaml'),
      moduleSnake: moduleSnake,
    );

    final doc = loadYaml(regYamlRaw) as YamlMap;
    await _injectDi(doc['di'] as YamlMap?);
    await _injectRoute(doc['route'] as YamlMap?);
    await _injectL10n(doc['l10n'] as YamlMap?);
    await _injectFailureX(doc['failure_x'] as YamlMap?);

    logger.success(
      'Module "$moduleName" successfully registered in "$appName"!',
    );

    logger.info('📂 Generated Module Folder:');
    logger.log('• apps/$appName/lib/modules/$moduleSnake');

    logger.info('📝 Injected & Modified Files:');
    logger.log('• apps/$appName/pubspec.yaml (Dependency added)');
    logger.log(
      '• apps/$appName/lib/core/di/di.dart (Service locator injected)',
    );
    logger.log('• apps/$appName/lib/app/app_router.dart (Route list updated)');
    logger.log('• apps/$appName/lib/app/main_app.dart (L10n delegate added)');
    logger.log(
      '• apps/$appName/lib/core/extensions/failure_x.dart (Failure localization mapped)',
    );
    logger.log('');
  }

  // ===========================================================================
  // INJECTION METHODS
  // ===========================================================================

  Future<void> _injectDependency({
    required String filePath,
    required String moduleSnake,
  }) async {
    final file = File(filePath);
    if (!await file.exists()) return;

    final lines = await file.readAsLines();
    final dependencyLine =
        '  $moduleSnake:\n    path: ../../modules/$moduleSnake';

    if (lines.join('\n').contains('  $moduleSnake:')) return;

    final markerIndex = lines.indexWhere((l) => l.trim() == 'dependencies:');
    if (markerIndex != -1) {
      lines.insert(markerIndex + 1, dependencyLine);
      await file.writeAsString('${lines.join('\n')}\n');
    }
  }

  Future<void> _injectDi(YamlMap? yamlRaw) async {
    final path = yamlRaw?['path'] as String?;
    final imports = yamlRaw?['imports'] as YamlList?;
    final code = yamlRaw?['code'] as String?;

    if (path == null) {
      logger.info(
        'No DI configuration found in reg.yaml. Skipping DI injection.',
      );
      return;
    }

    final file = File(path);
    if (!await file.exists()) {
      logger.error('DI file not found at path: $path. Skipping DI injection.');
      return;
    }

    if (code == null) {
      logger.info('No DI code found in reg.yaml. Skipping DI injection.');
      return;
    }

    final source = await file.readAsString();
    if (source.contains(code.trim())) return;

    final parsed = parseString(content: source);
    final visitor = DiVisitor();
    parsed.unit.visitChildren(visitor);

    if (visitor.initDiBlock == null) return;

    final blockEndOffset = visitor.initDiBlock!.end - 1;
    final newSource = source.replaceRange(
      blockEndOffset,
      blockEndOffset,
      '${' ' * 2}$code\n',
    );

    final (_, updatedImports) = _insertImports(newSource.split('\n'), imports);
    await file.writeAsString(updatedImports ?? newSource);
  }

  Future<void> _injectRoute(YamlMap? yamlRaw) async {
    final path = yamlRaw?['path'] as String?;
    final imports = yamlRaw?['imports'] as YamlList?;
    final code = yamlRaw?['code'] as String?;

    if (path == null) {
      logger.info(
        'No Route configuration found in reg.yaml. Skipping Route injection.',
      );
      return;
    }

    final file = File(path);
    if (!await file.exists()) {
      logger.error(
        'Route file not found at path: $path. Skipping Route injection.',
      );
      return;
    }

    if (code == null) {
      logger.info('No Route code found in reg.yaml. Skipping Route injection.');
      return;
    }

    final source = await file.readAsString();
    final parsed = parseString(content: source);

    final visitor = AppRouterVisitor();
    parsed.unit.visitChildren(visitor);

    if (visitor.routesList == null) return;

    final list = visitor.routesList!;
    final innerContent = source.substring(
      list.leftBracket.end,
      list.rightBracket.offset,
    );

    final lines = innerContent
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty);

    final lastLine = lines.isNotEmpty ? lines.last : '';

    bool needsComma = true;
    if (lastLine.isEmpty ||
        lastLine.endsWith(',') ||
        lastLine.startsWith('//')) {
      needsComma = false;
    }

    final prefix = needsComma ? ',\n${' ' * 8}' : '\n${' ' * 8}';
    final codeToInject = code.trim().endsWith(',')
        ? code.trim()
        : '${code.trim()},';

    final newSource = source.replaceRange(
      list.rightBracket.offset,
      list.rightBracket.offset,
      '$prefix$codeToInject\n${' ' * 6}',
    );

    final (_, updatedImports) = _insertImports(newSource.split('\n'), imports);
    await file.writeAsString(updatedImports ?? newSource);
  }

  Future<void> _injectL10n(YamlMap? yamlRaw) async {
    final path = yamlRaw?['path'] as String?;
    final imports = yamlRaw?['imports'] as YamlList?;
    final code = yamlRaw?['code'] as String?;

    if (path == null) {
      logger.info(
        'No L10n configuration found in reg.yaml. Skipping L10n injection.',
      );
      return;
    }

    final file = File(path);
    if (!await file.exists()) {
      logger.error(
        'L10n file not found at path: $path. Skipping L10n injection.',
      );
      return;
    }

    if (code == null) {
      logger.info('No L10n code found in reg.yaml. Skipping L10n injection.');
      return;
    }

    final source = await file.readAsString();
    if (source.contains(code.trim())) return;

    final parsed = parseString(content: source);
    final visitor = MainAppVisitor();
    parsed.unit.visitChildren(visitor);

    if (visitor.delegatesList == null) return;

    final list = visitor.delegatesList!;
    final innerContent = source.substring(
      list.leftBracket.end,
      list.rightBracket.offset,
    );

    final lines = innerContent
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty);

    final lastLine = lines.isNotEmpty ? lines.last : '';

    bool needsComma = true;
    if (lastLine.isEmpty ||
        lastLine.endsWith(',') ||
        lastLine.startsWith('//')) {
      needsComma = false;
    }

    final prefix = needsComma ? ',\n${' ' * 8}' : '\n${' ' * 8}';
    final codeToInject = code.trim().endsWith(',')
        ? code.trim()
        : '${code.trim()},';

    final newSource = source.replaceRange(
      list.rightBracket.offset,
      list.rightBracket.offset,
      '$prefix$codeToInject\n${' ' * 6}',
    );

    final (_, updatedImports) = _insertImports(newSource.split('\n'), imports);
    await file.writeAsString(updatedImports ?? newSource);
  }

  Future<void> _injectFailureX(YamlMap? yamlRaw) async {
    final path = yamlRaw?['path'] as String?;
    final imports = yamlRaw?['imports'] as YamlList?;
    final code = yamlRaw?['code'] as String?;

    if (path == null) {
      logger.info(
        'No FailureX configuration found in reg.yaml. Skipping FailureX injection.',
      );
      return;
    }

    final file = File(path);
    if (!await file.exists()) {
      logger.error(
        'FailureX file not found at path: $path. Skipping FailureX injection.',
      );
      return;
    }

    if (code == null) {
      logger.info(
        'No FailureX code found in reg.yaml. Skipping FailureX injection.',
      );
      return;
    }

    final source = await file.readAsString();
    final signature = code.split('\n').first.trim();
    if (source.contains(signature)) return;

    final parsed = parseString(content: source);
    final visitor = FailureXVisitor();
    parsed.unit.visitChildren(visitor);

    if (visitor.targetReturnStatement == null) return;

    final offset = visitor.targetReturnStatement!.offset;

    final newSource = source.replaceRange(offset, offset, '$code\n\n');

    final (_, updatedImports) = _insertImports(newSource.split('\n'), imports);
    await file.writeAsString(updatedImports ?? newSource);
  }
}

(bool, String?) _insertImports(List<String> fileLines, YamlList? imports) {
  if (imports == null || imports.isEmpty) return (false, null);

  final fileContent = fileLines.join('\n');
  final validImports = imports
      .map((e) => e.toString())
      .where((i) => !fileContent.contains(i))
      .toList();

  if (validImports.isEmpty) return (false, null);

  final lastImportIndex = fileLines.lastIndexWhere(
    (l) => l.startsWith('import '),
  );

  if (lastImportIndex != -1) {
    fileLines.insertAll(lastImportIndex + 1, validImports);
  } else {
    fileLines.insertAll(0, validImports);
  }

  return (true, fileLines.join('\n'));
}
