// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../poll.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Poll {

// Did this because the poll has no dedicated id attribute server-side —
// the Appwrite row id ($id) doubles as the poll id. Could refactor to a
// separate pollId attribute like chat's messageId if that's preferred.
@JsonKey(name: r'$id') String get pollId; String get roomId; String get question; List<String> get options; String get createdBy; bool get isClosed;
/// Create a copy of Poll
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PollCopyWith<Poll> get copyWith => _$PollCopyWithImpl<Poll>(this as Poll, _$identity);

  /// Serializes this Poll to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Poll&&(identical(other.pollId, pollId) || other.pollId == pollId)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.question, question) || other.question == question)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.isClosed, isClosed) || other.isClosed == isClosed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pollId,roomId,question,const DeepCollectionEquality().hash(options),createdBy,isClosed);

@override
String toString() {
  return 'Poll(pollId: $pollId, roomId: $roomId, question: $question, options: $options, createdBy: $createdBy, isClosed: $isClosed)';
}


}

/// @nodoc
abstract mixin class $PollCopyWith<$Res>  {
  factory $PollCopyWith(Poll value, $Res Function(Poll) _then) = _$PollCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: r'$id') String pollId, String roomId, String question, List<String> options, String createdBy, bool isClosed
});




}
/// @nodoc
class _$PollCopyWithImpl<$Res>
    implements $PollCopyWith<$Res> {
  _$PollCopyWithImpl(this._self, this._then);

  final Poll _self;
  final $Res Function(Poll) _then;

/// Create a copy of Poll
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pollId = null,Object? roomId = null,Object? question = null,Object? options = null,Object? createdBy = null,Object? isClosed = null,}) {
  return _then(_self.copyWith(
pollId: null == pollId ? _self.pollId : pollId // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,isClosed: null == isClosed ? _self.isClosed : isClosed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Poll].
extension PollPatterns on Poll {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Poll value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Poll() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Poll value)  $default,){
final _that = this;
switch (_that) {
case _Poll():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Poll value)?  $default,){
final _that = this;
switch (_that) {
case _Poll() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: r'$id')  String pollId,  String roomId,  String question,  List<String> options,  String createdBy,  bool isClosed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Poll() when $default != null:
return $default(_that.pollId,_that.roomId,_that.question,_that.options,_that.createdBy,_that.isClosed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: r'$id')  String pollId,  String roomId,  String question,  List<String> options,  String createdBy,  bool isClosed)  $default,) {final _that = this;
switch (_that) {
case _Poll():
return $default(_that.pollId,_that.roomId,_that.question,_that.options,_that.createdBy,_that.isClosed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: r'$id')  String pollId,  String roomId,  String question,  List<String> options,  String createdBy,  bool isClosed)?  $default,) {final _that = this;
switch (_that) {
case _Poll() when $default != null:
return $default(_that.pollId,_that.roomId,_that.question,_that.options,_that.createdBy,_that.isClosed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Poll extends Poll {
  const _Poll({@JsonKey(name: r'$id') required this.pollId, required this.roomId, required this.question, final  List<String> options = const <String>[], required this.createdBy, this.isClosed = false}): _options = options,super._();
  factory _Poll.fromJson(Map<String, dynamic> json) => _$PollFromJson(json);

// Did this because the poll has no dedicated id attribute server-side —
// the Appwrite row id ($id) doubles as the poll id. Could refactor to a
// separate pollId attribute like chat's messageId if that's preferred.
@override@JsonKey(name: r'$id') final  String pollId;
@override final  String roomId;
@override final  String question;
 final  List<String> _options;
@override@JsonKey() List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override final  String createdBy;
@override@JsonKey() final  bool isClosed;

/// Create a copy of Poll
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PollCopyWith<_Poll> get copyWith => __$PollCopyWithImpl<_Poll>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PollToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Poll&&(identical(other.pollId, pollId) || other.pollId == pollId)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.question, question) || other.question == question)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.isClosed, isClosed) || other.isClosed == isClosed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pollId,roomId,question,const DeepCollectionEquality().hash(_options),createdBy,isClosed);

@override
String toString() {
  return 'Poll(pollId: $pollId, roomId: $roomId, question: $question, options: $options, createdBy: $createdBy, isClosed: $isClosed)';
}


}

/// @nodoc
abstract mixin class _$PollCopyWith<$Res> implements $PollCopyWith<$Res> {
  factory _$PollCopyWith(_Poll value, $Res Function(_Poll) _then) = __$PollCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: r'$id') String pollId, String roomId, String question, List<String> options, String createdBy, bool isClosed
});




}
/// @nodoc
class __$PollCopyWithImpl<$Res>
    implements _$PollCopyWith<$Res> {
  __$PollCopyWithImpl(this._self, this._then);

  final _Poll _self;
  final $Res Function(_Poll) _then;

/// Create a copy of Poll
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pollId = null,Object? roomId = null,Object? question = null,Object? options = null,Object? createdBy = null,Object? isClosed = null,}) {
  return _then(_Poll(
pollId: null == pollId ? _self.pollId : pollId // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,isClosed: null == isClosed ? _self.isClosed : isClosed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
