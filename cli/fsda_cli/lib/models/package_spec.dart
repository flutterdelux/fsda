import 'package:freezed_annotation/freezed_annotation.dart';

part 'package_spec.freezed.dart';
part 'package_spec.g.dart';

@freezed
abstract class PackageSpec with _$PackageSpec {
  const factory PackageSpec({
    required String name,
    required String description,
    @Default('0.0.1') String version,
    required String publishTo,
    @Default([]) List<String> dependencies,
    @Default([]) List<String> dependenciesManual,
    @Default([]) List<String> devDependencies,
    @Default([]) List<String> devDependenciesManual,
    @Default([]) List<String> postHooks,
  }) = _PackageSpec;

  factory PackageSpec.fromJson(Map<String, dynamic> json) =>
      _$PackageSpecFromJson(json);
}
