// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../single_room_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SingleRoomState {

 Participant get me; List<Participant> get participants; bool get wasKicked;
/// Create a copy of SingleRoomState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SingleRoomStateCopyWith<SingleRoomState> get copyWith => _$SingleRoomStateCopyWithImpl<SingleRoomState>(this as SingleRoomState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SingleRoomState&&(identical(other.me, me) || other.me == me)&&const DeepCollectionEquality().equals(other.participants, participants)&&(identical(other.wasKicked, wasKicked) || other.wasKicked == wasKicked));
}


@override
int get hashCode => Object.hash(runtimeType,me,const DeepCollectionEquality().hash(participants),wasKicked);

@override
String toString() {
  return 'SingleRoomState(me: $me, participants: $participants, wasKicked: $wasKicked)';
}


}

/// @nodoc
abstract mixin class $SingleRoomStateCopyWith<$Res>  {
  factory $SingleRoomStateCopyWith(SingleRoomState value, $Res Function(SingleRoomState) _then) = _$SingleRoomStateCopyWithImpl;
@useResult
$Res call({
 Participant me, List<Participant> participants, bool wasKicked
});


$ParticipantCopyWith<$Res> get me;

}
/// @nodoc
class _$SingleRoomStateCopyWithImpl<$Res>
    implements $SingleRoomStateCopyWith<$Res> {
  _$SingleRoomStateCopyWithImpl(this._self, this._then);

  final SingleRoomState _self;
  final $Res Function(SingleRoomState) _then;

/// Create a copy of SingleRoomState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? me = null,Object? participants = null,Object? wasKicked = null,}) {
  return _then(_self.copyWith(
me: null == me ? _self.me : me // ignore: cast_nullable_to_non_nullable
as Participant,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<Participant>,wasKicked: null == wasKicked ? _self.wasKicked : wasKicked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SingleRoomState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParticipantCopyWith<$Res> get me {
  
  return $ParticipantCopyWith<$Res>(_self.me, (value) {
    return _then(_self.copyWith(me: value));
  });
}
}


/// Adds pattern-matching-related methods to [SingleRoomState].
extension SingleRoomStatePatterns on SingleRoomState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SingleRoomState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SingleRoomState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SingleRoomState value)  $default,){
final _that = this;
switch (_that) {
case _SingleRoomState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SingleRoomState value)?  $default,){
final _that = this;
switch (_that) {
case _SingleRoomState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Participant me,  List<Participant> participants,  bool wasKicked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SingleRoomState() when $default != null:
return $default(_that.me,_that.participants,_that.wasKicked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Participant me,  List<Participant> participants,  bool wasKicked)  $default,) {final _that = this;
switch (_that) {
case _SingleRoomState():
return $default(_that.me,_that.participants,_that.wasKicked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Participant me,  List<Participant> participants,  bool wasKicked)?  $default,) {final _that = this;
switch (_that) {
case _SingleRoomState() when $default != null:
return $default(_that.me,_that.participants,_that.wasKicked);case _:
  return null;

}
}

}

/// @nodoc


class _SingleRoomState implements SingleRoomState {
  const _SingleRoomState({required this.me, final  List<Participant> participants = const <Participant>[], this.wasKicked = false}): _participants = participants;
  

@override final  Participant me;
 final  List<Participant> _participants;
@override@JsonKey() List<Participant> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

@override@JsonKey() final  bool wasKicked;

/// Create a copy of SingleRoomState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SingleRoomStateCopyWith<_SingleRoomState> get copyWith => __$SingleRoomStateCopyWithImpl<_SingleRoomState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SingleRoomState&&(identical(other.me, me) || other.me == me)&&const DeepCollectionEquality().equals(other._participants, _participants)&&(identical(other.wasKicked, wasKicked) || other.wasKicked == wasKicked));
}


@override
int get hashCode => Object.hash(runtimeType,me,const DeepCollectionEquality().hash(_participants),wasKicked);

@override
String toString() {
  return 'SingleRoomState(me: $me, participants: $participants, wasKicked: $wasKicked)';
}


}

/// @nodoc
abstract mixin class _$SingleRoomStateCopyWith<$Res> implements $SingleRoomStateCopyWith<$Res> {
  factory _$SingleRoomStateCopyWith(_SingleRoomState value, $Res Function(_SingleRoomState) _then) = __$SingleRoomStateCopyWithImpl;
@override @useResult
$Res call({
 Participant me, List<Participant> participants, bool wasKicked
});


@override $ParticipantCopyWith<$Res> get me;

}
/// @nodoc
class __$SingleRoomStateCopyWithImpl<$Res>
    implements _$SingleRoomStateCopyWith<$Res> {
  __$SingleRoomStateCopyWithImpl(this._self, this._then);

  final _SingleRoomState _self;
  final $Res Function(_SingleRoomState) _then;

/// Create a copy of SingleRoomState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? me = null,Object? participants = null,Object? wasKicked = null,}) {
  return _then(_SingleRoomState(
me: null == me ? _self.me : me // ignore: cast_nullable_to_non_nullable
as Participant,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<Participant>,wasKicked: null == wasKicked ? _self.wasKicked : wasKicked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SingleRoomState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParticipantCopyWith<$Res> get me {
  
  return $ParticipantCopyWith<$Res>(_self.me, (value) {
    return _then(_self.copyWith(me: value));
  });
}
}

// dart format on
