// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../room_polls_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoomPollsState {

 List<Poll> get polls; List<PollVote> get votes;
/// Create a copy of RoomPollsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomPollsStateCopyWith<RoomPollsState> get copyWith => _$RoomPollsStateCopyWithImpl<RoomPollsState>(this as RoomPollsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomPollsState&&const DeepCollectionEquality().equals(other.polls, polls)&&const DeepCollectionEquality().equals(other.votes, votes));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(polls),const DeepCollectionEquality().hash(votes));

@override
String toString() {
  return 'RoomPollsState(polls: $polls, votes: $votes)';
}


}

/// @nodoc
abstract mixin class $RoomPollsStateCopyWith<$Res>  {
  factory $RoomPollsStateCopyWith(RoomPollsState value, $Res Function(RoomPollsState) _then) = _$RoomPollsStateCopyWithImpl;
@useResult
$Res call({
 List<Poll> polls, List<PollVote> votes
});




}
/// @nodoc
class _$RoomPollsStateCopyWithImpl<$Res>
    implements $RoomPollsStateCopyWith<$Res> {
  _$RoomPollsStateCopyWithImpl(this._self, this._then);

  final RoomPollsState _self;
  final $Res Function(RoomPollsState) _then;

/// Create a copy of RoomPollsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? polls = null,Object? votes = null,}) {
  return _then(_self.copyWith(
polls: null == polls ? _self.polls : polls // ignore: cast_nullable_to_non_nullable
as List<Poll>,votes: null == votes ? _self.votes : votes // ignore: cast_nullable_to_non_nullable
as List<PollVote>,
  ));
}

}


/// Adds pattern-matching-related methods to [RoomPollsState].
extension RoomPollsStatePatterns on RoomPollsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomPollsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomPollsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomPollsState value)  $default,){
final _that = this;
switch (_that) {
case _RoomPollsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomPollsState value)?  $default,){
final _that = this;
switch (_that) {
case _RoomPollsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Poll> polls,  List<PollVote> votes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomPollsState() when $default != null:
return $default(_that.polls,_that.votes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Poll> polls,  List<PollVote> votes)  $default,) {final _that = this;
switch (_that) {
case _RoomPollsState():
return $default(_that.polls,_that.votes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Poll> polls,  List<PollVote> votes)?  $default,) {final _that = this;
switch (_that) {
case _RoomPollsState() when $default != null:
return $default(_that.polls,_that.votes);case _:
  return null;

}
}

}

/// @nodoc


class _RoomPollsState extends RoomPollsState {
  const _RoomPollsState({final  List<Poll> polls = const <Poll>[], final  List<PollVote> votes = const <PollVote>[]}): _polls = polls,_votes = votes,super._();
  

 final  List<Poll> _polls;
@override@JsonKey() List<Poll> get polls {
  if (_polls is EqualUnmodifiableListView) return _polls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_polls);
}

 final  List<PollVote> _votes;
@override@JsonKey() List<PollVote> get votes {
  if (_votes is EqualUnmodifiableListView) return _votes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_votes);
}


/// Create a copy of RoomPollsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomPollsStateCopyWith<_RoomPollsState> get copyWith => __$RoomPollsStateCopyWithImpl<_RoomPollsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomPollsState&&const DeepCollectionEquality().equals(other._polls, _polls)&&const DeepCollectionEquality().equals(other._votes, _votes));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_polls),const DeepCollectionEquality().hash(_votes));

@override
String toString() {
  return 'RoomPollsState(polls: $polls, votes: $votes)';
}


}

/// @nodoc
abstract mixin class _$RoomPollsStateCopyWith<$Res> implements $RoomPollsStateCopyWith<$Res> {
  factory _$RoomPollsStateCopyWith(_RoomPollsState value, $Res Function(_RoomPollsState) _then) = __$RoomPollsStateCopyWithImpl;
@override @useResult
$Res call({
 List<Poll> polls, List<PollVote> votes
});




}
/// @nodoc
class __$RoomPollsStateCopyWithImpl<$Res>
    implements _$RoomPollsStateCopyWith<$Res> {
  __$RoomPollsStateCopyWithImpl(this._self, this._then);

  final _RoomPollsState _self;
  final $Res Function(_RoomPollsState) _then;

/// Create a copy of RoomPollsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? polls = null,Object? votes = null,}) {
  return _then(_RoomPollsState(
polls: null == polls ? _self._polls : polls // ignore: cast_nullable_to_non_nullable
as List<Poll>,votes: null == votes ? _self._votes : votes // ignore: cast_nullable_to_non_nullable
as List<PollVote>,
  ));
}


}

// dart format on
