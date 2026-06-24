// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package_spec.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PackageSpec {

 String get name; String get description; String get version; String get publishTo; List<String> get dependencies; List<String> get dependenciesManual; List<String> get devDependencies; List<String> get devDependenciesManual; List<String> get postHooks;
/// Create a copy of PackageSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PackageSpecCopyWith<PackageSpec> get copyWith => _$PackageSpecCopyWithImpl<PackageSpec>(this as PackageSpec, _$identity);

  /// Serializes this PackageSpec to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PackageSpec&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.version, version) || other.version == version)&&(identical(other.publishTo, publishTo) || other.publishTo == publishTo)&&const DeepCollectionEquality().equals(other.dependencies, dependencies)&&const DeepCollectionEquality().equals(other.dependenciesManual, dependenciesManual)&&const DeepCollectionEquality().equals(other.devDependencies, devDependencies)&&const DeepCollectionEquality().equals(other.devDependenciesManual, devDependenciesManual)&&const DeepCollectionEquality().equals(other.postHooks, postHooks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,version,publishTo,const DeepCollectionEquality().hash(dependencies),const DeepCollectionEquality().hash(dependenciesManual),const DeepCollectionEquality().hash(devDependencies),const DeepCollectionEquality().hash(devDependenciesManual),const DeepCollectionEquality().hash(postHooks));

@override
String toString() {
  return 'PackageSpec(name: $name, description: $description, version: $version, publishTo: $publishTo, dependencies: $dependencies, dependenciesManual: $dependenciesManual, devDependencies: $devDependencies, devDependenciesManual: $devDependenciesManual, postHooks: $postHooks)';
}


}

/// @nodoc
abstract mixin class $PackageSpecCopyWith<$Res>  {
  factory $PackageSpecCopyWith(PackageSpec value, $Res Function(PackageSpec) _then) = _$PackageSpecCopyWithImpl;
@useResult
$Res call({
 String name, String description, String version, String publishTo, List<String> dependencies, List<String> dependenciesManual, List<String> devDependencies, List<String> devDependenciesManual, List<String> postHooks
});




}
/// @nodoc
class _$PackageSpecCopyWithImpl<$Res>
    implements $PackageSpecCopyWith<$Res> {
  _$PackageSpecCopyWithImpl(this._self, this._then);

  final PackageSpec _self;
  final $Res Function(PackageSpec) _then;

/// Create a copy of PackageSpec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = null,Object? version = null,Object? publishTo = null,Object? dependencies = null,Object? dependenciesManual = null,Object? devDependencies = null,Object? devDependenciesManual = null,Object? postHooks = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,publishTo: null == publishTo ? _self.publishTo : publishTo // ignore: cast_nullable_to_non_nullable
as String,dependencies: null == dependencies ? _self.dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as List<String>,dependenciesManual: null == dependenciesManual ? _self.dependenciesManual : dependenciesManual // ignore: cast_nullable_to_non_nullable
as List<String>,devDependencies: null == devDependencies ? _self.devDependencies : devDependencies // ignore: cast_nullable_to_non_nullable
as List<String>,devDependenciesManual: null == devDependenciesManual ? _self.devDependenciesManual : devDependenciesManual // ignore: cast_nullable_to_non_nullable
as List<String>,postHooks: null == postHooks ? _self.postHooks : postHooks // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PackageSpec].
extension PackageSpecPatterns on PackageSpec {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PackageSpec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PackageSpec() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PackageSpec value)  $default,){
final _that = this;
switch (_that) {
case _PackageSpec():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PackageSpec value)?  $default,){
final _that = this;
switch (_that) {
case _PackageSpec() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String description,  String version,  String publishTo,  List<String> dependencies,  List<String> dependenciesManual,  List<String> devDependencies,  List<String> devDependenciesManual,  List<String> postHooks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PackageSpec() when $default != null:
return $default(_that.name,_that.description,_that.version,_that.publishTo,_that.dependencies,_that.dependenciesManual,_that.devDependencies,_that.devDependenciesManual,_that.postHooks);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String description,  String version,  String publishTo,  List<String> dependencies,  List<String> dependenciesManual,  List<String> devDependencies,  List<String> devDependenciesManual,  List<String> postHooks)  $default,) {final _that = this;
switch (_that) {
case _PackageSpec():
return $default(_that.name,_that.description,_that.version,_that.publishTo,_that.dependencies,_that.dependenciesManual,_that.devDependencies,_that.devDependenciesManual,_that.postHooks);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String description,  String version,  String publishTo,  List<String> dependencies,  List<String> dependenciesManual,  List<String> devDependencies,  List<String> devDependenciesManual,  List<String> postHooks)?  $default,) {final _that = this;
switch (_that) {
case _PackageSpec() when $default != null:
return $default(_that.name,_that.description,_that.version,_that.publishTo,_that.dependencies,_that.dependenciesManual,_that.devDependencies,_that.devDependenciesManual,_that.postHooks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PackageSpec implements PackageSpec {
  const _PackageSpec({required this.name, required this.description, this.version = '0.0.1', required this.publishTo, final  List<String> dependencies = const [], final  List<String> dependenciesManual = const [], final  List<String> devDependencies = const [], final  List<String> devDependenciesManual = const [], final  List<String> postHooks = const []}): _dependencies = dependencies,_dependenciesManual = dependenciesManual,_devDependencies = devDependencies,_devDependenciesManual = devDependenciesManual,_postHooks = postHooks;
  factory _PackageSpec.fromJson(Map<String, dynamic> json) => _$PackageSpecFromJson(json);

@override final  String name;
@override final  String description;
@override@JsonKey() final  String version;
@override final  String publishTo;
 final  List<String> _dependencies;
@override@JsonKey() List<String> get dependencies {
  if (_dependencies is EqualUnmodifiableListView) return _dependencies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dependencies);
}

 final  List<String> _dependenciesManual;
@override@JsonKey() List<String> get dependenciesManual {
  if (_dependenciesManual is EqualUnmodifiableListView) return _dependenciesManual;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dependenciesManual);
}

 final  List<String> _devDependencies;
@override@JsonKey() List<String> get devDependencies {
  if (_devDependencies is EqualUnmodifiableListView) return _devDependencies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_devDependencies);
}

 final  List<String> _devDependenciesManual;
@override@JsonKey() List<String> get devDependenciesManual {
  if (_devDependenciesManual is EqualUnmodifiableListView) return _devDependenciesManual;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_devDependenciesManual);
}

 final  List<String> _postHooks;
