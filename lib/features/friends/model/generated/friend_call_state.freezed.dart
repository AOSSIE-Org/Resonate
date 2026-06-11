// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../friend_call_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FriendCallState {

 FriendCallModel? get activeCall; bool get isMicOn; bool get isLoudSpeakerOn;
/// Create a copy of FriendCallState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FriendCallStateCopyWith<FriendCallState> get copyWith => _$FriendCallStateCopyWithImpl<FriendCallState>(this as FriendCallState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FriendCallState&&(identical(other.activeCall, activeCall) || other.activeCall == activeCall)&&(identical(other.isMicOn, isMicOn) || other.isMicOn == isMicOn)&&(identical(other.isLoudSpeakerOn, isLoudSpeakerOn) || other.isLoudSpeakerOn == isLoudSpeakerOn));
}


@override
int get hashCode => Object.hash(runtimeType,activeCall,isMicOn,isLoudSpeakerOn);

@override
String toString() {
  return 'FriendCallState(activeCall: $activeCall, isMicOn: $isMicOn, isLoudSpeakerOn: $isLoudSpeakerOn)';
}


}

/// @nodoc
abstract mixin class $FriendCallStateCopyWith<$Res>  {
  factory $FriendCallStateCopyWith(FriendCallState value, $Res Function(FriendCallState) _then) = _$FriendCallStateCopyWithImpl;
@useResult
$Res call({
 FriendCallModel? activeCall, bool isMicOn, bool isLoudSpeakerOn
});


$FriendCallModelCopyWith<$Res>? get activeCall;

}
/// @nodoc
class _$FriendCallStateCopyWithImpl<$Res>
    implements $FriendCallStateCopyWith<$Res> {
  _$FriendCallStateCopyWithImpl(this._self, this._then);

  final FriendCallState _self;
  final $Res Function(FriendCallState) _then;

/// Create a copy of FriendCallState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeCall = freezed,Object? isMicOn = null,Object? isLoudSpeakerOn = null,}) {
  return _then(_self.copyWith(
activeCall: freezed == activeCall ? _self.activeCall : activeCall // ignore: cast_nullable_to_non_nullable
as FriendCallModel?,isMicOn: null == isMicOn ? _self.isMicOn : isMicOn // ignore: cast_nullable_to_non_nullable
as bool,isLoudSpeakerOn: null == isLoudSpeakerOn ? _self.isLoudSpeakerOn : isLoudSpeakerOn // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of FriendCallState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FriendCallModelCopyWith<$Res>? get activeCall {
    if (_self.activeCall == null) {
    return null;
  }

  return $FriendCallModelCopyWith<$Res>(_self.activeCall!, (value) {
    return _then(_self.copyWith(activeCall: value));
  });
}
}


/// Adds pattern-matching-related methods to [FriendCallState].
extension FriendCallStatePatterns on FriendCallState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FriendCallState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FriendCallState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FriendCallState value)  $default,){
final _that = this;
switch (_that) {
case _FriendCallState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FriendCallState value)?  $default,){
final _that = this;
switch (_that) {
case _FriendCallState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FriendCallModel? activeCall,  bool isMicOn,  bool isLoudSpeakerOn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FriendCallState() when $default != null:
return $default(_that.activeCall,_that.isMicOn,_that.isLoudSpeakerOn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FriendCallModel? activeCall,  bool isMicOn,  bool isLoudSpeakerOn)  $default,) {final _that = this;
switch (_that) {
case _FriendCallState():
return $default(_that.activeCall,_that.isMicOn,_that.isLoudSpeakerOn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FriendCallModel? activeCall,  bool isMicOn,  bool isLoudSpeakerOn)?  $default,) {final _that = this;
switch (_that) {
case _FriendCallState() when $default != null:
return $default(_that.activeCall,_that.isMicOn,_that.isLoudSpeakerOn);case _:
  return null;

}
}

}

/// @nodoc


class _FriendCallState implements FriendCallState {
  const _FriendCallState({this.activeCall, this.isMicOn = false, this.isLoudSpeakerOn = true});
  

@override final  FriendCallModel? activeCall;
@override@JsonKey() final  bool isMicOn;
@override@JsonKey() final  bool isLoudSpeakerOn;

/// Create a copy of FriendCallState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FriendCallStateCopyWith<_FriendCallState> get copyWith => __$FriendCallStateCopyWithImpl<_FriendCallState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FriendCallState&&(identical(other.activeCall, activeCall) || other.activeCall == activeCall)&&(identical(other.isMicOn, isMicOn) || other.isMicOn == isMicOn)&&(identical(other.isLoudSpeakerOn, isLoudSpeakerOn) || other.isLoudSpeakerOn == isLoudSpeakerOn));
}


@override
int get hashCode => Object.hash(runtimeType,activeCall,isMicOn,isLoudSpeakerOn);

@override
String toString() {
  return 'FriendCallState(activeCall: $activeCall, isMicOn: $isMicOn, isLoudSpeakerOn: $isLoudSpeakerOn)';
}


}

/// @nodoc
abstract mixin class _$FriendCallStateCopyWith<$Res> implements $FriendCallStateCopyWith<$Res> {
  factory _$FriendCallStateCopyWith(_FriendCallState value, $Res Function(_FriendCallState) _then) = __$FriendCallStateCopyWithImpl;
@override @useResult
$Res call({
 FriendCallModel? activeCall, bool isMicOn, bool isLoudSpeakerOn
});


@override $FriendCallModelCopyWith<$Res>? get activeCall;

}
/// @nodoc
class __$FriendCallStateCopyWithImpl<$Res>
    implements _$FriendCallStateCopyWith<$Res> {
  __$FriendCallStateCopyWithImpl(this._self, this._then);

  final _FriendCallState _self;
  final $Res Function(_FriendCallState) _then;

/// Create a copy of FriendCallState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activeCall = freezed,Object? isMicOn = null,Object? isLoudSpeakerOn = null,}) {
  return _then(_FriendCallState(
activeCall: freezed == activeCall ? _self.activeCall : activeCall // ignore: cast_nullable_to_non_nullable
as FriendCallModel?,isMicOn: null == isMicOn ? _self.isMicOn : isMicOn // ignore: cast_nullable_to_non_nullable
as bool,isLoudSpeakerOn: null == isLoudSpeakerOn ? _self.isLoudSpeakerOn : isLoudSpeakerOn // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of FriendCallState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FriendCallModelCopyWith<$Res>? get activeCall {
    if (_self.activeCall == null) {
    return null;
  }

  return $FriendCallModelCopyWith<$Res>(_self.activeCall!, (value) {
    return _then(_self.copyWith(activeCall: value));
  });
}
}

// dart format on
