// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cli_args.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CliArgs {

 String get command; String? get type; String? get name; Map<String, dynamic> get flags;
/// Create a copy of CliArgs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CliArgsCopyWith<CliArgs> get copyWith => _$CliArgsCopyWithImpl<CliArgs>(this as CliArgs, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CliArgs&&(identical(other.command, command) || other.command == command)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.flags, flags));
}


@override
int get hashCode => Object.hash(runtimeType,command,type,name,const DeepCollectionEquality().hash(flags));

@override
String toString() {
  return 'CliArgs(command: $command, type: $type, name: $name, flags: $flags)';
}


}

/// @nodoc
abstract mixin class $CliArgsCopyWith<$Res>  {
  factory $CliArgsCopyWith(CliArgs value, $Res Function(CliArgs) _then) = _$CliArgsCopyWithImpl;
@useResult
$Res call({
 String command, String? type, String? name, Map<String, dynamic> flags
});




}
/// @nodoc
class _$CliArgsCopyWithImpl<$Res>
    implements $CliArgsCopyWith<$Res> {
  _$CliArgsCopyWithImpl(this._self, this._then);

  final CliArgs _self;
  final $Res Function(CliArgs) _then;

/// Create a copy of CliArgs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? command = null,Object? type = freezed,Object? name = freezed,Object? flags = null,}) {
  return _then(_self.copyWith(
command: null == command ? _self.command : command // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,flags: null == flags ? _self.flags : flags // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [CliArgs].
extension CliArgsPatterns on CliArgs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CliArgs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CliArgs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CliArgs value)  $default,){
final _that = this;
switch (_that) {
case _CliArgs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CliArgs value)?  $default,){
final _that = this;
switch (_that) {
case _CliArgs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String command,  String? type,  String? name,  Map<String, dynamic> flags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CliArgs() when $default != null:
return $default(_that.command,_that.type,_that.name,_that.flags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String command,  String? type,  String? name,  Map<String, dynamic> flags)  $default,) {final _that = this;
switch (_that) {
case _CliArgs():
return $default(_that.command,_that.type,_that.name,_that.flags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String command,  String? type,  String? name,  Map<String, dynamic> flags)?  $default,) {final _that = this;
switch (_that) {
case _CliArgs() when $default != null:
return $default(_that.command,_that.type,_that.name,_that.flags);case _:
  return null;

}
}

}

/// @nodoc


class _CliArgs implements CliArgs {
  const _CliArgs({required this.command, this.type, this.name, final  Map<String, dynamic> flags = const {}}): _flags = flags;
  

@override final  String command;
@override final  String? type;
@override final  String? name;
 final  Map<String, dynamic> _flags;
@override@JsonKey() Map<String, dynamic> get flags {
  if (_flags is EqualUnmodifiableMapView) return _flags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_flags);
}


/// Create a copy of CliArgs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CliArgsCopyWith<_CliArgs> get copyWith => __$CliArgsCopyWithImpl<_CliArgs>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CliArgs&&(identical(other.command, command) || other.command == command)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._flags, _flags));
}


@override
int get hashCode => Object.hash(runtimeType,command,type,name,const DeepCollectionEquality().hash(_flags));

@override
String toString() {
  return 'CliArgs(command: $command, type: $type, name: $name, flags: $flags)';
}


}

/// @nodoc
abstract mixin class _$CliArgsCopyWith<$Res> implements $CliArgsCopyWith<$Res> {
  factory _$CliArgsCopyWith(_CliArgs value, $Res Function(_CliArgs) _then) = __$CliArgsCopyWithImpl;
@override @useResult
$Res call({
 String command, String? type, String? name, Map<String, dynamic> flags
});




}
/// @nodoc
class __$CliArgsCopyWithImpl<$Res>
    implements _$CliArgsCopyWith<$Res> {
  __$CliArgsCopyWithImpl(this._self, this._then);

  final _CliArgs _self;
  final $Res Function(_CliArgs) _then;

/// Create a copy of CliArgs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? command = null,Object? type = freezed,Object? name = freezed,Object? flags = null,}) {
  return _then(_CliArgs(
command: null == command ? _self.command : command // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,flags: null == flags ? _self._flags : flags // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
