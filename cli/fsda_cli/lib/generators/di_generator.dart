import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as p;

import '../enums/di_class_type.dart';
import '../models/di_argument.dart';
import '../models/di_class_info.dart';
import '../visitors/di_ast_visitor.dart';
import 'base_generator.dart';

class DiGenerator extends BaseGenerator<void, DiArgument> {
  const DiGenerator({required super.logger, required super.fileService});

  @override
  Future<void> generate(DiArgument args) async {
    final appName = args.app;
    final moduleName = args.module;

    final modulePath = p.join('apps', appName, 'lib', 'modules', moduleName);
    final diFilePath = p.join(modulePath, '${moduleName}_di.dart');
    final diFile = File(diFilePath);

    if (!await diFile.exists()) {
      logger.error('Module DI file not found at: $diFilePath');
      return;
    }

    final moduleDir = Directory(modulePath);
    if (!await moduleDir.exists()) {
      logger.error('Module directory not found: $modulePath');
      return;
    }

    logger.info('Scanning features in module [$moduleName]...');

    String diSource = await diFile.readAsString();

    final targetSubPaths = [
      p.join('data', 'datasources'),
      p.join('data', 'repositories'),
      p.join('domain', 'repositories'),
      p.join('domain', 'usecases'),
      'logic',
    ];

    await for (final entity in moduleDir.list()) {
      if (entity is! Directory) continue;

      final featureName = p.basename(entity.path);
      if (featureName.startsWith('.')) continue;

      final collectedClasses = <DiClassInfo>[];
      final filesToProcess = <File>[];

      for (final subPath in targetSubPaths) {
        final dirToScan = Directory(p.join(entity.path, subPath));
        if (dirToScan.existsSync()) {
          final files = dirToScan
              .listSync(recursive: true)
              .where((e) => e is File && e.path.endsWith('.dart'))
              .cast<File>();
          filesToProcess.addAll(files);
        }
      }

      if (filesToProcess.isEmpty) continue;

      for (final file in filesToProcess) {
        final content = await file.readAsString();
        final parsed = parseString(content: content);
        final visitor = DiAstVisitor();
        parsed.unit.visitChildren(visitor);

        for (final info in visitor.classes) {
          final relativePath = p.relative(
            file.path,
            from: p.join('apps', appName, 'lib'),
          );

          final updatedInfo = info.copyWith(
            importPath: "import 'package:$appName/$relativePath';",
          );

          collectedClasses.add(updatedInfo);
        }
      }

      if (collectedClasses.isEmpty) continue;

      final orderedTypes = [
        DiClassType.datasource,
        DiClassType.repository,
        DiClassType.usecase,
        DiClassType.logic,
      ];

      collectedClasses.sort(
        (a, b) => orderedTypes
            .indexOf(a.type!)
            .compareTo(orderedTypes.indexOf(b.type!)),
      );

      final privateMethodName = '_${featureName}DI';

      if (diSource.contains('void $privateMethodName()')) {
        logger.info(
          '⏩ Feature [$featureName] is already registered. Skipping.',
        );
        continue;
      }

      final buffer = StringBuffer();
      buffer.writeln('\n// $featureName feature');
      buffer.writeln('void $privateMethodName() {');

      buffer.writeln('  // Datasources');
      _writeLayer(buffer, collectedClasses, DiClassType.datasource);

      buffer.writeln('\n  // Repositories');
      _writeLayer(buffer, collectedClasses, DiClassType.repository);

      buffer.writeln('\n  // Usecases');
      _writeLayer(buffer, collectedClasses, DiClassType.usecase);

      buffer.writeln('\n  // Logic (Cubits/Blocs)');
      _writeLayer(buffer, collectedClasses, DiClassType.logic);

      buffer.writeln('}');

      final registerRegex = RegExp(
        r'static\s+Future<void>\s+register\s*\(\s*\)\s*async\s*\{([^}]*)\}',
      );
      final match = registerRegex.firstMatch(diSource);

      if (match != null) {
        final body = match.group(1) ?? '';
        String updatedBody;
        if (body.contains('// reg feature di')) {
          updatedBody = body.replaceFirst(
            '// reg feature di',
            '// reg feature di\n    $privateMethodName();',
          );
        } else {
          updatedBody = '$body    $privateMethodName();\n  ';
        }

        diSource = diSource.replaceRange(
          match.start + match.group(0)!.indexOf('{') + 1,
          match.end - 1,
          updatedBody,
        );
      }

      diSource = '${diSource.trimRight()}\n${buffer.toString()}\n';

      final imports = collectedClasses
          .map((e) => e.importPath)
          .whereType<String>()
          .toSet()
          .join('\n');

      if (imports.isNotEmpty) {
        diSource = '$imports\n$diSource';
      }

      logger.info('✅ Successfully injected feature [$featureName] into DI.');
    }

    await diFile.writeAsString(diSource);
  }

  void _writeLayer(
    StringBuffer buffer,
    List<DiClassInfo> classes,
    DiClassType type,
  ) {
    final filtered = classes.where((e) => e.type == type);
    for (final cls in filtered) {
      final paramsBuffer = StringBuffer();
      if (cls.parameters.isNotEmpty) {
        for (final param in cls.parameters) {
          if (param.isNamed) {
            paramsBuffer.write('${param.name}: sl(), ');
          } else {
            paramsBuffer.write('sl(), ');
          }
        }
      }

      if (type == DiClassType.datasource || type == DiClassType.repository) {
        final interface = cls.interfaceName ?? cls.className;
        buffer.writeln(
          '  sl.registerLazySingleton<$interface>(() => ${cls.className}($paramsBuffer));',
        );
      } else if (type == DiClassType.usecase) {
        buffer.writeln(
          '  sl.registerLazySingleton(() => ${cls.className}($paramsBuffer));',
        );
      } else if (type == DiClassType.logic) {
        buffer.writeln(
          '  sl.registerFactory(() => ${cls.className}($paramsBuffer));',
        );
      }
    }
  }
}