@override@JsonKey() List<String> get postHooks {
  if (_postHooks is EqualUnmodifiableListView) return _postHooks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_postHooks);
}


/// Create a copy of PackageSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PackageSpecCopyWith<_PackageSpec> get copyWith => __$PackageSpecCopyWithImpl<_PackageSpec>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PackageSpecToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PackageSpec&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.version, version) || other.version == version)&&(identical(other.publishTo, publishTo) || other.publishTo == publishTo)&&const DeepCollectionEquality().equals(other._dependencies, _dependencies)&&const DeepCollectionEquality().equals(other._dependenciesManual, _dependenciesManual)&&const DeepCollectionEquality().equals(other._devDependencies, _devDependencies)&&const DeepCollectionEquality().equals(other._devDependenciesManual, _devDependenciesManual)&&const DeepCollectionEquality().equals(other._postHooks, _postHooks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,version,publishTo,const DeepCollectionEquality().hash(_dependencies),const DeepCollectionEquality().hash(_dependenciesManual),const DeepCollectionEquality().hash(_devDependencies),const DeepCollectionEquality().hash(_devDependenciesManual),const DeepCollectionEquality().hash(_postHooks));

@override
String toString() {
  return 'PackageSpec(name: $name, description: $description, version: $version, publishTo: $publishTo, dependencies: $dependencies, dependenciesManual: $dependenciesManual, devDependencies: $devDependencies, devDependenciesManual: $devDependenciesManual, postHooks: $postHooks)';
}


}

/// @nodoc
abstract mixin class _$PackageSpecCopyWith<$Res> implements $PackageSpecCopyWith<$Res> {
  factory _$PackageSpecCopyWith(_PackageSpec value, $Res Function(_PackageSpec) _then) = __$PackageSpecCopyWithImpl;
@override @useResult
$Res call({
 String name, String description, String version, String publishTo, List<String> dependencies, List<String> dependenciesManual, List<String> devDependencies, List<String> devDependenciesManual, List<String> postHooks
});




}
/// @nodoc
class __$PackageSpecCopyWithImpl<$Res>
    implements _$PackageSpecCopyWith<$Res> {
  __$PackageSpecCopyWithImpl(this._self, this._then);

  final _PackageSpec _self;
  final $Res Function(_PackageSpec) _then;

/// Create a copy of PackageSpec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = null,Object? version = null,Object? publishTo = null,Object? dependencies = null,Object? dependenciesManual = null,Object? devDependencies = null,Object? devDependenciesManual = null,Object? postHooks = null,}) {
  return _then(_PackageSpec(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,publishTo: null == publishTo ? _self.publishTo : publishTo // ignore: cast_nullable_to_non_nullable
as String,dependencies: null == dependencies ? _self._dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as List<String>,dependenciesManual: null == dependenciesManual ? _self._dependenciesManual : dependenciesManual // ignore: cast_nullable_to_non_nullable
as List<String>,devDependencies: null == devDependencies ? _self._devDependencies : devDependencies // ignore: cast_nullable_to_non_nullable
as List<String>,devDependenciesManual: null == devDependenciesManual ? _self._devDependenciesManual : devDependenciesManual // ignore: cast_nullable_to_non_nullable
as List<String>,postHooks: null == postHooks ? _self._postHooks : postHooks // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
