import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package_spec.dart';

part 'seed_package.freezed.dart';

@freezed
abstract class SeedPackage with _$SeedPackage {
  const factory SeedPackage({
    required Directory workingDirectory,
    required PackageSpec spec,
  }) = _SeedPackage;
}
