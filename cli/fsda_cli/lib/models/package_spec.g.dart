// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_spec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PackageSpec _$PackageSpecFromJson(Map<String, dynamic> json) => _PackageSpec(
  name: json['name'] as String,
  description: json['description'] as String,
  version: json['version'] as String? ?? '0.0.1',
  publishTo: json['publish_to'] as String,
  dependencies:
      (json['dependencies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  dependenciesManual:
      (json['dependencies_manual'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  devDependencies:
      (json['dev_dependencies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  devDependenciesManual:
      (json['dev_dependencies_manual'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  postHooks:
      (json['post_hooks'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$PackageSpecToJson(_PackageSpec instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'version': instance.version,
      'publish_to': instance.publishTo,
      'dependencies': instance.dependencies,
      'dependencies_manual': instance.dependenciesManual,
      'dev_dependencies': instance.devDependencies,
      'dev_dependencies_manual': instance.devDependenciesManual,
      'post_hooks': instance.postHooks,
    };
