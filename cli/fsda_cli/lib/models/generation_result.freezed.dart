// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generation_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GenerationResult {

 String get message;
/// Create a copy of GenerationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerationResultCopyWith<GenerationResult> get copyWith => _$GenerationResultCopyWithImpl<GenerationResult>(this as GenerationResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerationResult&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'GenerationResult(message: $message)';
}


}

/// @nodoc
abstract mixin class $GenerationResultCopyWith<$Res>  {
  factory $GenerationResultCopyWith(GenerationResult value, $Res Function(GenerationResult) _then) = _$GenerationResultCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$GenerationResultCopyWithImpl<$Res>
    implements $GenerationResultCopyWith<$Res> {
  _$GenerationResultCopyWithImpl(this._self, this._then);

  final GenerationResult _self;
  final $Res Function(GenerationResult) _then;

/// Create a copy of GenerationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GenerationResult].
extension GenerationResultPatterns on GenerationResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _GenerationResultSuccess value)?  success,TResult Function( _GenerationResultFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenerationResultSuccess() when success != null:
return success(_that);case _GenerationResultFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _GenerationResultSuccess value)  success,required TResult Function( _GenerationResultFailure value)  failure,}){
final _that = this;
switch (_that) {
case _GenerationResultSuccess():
return success(_that);case _GenerationResultFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _GenerationResultSuccess value)?  success,TResult? Function( _GenerationResultFailure value)?  failure,}){
final _that = this;
switch (_that) {
case _GenerationResultSuccess() when success != null:
return success(_that);case _GenerationResultFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message,  List<String> files)?  success,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenerationResultSuccess() when success != null:
return success(_that.message,_that.files);case _GenerationResultFailure() when failure != null:
return failure(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message,  List<String> files)  success,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case _GenerationResultSuccess():
return success(_that.message,_that.files);case _GenerationResultFailure():
return failure(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message,  List<String> files)?  success,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case _GenerationResultSuccess() when success != null:
return success(_that.message,_that.files);case _GenerationResultFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _GenerationResultSuccess implements GenerationResult {
   _GenerationResultSuccess({required this.message, final  List<String> files = const []}): _files = files;
  

@override final  String message;
 final  List<String> _files;
@JsonKey() List<String> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}


/// Create a copy of GenerationResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenerationResultSuccessCopyWith<_GenerationResultSuccess> get copyWith => __$GenerationResultSuccessCopyWithImpl<_GenerationResultSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenerationResultSuccess&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._files, _files));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_files));

@override
String toString() {
  return 'GenerationResult.success(message: $message, files: $files)';
}


}

/// @nodoc
abstract mixin class _$GenerationResultSuccessCopyWith<$Res> implements $GenerationResultCopyWith<$Res> {
  factory _$GenerationResultSuccessCopyWith(_GenerationResultSuccess value, $Res Function(_GenerationResultSuccess) _then) = __$GenerationResultSuccessCopyWithImpl;
@override @useResult
$Res call({
 String message, List<String> files
});




}
/// @nodoc
class __$GenerationResultSuccessCopyWithImpl<$Res>
    implements _$GenerationResultSuccessCopyWith<$Res> {
  __$GenerationResultSuccessCopyWithImpl(this._self, this._then);

  final _GenerationResultSuccess _self;
  final $Res Function(_GenerationResultSuccess) _then;

/// Create a copy of GenerationResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? files = null,}) {
  return _then(_GenerationResultSuccess(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc


class _GenerationResultFailure implements GenerationResult {
   _GenerationResultFailure({required this.message});
  

@override final  String message;

/// Create a copy of GenerationResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenerationResultFailureCopyWith<_GenerationResultFailure> get copyWith => __$GenerationResultFailureCopyWithImpl<_GenerationResultFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenerationResultFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'GenerationResult.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class _$GenerationResultFailureCopyWith<$Res> implements $GenerationResultCopyWith<$Res> {
  factory _$GenerationResultFailureCopyWith(_GenerationResultFailure value, $Res Function(_GenerationResultFailure) _then) = __$GenerationResultFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class __$GenerationResultFailureCopyWithImpl<$Res>
    implements _$GenerationResultFailureCopyWith<$Res> {
  __$GenerationResultFailureCopyWithImpl(this._self, this._then);

  final _GenerationResultFailure _self;
  final $Res Function(_GenerationResultFailure) _then;

/// Create a copy of GenerationResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_GenerationResultFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
