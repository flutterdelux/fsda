import 'dart:io';

import 'package:path/path.dart' as p;

class FileService {
  Future<void> copyDirectory({
    required Directory source,
    required Directory target,
  }) async {
    if (!await source.exists()) {
      throw Exception('Source directory not found: ${source.path}');
    }

    await target.create(recursive: true);

    await for (final entity in source.list()) {
      final name = p.basename(entity.path);

      final targetPath = p.join(target.path, name);

      if (entity is File) {
        await File(targetPath).create(recursive: true);

        await entity.copy(targetPath);
      } else if (entity is Directory) {
        await copyDirectory(source: entity, target: Directory(targetPath));
      }
    }
  }
}
