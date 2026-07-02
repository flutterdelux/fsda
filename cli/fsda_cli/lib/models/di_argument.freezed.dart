// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'di_argument.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiArgument {

 String? get app; String? get module;
/// Create a copy of DiArgument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiArgumentCopyWith<DiArgument> get copyWith => _$DiArgumentCopyWithImpl<DiArgument>(this as DiArgument, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiArgument&&(identical(other.app, app) || other.app == app)&&(identical(other.module, module) || other.module == module));
}


@override
int get hashCode => Object.hash(runtimeType,app,module);

@override
String toString() {
  return 'DiArgument(app: $app, module: $module)';
}


}

/// @nodoc
abstract mixin class $DiArgumentCopyWith<$Res>  {
  factory $DiArgumentCopyWith(DiArgument value, $Res Function(DiArgument) _then) = _$DiArgumentCopyWithImpl;
@useResult
$Res call({
 String? app, String? module
});




}
/// @nodoc
class _$DiArgumentCopyWithImpl<$Res>
    implements $DiArgumentCopyWith<$Res> {
  _$DiArgumentCopyWithImpl(this._self, this._then);

  final DiArgument _self;
  final $Res Function(DiArgument) _then;

/// Create a copy of DiArgument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? app = freezed,Object? module = freezed,}) {
  return _then(_self.copyWith(
app: freezed == app ? _self.app : app // ignore: cast_nullable_to_non_nullable
as String?,module: freezed == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiArgument].
extension DiArgumentPatterns on DiArgument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiArgument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiArgument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiArgument value)  $default,){
final _that = this;
switch (_that) {
case _DiArgument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiArgument value)?  $default,){
final _that = this;
switch (_that) {
case _DiArgument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? app,  String? module)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiArgument() when $default != null:
return $default(_that.app,_that.module);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? app,  String? module)  $default,) {final _that = this;
switch (_that) {
case _DiArgument():
return $default(_that.app,_that.module);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? app,  String? module)?  $default,) {final _that = this;
switch (_that) {
case _DiArgument() when $default != null:
return $default(_that.app,_that.module);case _:
  return null;

}
}

}

/// @nodoc


class _DiArgument extends DiArgument {
   _DiArgument({this.app, this.module}): super._();
  

@override final  String? app;
@override final  String? module;

/// Create a copy of DiArgument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiArgumentCopyWith<_DiArgument> get copyWith => __$DiArgumentCopyWithImpl<_DiArgument>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiArgument&&(identical(other.app, app) || other.app == app)&&(identical(other.module, module) || other.module == module));
}


@override
int get hashCode => Object.hash(runtimeType,app,module);

@override
String toString() {
  return 'DiArgument(app: $app, module: $module)';
}


}

/// @nodoc
abstract mixin class _$DiArgumentCopyWith<$Res> implements $DiArgumentCopyWith<$Res> {
  factory _$DiArgumentCopyWith(_DiArgument value, $Res Function(_DiArgument) _then) = __$DiArgumentCopyWithImpl;
@override @useResult
$Res call({
 String? app, String? module
});




}
/// @nodoc
class __$DiArgumentCopyWithImpl<$Res>
    implements _$DiArgumentCopyWith<$Res> {
  __$DiArgumentCopyWithImpl(this._self, this._then);

  final _DiArgument _self;
  final $Res Function(_DiArgument) _then;

/// Create a copy of DiArgument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? app = freezed,Object? module = freezed,}) {
  return _then(_DiArgument(
app: freezed == app ? _self.app : app // ignore: cast_nullable_to_non_nullable
as String?,module: freezed == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
