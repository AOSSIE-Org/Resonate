// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../poll_vote.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PollVote {

// Row id doubles as the vote id, mirroring Poll. A unique (pollId, uid)
// index server-side rejects duplicate votes with a 409.
@JsonKey(name: r'$id') String get voteId; String get pollId; String get roomId; String get uid; int get optionIndex;
/// Create a copy of PollVote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PollVoteCopyWith<PollVote> get copyWith => _$PollVoteCopyWithImpl<PollVote>(this as PollVote, _$identity);

  /// Serializes this PollVote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PollVote&&(identical(other.voteId, voteId) || other.voteId == voteId)&&(identical(other.pollId, pollId) || other.pollId == pollId)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.optionIndex, optionIndex) || other.optionIndex == optionIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,voteId,pollId,roomId,uid,optionIndex);

@override
String toString() {
  return 'PollVote(voteId: $voteId, pollId: $pollId, roomId: $roomId, uid: $uid, optionIndex: $optionIndex)';
}


}

/// @nodoc
abstract mixin class $PollVoteCopyWith<$Res>  {
  factory $PollVoteCopyWith(PollVote value, $Res Function(PollVote) _then) = _$PollVoteCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: r'$id') String voteId, String pollId, String roomId, String uid, int optionIndex
});




}
/// @nodoc
class _$PollVoteCopyWithImpl<$Res>
    implements $PollVoteCopyWith<$Res> {
  _$PollVoteCopyWithImpl(this._self, this._then);

  final PollVote _self;
  final $Res Function(PollVote) _then;

/// Create a copy of PollVote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? voteId = null,Object? pollId = null,Object? roomId = null,Object? uid = null,Object? optionIndex = null,}) {
  return _then(_self.copyWith(
voteId: null == voteId ? _self.voteId : voteId // ignore: cast_nullable_to_non_nullable
as String,pollId: null == pollId ? _self.pollId : pollId // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,optionIndex: null == optionIndex ? _self.optionIndex : optionIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PollVote].
extension PollVotePatterns on PollVote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PollVote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PollVote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PollVote value)  $default,){
final _that = this;
switch (_that) {
case _PollVote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PollVote value)?  $default,){
final _that = this;
switch (_that) {
case _PollVote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: r'$id')  String voteId,  String pollId,  String roomId,  String uid,  int optionIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PollVote() when $default != null:
return $default(_that.voteId,_that.pollId,_that.roomId,_that.uid,_that.optionIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: r'$id')  String voteId,  String pollId,  String roomId,  String uid,  int optionIndex)  $default,) {final _that = this;
switch (_that) {
case _PollVote():
return $default(_that.voteId,_that.pollId,_that.roomId,_that.uid,_that.optionIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: r'$id')  String voteId,  String pollId,  String roomId,  String uid,  int optionIndex)?  $default,) {final _that = this;
switch (_that) {
case _PollVote() when $default != null:
return $default(_that.voteId,_that.pollId,_that.roomId,_that.uid,_that.optionIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PollVote extends PollVote {
  const _PollVote({@JsonKey(name: r'$id') required this.voteId, required this.pollId, required this.roomId, required this.uid, required this.optionIndex}): super._();
  factory _PollVote.fromJson(Map<String, dynamic> json) => _$PollVoteFromJson(json);

// Row id doubles as the vote id, mirroring Poll. A unique (pollId, uid)
// index server-side rejects duplicate votes with a 409.
@override@JsonKey(name: r'$id') final  String voteId;
@override final  String pollId;
@override final  String roomId;
@override final  String uid;
@override final  int optionIndex;

/// Create a copy of PollVote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PollVoteCopyWith<_PollVote> get copyWith => __$PollVoteCopyWithImpl<_PollVote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PollVoteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PollVote&&(identical(other.voteId, voteId) || other.voteId == voteId)&&(identical(other.pollId, pollId) || other.pollId == pollId)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.optionIndex, optionIndex) || other.optionIndex == optionIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,voteId,pollId,roomId,uid,optionIndex);

@override
String toString() {
  return 'PollVote(voteId: $voteId, pollId: $pollId, roomId: $roomId, uid: $uid, optionIndex: $optionIndex)';
}


}

/// @nodoc
abstract mixin class _$PollVoteCopyWith<$Res> implements $PollVoteCopyWith<$Res> {
  factory _$PollVoteCopyWith(_PollVote value, $Res Function(_PollVote) _then) = __$PollVoteCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: r'$id') String voteId, String pollId, String roomId, String uid, int optionIndex
});




}
/// @nodoc
class __$PollVoteCopyWithImpl<$Res>
    implements _$PollVoteCopyWith<$Res> {
  __$PollVoteCopyWithImpl(this._self, this._then);

  final _PollVote _self;
  final $Res Function(_PollVote) _then;

/// Create a copy of PollVote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? voteId = null,Object? pollId = null,Object? roomId = null,Object? uid = null,Object? optionIndex = null,}) {
  return _then(_PollVote(
voteId: null == voteId ? _self.voteId : voteId // ignore: cast_nullable_to_non_nullable
as String,pollId: null == pollId ? _self.pollId : pollId // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,optionIndex: null == optionIndex ? _self.optionIndex : optionIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
