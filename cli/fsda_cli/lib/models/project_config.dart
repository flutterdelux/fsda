import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_config.freezed.dart';

@freezed
abstract class ProjectConfig with _$ProjectConfig {
  const factory ProjectConfig({
    required String projectName,
    required String basePath,
  }) = _ProjectConfig;
}
