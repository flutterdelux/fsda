// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gen_argument.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GenArgument {

 String? get app; String? get module; String? get feature; String? get slice; String? get sequence; String? get method;
/// Create a copy of GenArgument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenArgumentCopyWith<GenArgument> get copyWith => _$GenArgumentCopyWithImpl<GenArgument>(this as GenArgument, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenArgument&&(identical(other.app, app) || other.app == app)&&(identical(other.module, module) || other.module == module)&&(identical(other.feature, feature) || other.feature == feature)&&(identical(other.slice, slice) || other.slice == slice)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.method, method) || other.method == method));
}


@override
int get hashCode => Object.hash(runtimeType,app,module,feature,slice,sequence,method);

@override
String toString() {
  return 'GenArgument(app: $app, module: $module, feature: $feature, slice: $slice, sequence: $sequence, method: $method)';
}


}

/// @nodoc
abstract mixin class $GenArgumentCopyWith<$Res>  {
  factory $GenArgumentCopyWith(GenArgument value, $Res Function(GenArgument) _then) = _$GenArgumentCopyWithImpl;
@useResult
$Res call({
 String? app, String? module, String? feature, String? slice, String? sequence, String? method
});




}
/// @nodoc
class _$GenArgumentCopyWithImpl<$Res>
    implements $GenArgumentCopyWith<$Res> {
  _$GenArgumentCopyWithImpl(this._self, this._then);

  final GenArgument _self;
  final $Res Function(GenArgument) _then;

/// Create a copy of GenArgument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? app = freezed,Object? module = freezed,Object? feature = freezed,Object? slice = freezed,Object? sequence = freezed,Object? method = freezed,}) {
  return _then(_self.copyWith(
app: freezed == app ? _self.app : app // ignore: cast_nullable_to_non_nullable
as String?,module: freezed == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as String?,feature: freezed == feature ? _self.feature : feature // ignore: cast_nullable_to_non_nullable
as String?,slice: freezed == slice ? _self.slice : slice // ignore: cast_nullable_to_non_nullable
as String?,sequence: freezed == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as String?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GenArgument].
extension GenArgumentPatterns on GenArgument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenArgument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenArgument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenArgument value)  $default,){
final _that = this;
switch (_that) {
case _GenArgument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenArgument value)?  $default,){
final _that = this;
switch (_that) {
case _GenArgument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? app,  String? module,  String? feature,  String? slice,  String? sequence,  String? method)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenArgument() when $default != null:
return $default(_that.app,_that.module,_that.feature,_that.slice,_that.sequence,_that.method);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? app,  String? module,  String? feature,  String? slice,  String? sequence,  String? method)  $default,) {final _that = this;
switch (_that) {
case _GenArgument():
return $default(_that.app,_that.module,_that.feature,_that.slice,_that.sequence,_that.method);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? app,  String? module,  String? feature,  String? slice,  String? sequence,  String? method)?  $default,) {final _that = this;
switch (_that) {
case _GenArgument() when $default != null:
return $default(_that.app,_that.module,_that.feature,_that.slice,_that.sequence,_that.method);case _:
  return null;

}
}

}

/// @nodoc


class _GenArgument extends GenArgument {
   _GenArgument({this.app, this.module, this.feature, this.slice, this.sequence, this.method}): super._();
  

@override final  String? app;
@override final  String? module;
@override final  String? feature;
@override final  String? slice;
@override final  String? sequence;
@override final  String? method;

/// Create a copy of GenArgument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenArgumentCopyWith<_GenArgument> get copyWith => __$GenArgumentCopyWithImpl<_GenArgument>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenArgument&&(identical(other.app, app) || other.app == app)&&(identical(other.module, module) || other.module == module)&&(identical(other.feature, feature) || other.feature == feature)&&(identical(other.slice, slice) || other.slice == slice)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.method, method) || other.method == method));
}


@override
int get hashCode => Object.hash(runtimeType,app,module,feature,slice,sequence,method);

@override
String toString() {
  return 'GenArgument(app: $app, module: $module, feature: $feature, slice: $slice, sequence: $sequence, method: $method)';
}


}

/// @nodoc
abstract mixin class _$GenArgumentCopyWith<$Res> implements $GenArgumentCopyWith<$Res> {
  factory _$GenArgumentCopyWith(_GenArgument value, $Res Function(_GenArgument) _then) = __$GenArgumentCopyWithImpl;
@override @useResult
$Res call({
 String? app, String? module, String? feature, String? slice, String? sequence, String? method
});




}
/// @nodoc
class __$GenArgumentCopyWithImpl<$Res>
    implements _$GenArgumentCopyWith<$Res> {
  __$GenArgumentCopyWithImpl(this._self, this._then);

  final _GenArgument _self;
  final $Res Function(_GenArgument) _then;

/// Create a copy of GenArgument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? app = freezed,Object? module = freezed,Object? feature = freezed,Object? slice = freezed,Object? sequence = freezed,Object? method = freezed,}) {
  return _then(_GenArgument(
app: freezed == app ? _self.app : app // ignore: cast_nullable_to_non_nullable
as String?,module: freezed == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as String?,feature: freezed == feature ? _self.feature : feature // ignore: cast_nullable_to_non_nullable
as String?,slice: freezed == slice ? _self.slice : slice // ignore: cast_nullable_to_non_nullable
as String?,sequence: freezed == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as String?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
