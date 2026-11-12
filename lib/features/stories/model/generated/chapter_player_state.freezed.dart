// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../chapter_player_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChapterPlayerState {

 double get sliderProgress; bool get isPlaying;
/// Create a copy of ChapterPlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterPlayerStateCopyWith<ChapterPlayerState> get copyWith => _$ChapterPlayerStateCopyWithImpl<ChapterPlayerState>(this as ChapterPlayerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChapterPlayerState&&(identical(other.sliderProgress, sliderProgress) || other.sliderProgress == sliderProgress)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying));
}


@override
int get hashCode => Object.hash(runtimeType,sliderProgress,isPlaying);

@override
String toString() {
  return 'ChapterPlayerState(sliderProgress: $sliderProgress, isPlaying: $isPlaying)';
}


}

/// @nodoc
abstract mixin class $ChapterPlayerStateCopyWith<$Res>  {
  factory $ChapterPlayerStateCopyWith(ChapterPlayerState value, $Res Function(ChapterPlayerState) _then) = _$ChapterPlayerStateCopyWithImpl;
@useResult
$Res call({
 double sliderProgress, bool isPlaying
});




}
/// @nodoc
class _$ChapterPlayerStateCopyWithImpl<$Res>
    implements $ChapterPlayerStateCopyWith<$Res> {
  _$ChapterPlayerStateCopyWithImpl(this._self, this._then);

  final ChapterPlayerState _self;
  final $Res Function(ChapterPlayerState) _then;

/// Create a copy of ChapterPlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sliderProgress = null,Object? isPlaying = null,}) {
  return _then(_self.copyWith(
sliderProgress: null == sliderProgress ? _self.sliderProgress : sliderProgress // ignore: cast_nullable_to_non_nullable
as double,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChapterPlayerState].
extension ChapterPlayerStatePatterns on ChapterPlayerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChapterPlayerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChapterPlayerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChapterPlayerState value)  $default,){
final _that = this;
switch (_that) {
case _ChapterPlayerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChapterPlayerState value)?  $default,){
final _that = this;
switch (_that) {
case _ChapterPlayerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double sliderProgress,  bool isPlaying)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChapterPlayerState() when $default != null:
return $default(_that.sliderProgress,_that.isPlaying);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double sliderProgress,  bool isPlaying)  $default,) {final _that = this;
switch (_that) {
case _ChapterPlayerState():
return $default(_that.sliderProgress,_that.isPlaying);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double sliderProgress,  bool isPlaying)?  $default,) {final _that = this;
switch (_that) {
case _ChapterPlayerState() when $default != null:
return $default(_that.sliderProgress,_that.isPlaying);case _:
  return null;

}
}

}

/// @nodoc


class _ChapterPlayerState implements ChapterPlayerState {
  const _ChapterPlayerState({this.sliderProgress = 0.0, this.isPlaying = false});
  

@override@JsonKey() final  double sliderProgress;
@override@JsonKey() final  bool isPlaying;

/// Create a copy of ChapterPlayerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChapterPlayerStateCopyWith<_ChapterPlayerState> get copyWith => __$ChapterPlayerStateCopyWithImpl<_ChapterPlayerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChapterPlayerState&&(identical(other.sliderProgress, sliderProgress) || other.sliderProgress == sliderProgress)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying));
}


@override
int get hashCode => Object.hash(runtimeType,sliderProgress,isPlaying);

@override
String toString() {
  return 'ChapterPlayerState(sliderProgress: $sliderProgress, isPlaying: $isPlaying)';
}


}

/// @nodoc
abstract mixin class _$ChapterPlayerStateCopyWith<$Res> implements $ChapterPlayerStateCopyWith<$Res> {
  factory _$ChapterPlayerStateCopyWith(_ChapterPlayerState value, $Res Function(_ChapterPlayerState) _then) = __$ChapterPlayerStateCopyWithImpl;
@override @useResult
$Res call({
 double sliderProgress, bool isPlaying
});




}
/// @nodoc
class __$ChapterPlayerStateCopyWithImpl<$Res>
    implements _$ChapterPlayerStateCopyWith<$Res> {
  __$ChapterPlayerStateCopyWithImpl(this._self, this._then);

  final _ChapterPlayerState _self;
  final $Res Function(_ChapterPlayerState) _then;

/// Create a copy of ChapterPlayerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sliderProgress = null,Object? isPlaying = null,}) {
  return _then(_ChapterPlayerState(
sliderProgress: null == sliderProgress ? _self.sliderProgress : sliderProgress // ignore: cast_nullable_to_non_nullable
as double,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
