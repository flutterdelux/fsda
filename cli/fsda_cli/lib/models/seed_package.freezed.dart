// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'seed_package.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SeedPackage {

 Directory get workingDirectory; PackageSpec get spec;
/// Create a copy of SeedPackage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeedPackageCopyWith<SeedPackage> get copyWith => _$SeedPackageCopyWithImpl<SeedPackage>(this as SeedPackage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeedPackage&&(identical(other.workingDirectory, workingDirectory) || other.workingDirectory == workingDirectory)&&(identical(other.spec, spec) || other.spec == spec));
}


@override
int get hashCode => Object.hash(runtimeType,workingDirectory,spec);

@override
String toString() {
  return 'SeedPackage(workingDirectory: $workingDirectory, spec: $spec)';
}


}

/// @nodoc
abstract mixin class $SeedPackageCopyWith<$Res>  {
  factory $SeedPackageCopyWith(SeedPackage value, $Res Function(SeedPackage) _then) = _$SeedPackageCopyWithImpl;
@useResult
$Res call({
 Directory workingDirectory, PackageSpec spec
});


$PackageSpecCopyWith<$Res> get spec;

}
/// @nodoc
class _$SeedPackageCopyWithImpl<$Res>
    implements $SeedPackageCopyWith<$Res> {
  _$SeedPackageCopyWithImpl(this._self, this._then);

  final SeedPackage _self;
  final $Res Function(SeedPackage) _then;

/// Create a copy of SeedPackage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workingDirectory = null,Object? spec = null,}) {
  return _then(_self.copyWith(
workingDirectory: null == workingDirectory ? _self.workingDirectory : workingDirectory // ignore: cast_nullable_to_non_nullable
as Directory,spec: null == spec ? _self.spec : spec // ignore: cast_nullable_to_non_nullable
as PackageSpec,
  ));
}
/// Create a copy of SeedPackage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PackageSpecCopyWith<$Res> get spec {
  
  return $PackageSpecCopyWith<$Res>(_self.spec, (value) {
    return _then(_self.copyWith(spec: value));
  });
}
}


/// Adds pattern-matching-related methods to [SeedPackage].
extension SeedPackagePatterns on SeedPackage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeedPackage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeedPackage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeedPackage value)  $default,){
final _that = this;
switch (_that) {
case _SeedPackage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeedPackage value)?  $default,){
final _that = this;
switch (_that) {
case _SeedPackage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Directory workingDirectory,  PackageSpec spec)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeedPackage() when $default != null:
return $default(_that.workingDirectory,_that.spec);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Directory workingDirectory,  PackageSpec spec)  $default,) {final _that = this;
switch (_that) {
case _SeedPackage():
return $default(_that.workingDirectory,_that.spec);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Directory workingDirectory,  PackageSpec spec)?  $default,) {final _that = this;
switch (_that) {
case _SeedPackage() when $default != null:
return $default(_that.workingDirectory,_that.spec);case _:
  return null;

}
}

}

/// @nodoc


class _SeedPackage implements SeedPackage {
  const _SeedPackage({required this.workingDirectory, required this.spec});
  

@override final  Directory workingDirectory;
@override final  PackageSpec spec;

/// Create a copy of SeedPackage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeedPackageCopyWith<_SeedPackage> get copyWith => __$SeedPackageCopyWithImpl<_SeedPackage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeedPackage&&(identical(other.workingDirectory, workingDirectory) || other.workingDirectory == workingDirectory)&&(identical(other.spec, spec) || other.spec == spec));
}


@override
int get hashCode => Object.hash(runtimeType,workingDirectory,spec);

@override
String toString() {
  return 'SeedPackage(workingDirectory: $workingDirectory, spec: $spec)';
}


}

/// @nodoc
abstract mixin class _$SeedPackageCopyWith<$Res> implements $SeedPackageCopyWith<$Res> {
  factory _$SeedPackageCopyWith(_SeedPackage value, $Res Function(_SeedPackage) _then) = __$SeedPackageCopyWithImpl;
@override @useResult
$Res call({
 Directory workingDirectory, PackageSpec spec
});


@override $PackageSpecCopyWith<$Res> get spec;

}
/// @nodoc
class __$SeedPackageCopyWithImpl<$Res>
    implements _$SeedPackageCopyWith<$Res> {
  __$SeedPackageCopyWithImpl(this._self, this._then);

  final _SeedPackage _self;
  final $Res Function(_SeedPackage) _then;

/// Create a copy of SeedPackage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workingDirectory = null,Object? spec = null,}) {
  return _then(_SeedPackage(
workingDirectory: null == workingDirectory ? _self.workingDirectory : workingDirectory // ignore: cast_nullable_to_non_nullable
as Directory,spec: null == spec ? _self.spec : spec // ignore: cast_nullable_to_non_nullable
as PackageSpec,
  ));
}

/// Create a copy of SeedPackage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PackageSpecCopyWith<$Res> get spec {
  
  return $PackageSpecCopyWith<$Res>(_self.spec, (value) {
    return _then(_self.copyWith(spec: value));
  });
}
}

// dart format on
