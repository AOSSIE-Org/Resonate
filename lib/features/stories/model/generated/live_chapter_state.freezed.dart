// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../live_chapter_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LiveChapterState {

 LiveChapterModel? get model; bool get isMicOn;
/// Create a copy of LiveChapterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LiveChapterStateCopyWith<LiveChapterState> get copyWith => _$LiveChapterStateCopyWithImpl<LiveChapterState>(this as LiveChapterState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LiveChapterState&&(identical(other.model, model) || other.model == model)&&(identical(other.isMicOn, isMicOn) || other.isMicOn == isMicOn));
}


@override
int get hashCode => Object.hash(runtimeType,model,isMicOn);

@override
String toString() {
  return 'LiveChapterState(model: $model, isMicOn: $isMicOn)';
}


}

/// @nodoc
abstract mixin class $LiveChapterStateCopyWith<$Res>  {
  factory $LiveChapterStateCopyWith(LiveChapterState value, $Res Function(LiveChapterState) _then) = _$LiveChapterStateCopyWithImpl;
@useResult
$Res call({
 LiveChapterModel? model, bool isMicOn
});


$LiveChapterModelCopyWith<$Res>? get model;

}
/// @nodoc
class _$LiveChapterStateCopyWithImpl<$Res>
    implements $LiveChapterStateCopyWith<$Res> {
  _$LiveChapterStateCopyWithImpl(this._self, this._then);

  final LiveChapterState _self;
  final $Res Function(LiveChapterState) _then;

/// Create a copy of LiveChapterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? model = freezed,Object? isMicOn = null,}) {
  return _then(_self.copyWith(
model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as LiveChapterModel?,isMicOn: null == isMicOn ? _self.isMicOn : isMicOn // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of LiveChapterState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LiveChapterModelCopyWith<$Res>? get model {
    if (_self.model == null) {
    return null;
  }

  return $LiveChapterModelCopyWith<$Res>(_self.model!, (value) {
    return _then(_self.copyWith(model: value));
  });
}
}


/// Adds pattern-matching-related methods to [LiveChapterState].
extension LiveChapterStatePatterns on LiveChapterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LiveChapterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LiveChapterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LiveChapterState value)  $default,){
final _that = this;
switch (_that) {
case _LiveChapterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LiveChapterState value)?  $default,){
final _that = this;
switch (_that) {
case _LiveChapterState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LiveChapterModel? model,  bool isMicOn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LiveChapterState() when $default != null:
return $default(_that.model,_that.isMicOn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LiveChapterModel? model,  bool isMicOn)  $default,) {final _that = this;
switch (_that) {
case _LiveChapterState():
return $default(_that.model,_that.isMicOn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LiveChapterModel? model,  bool isMicOn)?  $default,) {final _that = this;
switch (_that) {
case _LiveChapterState() when $default != null:
return $default(_that.model,_that.isMicOn);case _:
  return null;

}
}

}

/// @nodoc


class _LiveChapterState implements LiveChapterState {
  const _LiveChapterState({this.model, this.isMicOn = false});
  

@override final  LiveChapterModel? model;
@override@JsonKey() final  bool isMicOn;

/// Create a copy of LiveChapterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LiveChapterStateCopyWith<_LiveChapterState> get copyWith => __$LiveChapterStateCopyWithImpl<_LiveChapterState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LiveChapterState&&(identical(other.model, model) || other.model == model)&&(identical(other.isMicOn, isMicOn) || other.isMicOn == isMicOn));
}


@override
int get hashCode => Object.hash(runtimeType,model,isMicOn);

@override
String toString() {
  return 'LiveChapterState(model: $model, isMicOn: $isMicOn)';
}


}

/// @nodoc
abstract mixin class _$LiveChapterStateCopyWith<$Res> implements $LiveChapterStateCopyWith<$Res> {
  factory _$LiveChapterStateCopyWith(_LiveChapterState value, $Res Function(_LiveChapterState) _then) = __$LiveChapterStateCopyWithImpl;
@override @useResult
$Res call({
 LiveChapterModel? model, bool isMicOn
});


@override $LiveChapterModelCopyWith<$Res>? get model;

}
/// @nodoc
class __$LiveChapterStateCopyWithImpl<$Res>
    implements _$LiveChapterStateCopyWith<$Res> {
  __$LiveChapterStateCopyWithImpl(this._self, this._then);

  final _LiveChapterState _self;
  final $Res Function(_LiveChapterState) _then;

/// Create a copy of LiveChapterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? model = freezed,Object? isMicOn = null,}) {
  return _then(_LiveChapterState(
model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as LiveChapterModel?,isMicOn: null == isMicOn ? _self.isMicOn : isMicOn // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of LiveChapterState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LiveChapterModelCopyWith<$Res>? get model {
    if (_self.model == null) {
    return null;
  }

  return $LiveChapterModelCopyWith<$Res>(_self.model!, (value) {
    return _then(_self.copyWith(model: value));
  });
}
}

// dart format on
