// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../recording_playback_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecordingPlaybackState {

 String? get chapterId; bool get isPlaying; Duration get position; Duration get duration;
/// Create a copy of RecordingPlaybackState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecordingPlaybackStateCopyWith<RecordingPlaybackState> get copyWith => _$RecordingPlaybackStateCopyWithImpl<RecordingPlaybackState>(this as RecordingPlaybackState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecordingPlaybackState&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.position, position) || other.position == position)&&(identical(other.duration, duration) || other.duration == duration));
}


@override
int get hashCode => Object.hash(runtimeType,chapterId,isPlaying,position,duration);

@override
String toString() {
  return 'RecordingPlaybackState(chapterId: $chapterId, isPlaying: $isPlaying, position: $position, duration: $duration)';
}


}

/// @nodoc
abstract mixin class $RecordingPlaybackStateCopyWith<$Res>  {
  factory $RecordingPlaybackStateCopyWith(RecordingPlaybackState value, $Res Function(RecordingPlaybackState) _then) = _$RecordingPlaybackStateCopyWithImpl;
@useResult
$Res call({
 String? chapterId, bool isPlaying, Duration position, Duration duration
});




}
/// @nodoc
class _$RecordingPlaybackStateCopyWithImpl<$Res>
    implements $RecordingPlaybackStateCopyWith<$Res> {
  _$RecordingPlaybackStateCopyWithImpl(this._self, this._then);

  final RecordingPlaybackState _self;
  final $Res Function(RecordingPlaybackState) _then;

/// Create a copy of RecordingPlaybackState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chapterId = freezed,Object? isPlaying = null,Object? position = null,Object? duration = null,}) {
  return _then(_self.copyWith(
chapterId: freezed == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as String?,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}

}


/// Adds pattern-matching-related methods to [RecordingPlaybackState].
extension RecordingPlaybackStatePatterns on RecordingPlaybackState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecordingPlaybackState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecordingPlaybackState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecordingPlaybackState value)  $default,){
final _that = this;
switch (_that) {
case _RecordingPlaybackState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecordingPlaybackState value)?  $default,){
final _that = this;
switch (_that) {
case _RecordingPlaybackState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? chapterId,  bool isPlaying,  Duration position,  Duration duration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecordingPlaybackState() when $default != null:
return $default(_that.chapterId,_that.isPlaying,_that.position,_that.duration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? chapterId,  bool isPlaying,  Duration position,  Duration duration)  $default,) {final _that = this;
switch (_that) {
case _RecordingPlaybackState():
return $default(_that.chapterId,_that.isPlaying,_that.position,_that.duration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? chapterId,  bool isPlaying,  Duration position,  Duration duration)?  $default,) {final _that = this;
switch (_that) {
case _RecordingPlaybackState() when $default != null:
return $default(_that.chapterId,_that.isPlaying,_that.position,_that.duration);case _:
  return null;

}
}

}

/// @nodoc


class _RecordingPlaybackState implements RecordingPlaybackState {
  const _RecordingPlaybackState({this.chapterId, this.isPlaying = false, this.position = Duration.zero, this.duration = Duration.zero});
  

@override final  String? chapterId;
@override@JsonKey() final  bool isPlaying;
@override@JsonKey() final  Duration position;
@override@JsonKey() final  Duration duration;

/// Create a copy of RecordingPlaybackState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecordingPlaybackStateCopyWith<_RecordingPlaybackState> get copyWith => __$RecordingPlaybackStateCopyWithImpl<_RecordingPlaybackState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecordingPlaybackState&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.position, position) || other.position == position)&&(identical(other.duration, duration) || other.duration == duration));
}


@override
int get hashCode => Object.hash(runtimeType,chapterId,isPlaying,position,duration);

@override
String toString() {
  return 'RecordingPlaybackState(chapterId: $chapterId, isPlaying: $isPlaying, position: $position, duration: $duration)';
}


}

/// @nodoc
abstract mixin class _$RecordingPlaybackStateCopyWith<$Res> implements $RecordingPlaybackStateCopyWith<$Res> {
  factory _$RecordingPlaybackStateCopyWith(_RecordingPlaybackState value, $Res Function(_RecordingPlaybackState) _then) = __$RecordingPlaybackStateCopyWithImpl;
@override @useResult
$Res call({
 String? chapterId, bool isPlaying, Duration position, Duration duration
});




}
/// @nodoc
class __$RecordingPlaybackStateCopyWithImpl<$Res>
    implements _$RecordingPlaybackStateCopyWith<$Res> {
  __$RecordingPlaybackStateCopyWithImpl(this._self, this._then);

  final _RecordingPlaybackState _self;
  final $Res Function(_RecordingPlaybackState) _then;

/// Create a copy of RecordingPlaybackState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chapterId = freezed,Object? isPlaying = null,Object? position = null,Object? duration = null,}) {
  return _then(_RecordingPlaybackState(
chapterId: freezed == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as String?,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

// dart format on
