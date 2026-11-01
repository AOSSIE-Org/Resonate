// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../audio_device_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AudioDeviceState {

 List<AudioDevice> get devices; AudioDevice? get selected;
/// Create a copy of AudioDeviceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioDeviceStateCopyWith<AudioDeviceState> get copyWith => _$AudioDeviceStateCopyWithImpl<AudioDeviceState>(this as AudioDeviceState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioDeviceState&&const DeepCollectionEquality().equals(other.devices, devices)&&(identical(other.selected, selected) || other.selected == selected));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(devices),selected);

@override
String toString() {
  return 'AudioDeviceState(devices: $devices, selected: $selected)';
}


}

/// @nodoc
abstract mixin class $AudioDeviceStateCopyWith<$Res>  {
  factory $AudioDeviceStateCopyWith(AudioDeviceState value, $Res Function(AudioDeviceState) _then) = _$AudioDeviceStateCopyWithImpl;
@useResult
$Res call({
 List<AudioDevice> devices, AudioDevice? selected
});




}
/// @nodoc
class _$AudioDeviceStateCopyWithImpl<$Res>
    implements $AudioDeviceStateCopyWith<$Res> {
  _$AudioDeviceStateCopyWithImpl(this._self, this._then);

  final AudioDeviceState _self;
  final $Res Function(AudioDeviceState) _then;

/// Create a copy of AudioDeviceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? devices = null,Object? selected = freezed,}) {
  return _then(_self.copyWith(
devices: null == devices ? _self.devices : devices // ignore: cast_nullable_to_non_nullable
as List<AudioDevice>,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as AudioDevice?,
  ));
}

}


/// Adds pattern-matching-related methods to [AudioDeviceState].
extension AudioDeviceStatePatterns on AudioDeviceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AudioDeviceState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AudioDeviceState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AudioDeviceState value)  $default,){
final _that = this;
switch (_that) {
case _AudioDeviceState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AudioDeviceState value)?  $default,){
final _that = this;
switch (_that) {
case _AudioDeviceState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AudioDevice> devices,  AudioDevice? selected)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AudioDeviceState() when $default != null:
return $default(_that.devices,_that.selected);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AudioDevice> devices,  AudioDevice? selected)  $default,) {final _that = this;
switch (_that) {
case _AudioDeviceState():
return $default(_that.devices,_that.selected);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AudioDevice> devices,  AudioDevice? selected)?  $default,) {final _that = this;
switch (_that) {
case _AudioDeviceState() when $default != null:
return $default(_that.devices,_that.selected);case _:
  return null;

}
}

}

/// @nodoc


class _AudioDeviceState implements AudioDeviceState {
  const _AudioDeviceState({final  List<AudioDevice> devices = const <AudioDevice>[], this.selected}): _devices = devices;
  

 final  List<AudioDevice> _devices;
@override@JsonKey() List<AudioDevice> get devices {
  if (_devices is EqualUnmodifiableListView) return _devices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_devices);
}

@override final  AudioDevice? selected;

/// Create a copy of AudioDeviceState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioDeviceStateCopyWith<_AudioDeviceState> get copyWith => __$AudioDeviceStateCopyWithImpl<_AudioDeviceState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioDeviceState&&const DeepCollectionEquality().equals(other._devices, _devices)&&(identical(other.selected, selected) || other.selected == selected));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_devices),selected);

@override
String toString() {
  return 'AudioDeviceState(devices: $devices, selected: $selected)';
}


}

/// @nodoc
abstract mixin class _$AudioDeviceStateCopyWith<$Res> implements $AudioDeviceStateCopyWith<$Res> {
  factory _$AudioDeviceStateCopyWith(_AudioDeviceState value, $Res Function(_AudioDeviceState) _then) = __$AudioDeviceStateCopyWithImpl;
@override @useResult
$Res call({
 List<AudioDevice> devices, AudioDevice? selected
});




}
/// @nodoc
class __$AudioDeviceStateCopyWithImpl<$Res>
    implements _$AudioDeviceStateCopyWith<$Res> {
  __$AudioDeviceStateCopyWithImpl(this._self, this._then);

  final _AudioDeviceState _self;
  final $Res Function(_AudioDeviceState) _then;

/// Create a copy of AudioDeviceState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? devices = null,Object? selected = freezed,}) {
  return _then(_AudioDeviceState(
devices: null == devices ? _self._devices : devices // ignore: cast_nullable_to_non_nullable
as List<AudioDevice>,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as AudioDevice?,
  ));
}


}

// dart format on
