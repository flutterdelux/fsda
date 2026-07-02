// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reg_argument.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RegArgument {

 String? get app; String? get module;
/// Create a copy of RegArgument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegArgumentCopyWith<RegArgument> get copyWith => _$RegArgumentCopyWithImpl<RegArgument>(this as RegArgument, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegArgument&&(identical(other.app, app) || other.app == app)&&(identical(other.module, module) || other.module == module));
}


@override
int get hashCode => Object.hash(runtimeType,app,module);

@override
String toString() {
  return 'RegArgument(app: $app, module: $module)';
}


}

/// @nodoc
abstract mixin class $RegArgumentCopyWith<$Res>  {
  factory $RegArgumentCopyWith(RegArgument value, $Res Function(RegArgument) _then) = _$RegArgumentCopyWithImpl;
@useResult
$Res call({
 String? app, String? module
});




}
/// @nodoc
class _$RegArgumentCopyWithImpl<$Res>
    implements $RegArgumentCopyWith<$Res> {
  _$RegArgumentCopyWithImpl(this._self, this._then);

  final RegArgument _self;
  final $Res Function(RegArgument) _then;

/// Create a copy of RegArgument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? app = freezed,Object? module = freezed,}) {
  return _then(_self.copyWith(
app: freezed == app ? _self.app : app // ignore: cast_nullable_to_non_nullable
as String?,module: freezed == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RegArgument].
extension RegArgumentPatterns on RegArgument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegArgument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegArgument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegArgument value)  $default,){
final _that = this;
switch (_that) {
case _RegArgument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegArgument value)?  $default,){
final _that = this;
switch (_that) {
case _RegArgument() when $default != null:
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
case _RegArgument() when $default != null:
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
case _RegArgument():
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
case _RegArgument() when $default != null:
return $default(_that.app,_that.module);case _:
  return null;

}
}

}

/// @nodoc


class _RegArgument extends RegArgument {
   _RegArgument({this.app, this.module}): super._();
  

@override final  String? app;
@override final  String? module;

/// Create a copy of RegArgument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegArgumentCopyWith<_RegArgument> get copyWith => __$RegArgumentCopyWithImpl<_RegArgument>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegArgument&&(identical(other.app, app) || other.app == app)&&(identical(other.module, module) || other.module == module));
}


@override
int get hashCode => Object.hash(runtimeType,app,module);

@override
String toString() {
  return 'RegArgument(app: $app, module: $module)';
}


}

/// @nodoc
abstract mixin class _$RegArgumentCopyWith<$Res> implements $RegArgumentCopyWith<$Res> {
  factory _$RegArgumentCopyWith(_RegArgument value, $Res Function(_RegArgument) _then) = __$RegArgumentCopyWithImpl;
@override @useResult
$Res call({
 String? app, String? module
});




}
/// @nodoc
class __$RegArgumentCopyWithImpl<$Res>
    implements _$RegArgumentCopyWith<$Res> {
  __$RegArgumentCopyWithImpl(this._self, this._then);

  final _RegArgument _self;
  final $Res Function(_RegArgument) _then;

/// Create a copy of RegArgument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? app = freezed,Object? module = freezed,}) {
  return _then(_RegArgument(
app: freezed == app ? _self.app : app // ignore: cast_nullable_to_non_nullable
as String?,module: freezed == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
