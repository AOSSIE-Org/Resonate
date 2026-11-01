// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../livekit_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LiveKitState {

 bool get isConnected; bool get isRecording; bool get hasSession;
/// Create a copy of LiveKitState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LiveKitStateCopyWith<LiveKitState> get copyWith => _$LiveKitStateCopyWithImpl<LiveKitState>(this as LiveKitState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LiveKitState&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.isRecording, isRecording) || other.isRecording == isRecording)&&(identical(other.hasSession, hasSession) || other.hasSession == hasSession));
}


@override
int get hashCode => Object.hash(runtimeType,isConnected,isRecording,hasSession);

@override
String toString() {
  return 'LiveKitState(isConnected: $isConnected, isRecording: $isRecording, hasSession: $hasSession)';
}


}

/// @nodoc
abstract mixin class $LiveKitStateCopyWith<$Res>  {
  factory $LiveKitStateCopyWith(LiveKitState value, $Res Function(LiveKitState) _then) = _$LiveKitStateCopyWithImpl;
@useResult
$Res call({
 bool isConnected, bool isRecording, bool hasSession
});




}
/// @nodoc
class _$LiveKitStateCopyWithImpl<$Res>
    implements $LiveKitStateCopyWith<$Res> {
  _$LiveKitStateCopyWithImpl(this._self, this._then);

  final LiveKitState _self;
  final $Res Function(LiveKitState) _then;

/// Create a copy of LiveKitState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isConnected = null,Object? isRecording = null,Object? hasSession = null,}) {
  return _then(_self.copyWith(
isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,isRecording: null == isRecording ? _self.isRecording : isRecording // ignore: cast_nullable_to_non_nullable
as bool,hasSession: null == hasSession ? _self.hasSession : hasSession // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LiveKitState].
extension LiveKitStatePatterns on LiveKitState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LiveKitState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LiveKitState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LiveKitState value)  $default,){
final _that = this;
switch (_that) {
case _LiveKitState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LiveKitState value)?  $default,){
final _that = this;
switch (_that) {
case _LiveKitState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isConnected,  bool isRecording,  bool hasSession)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LiveKitState() when $default != null:
return $default(_that.isConnected,_that.isRecording,_that.hasSession);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isConnected,  bool isRecording,  bool hasSession)  $default,) {final _that = this;
switch (_that) {
case _LiveKitState():
return $default(_that.isConnected,_that.isRecording,_that.hasSession);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isConnected,  bool isRecording,  bool hasSession)?  $default,) {final _that = this;
switch (_that) {
case _LiveKitState() when $default != null:
return $default(_that.isConnected,_that.isRecording,_that.hasSession);case _:
  return null;

}
}

}

/// @nodoc


class _LiveKitState implements LiveKitState {
  const _LiveKitState({this.isConnected = false, this.isRecording = false, this.hasSession = false});
  

@override@JsonKey() final  bool isConnected;
@override@JsonKey() final  bool isRecording;
@override@JsonKey() final  bool hasSession;

/// Create a copy of LiveKitState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LiveKitStateCopyWith<_LiveKitState> get copyWith => __$LiveKitStateCopyWithImpl<_LiveKitState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LiveKitState&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.isRecording, isRecording) || other.isRecording == isRecording)&&(identical(other.hasSession, hasSession) || other.hasSession == hasSession));
}


@override
int get hashCode => Object.hash(runtimeType,isConnected,isRecording,hasSession);

@override
String toString() {
  return 'LiveKitState(isConnected: $isConnected, isRecording: $isRecording, hasSession: $hasSession)';
}


}

/// @nodoc
abstract mixin class _$LiveKitStateCopyWith<$Res> implements $LiveKitStateCopyWith<$Res> {
  factory _$LiveKitStateCopyWith(_LiveKitState value, $Res Function(_LiveKitState) _then) = __$LiveKitStateCopyWithImpl;
@override @useResult
$Res call({
 bool isConnected, bool isRecording, bool hasSession
});




}
/// @nodoc
class __$LiveKitStateCopyWithImpl<$Res>
    implements _$LiveKitStateCopyWith<$Res> {
  __$LiveKitStateCopyWithImpl(this._self, this._then);

  final _LiveKitState _self;
  final $Res Function(_LiveKitState) _then;

/// Create a copy of LiveKitState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isConnected = null,Object? isRecording = null,Object? hasSession = null,}) {
  return _then(_LiveKitState(
isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,isRecording: null == isRecording ? _self.isRecording : isRecording // ignore: cast_nullable_to_non_nullable
as bool,hasSession: null == hasSession ? _self.hasSession : hasSession // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
