import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;

import '../models/package_spec.dart';
import '../models/seed_package.dart';
import 'seed_service.dart';

class ZipSeedService implements SeedService {
  final ZipDecoder zipDecoder;

  ZipSeedService({required this.zipDecoder});

  @override
  Future<SeedPackage> loadPackage(String name) async {
    final zipFile = File(zipPath);

    if (!await zipFile.exists()) {
      throw Exception('seeds.zip not found: $zipPath');
    }

    final bytes = await zipFile.readAsBytes();

    final archive = zipDecoder.decodeBytes(bytes);

    final tempRoot = await Directory.systemTemp.createTemp('fsda_seed_');

    await extractArchiveToDisk(archive, tempRoot.path);

    final packageDir = Directory(p.join(tempRoot.path, 'packages', name));

    if (!await packageDir.exists()) {
      throw Exception('Package "$name" not found inside seeds.zip');
    }

    final specFile = File(p.join(packageDir.path, 'pubspec.json'));

    final spec = PackageSpec.fromJson(
      jsonDecode(await specFile.readAsString()) as Map<String, dynamic>,
    );

    return SeedPackage(spec: spec, workingDirectory: packageDir);
  }

  @override
  Future<SeedPackage> loadInfra(String name) {
    // TODO: implement loadInfra
    throw UnimplementedError();
  }
}
