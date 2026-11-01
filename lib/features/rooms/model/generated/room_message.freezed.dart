// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../room_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoomMessage {

 String get roomId; String get messageId; String get creatorId; String get creatorUsername; String get creatorName; String get creatorImgUrl; bool get hasValidTag; int get index; bool get isEdited; String get content; DateTime get creationDateTime; bool get isDeleted; ReplyTo? get replyTo;@JsonKey(includeFromJson: false, includeToJson: false) RoomMessageStatus get status;
/// Create a copy of RoomMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomMessageCopyWith<RoomMessage> get copyWith => _$RoomMessageCopyWithImpl<RoomMessage>(this as RoomMessage, _$identity);

  /// Serializes this RoomMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomMessage&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.creatorId, creatorId) || other.creatorId == creatorId)&&(identical(other.creatorUsername, creatorUsername) || other.creatorUsername == creatorUsername)&&(identical(other.creatorName, creatorName) || other.creatorName == creatorName)&&(identical(other.creatorImgUrl, creatorImgUrl) || other.creatorImgUrl == creatorImgUrl)&&(identical(other.hasValidTag, hasValidTag) || other.hasValidTag == hasValidTag)&&(identical(other.index, index) || other.index == index)&&(identical(other.isEdited, isEdited) || other.isEdited == isEdited)&&(identical(other.content, content) || other.content == content)&&(identical(other.creationDateTime, creationDateTime) || other.creationDateTime == creationDateTime)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.replyTo, replyTo) || other.replyTo == replyTo)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,roomId,messageId,creatorId,creatorUsername,creatorName,creatorImgUrl,hasValidTag,index,isEdited,content,creationDateTime,isDeleted,replyTo,status);

@override
String toString() {
  return 'RoomMessage(roomId: $roomId, messageId: $messageId, creatorId: $creatorId, creatorUsername: $creatorUsername, creatorName: $creatorName, creatorImgUrl: $creatorImgUrl, hasValidTag: $hasValidTag, index: $index, isEdited: $isEdited, content: $content, creationDateTime: $creationDateTime, isDeleted: $isDeleted, replyTo: $replyTo, status: $status)';
}


}

/// @nodoc
abstract mixin class $RoomMessageCopyWith<$Res>  {
  factory $RoomMessageCopyWith(RoomMessage value, $Res Function(RoomMessage) _then) = _$RoomMessageCopyWithImpl;
@useResult
$Res call({
 String roomId, String messageId, String creatorId, String creatorUsername, String creatorName, String creatorImgUrl, bool hasValidTag, int index, bool isEdited, String content, DateTime creationDateTime, bool isDeleted, ReplyTo? replyTo,@JsonKey(includeFromJson: false, includeToJson: false) RoomMessageStatus status
});


$ReplyToCopyWith<$Res>? get replyTo;

}
/// @nodoc
class _$RoomMessageCopyWithImpl<$Res>
    implements $RoomMessageCopyWith<$Res> {
  _$RoomMessageCopyWithImpl(this._self, this._then);

  final RoomMessage _self;
  final $Res Function(RoomMessage) _then;

/// Create a copy of RoomMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? roomId = null,Object? messageId = null,Object? creatorId = null,Object? creatorUsername = null,Object? creatorName = null,Object? creatorImgUrl = null,Object? hasValidTag = null,Object? index = null,Object? isEdited = null,Object? content = null,Object? creationDateTime = null,Object? isDeleted = null,Object? replyTo = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,creatorId: null == creatorId ? _self.creatorId : creatorId // ignore: cast_nullable_to_non_nullable
as String,creatorUsername: null == creatorUsername ? _self.creatorUsername : creatorUsername // ignore: cast_nullable_to_non_nullable
as String,creatorName: null == creatorName ? _self.creatorName : creatorName // ignore: cast_nullable_to_non_nullable
as String,creatorImgUrl: null == creatorImgUrl ? _self.creatorImgUrl : creatorImgUrl // ignore: cast_nullable_to_non_nullable
as String,hasValidTag: null == hasValidTag ? _self.hasValidTag : hasValidTag // ignore: cast_nullable_to_non_nullable
as bool,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,isEdited: null == isEdited ? _self.isEdited : isEdited // ignore: cast_nullable_to_non_nullable
as bool,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,creationDateTime: null == creationDateTime ? _self.creationDateTime : creationDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,replyTo: freezed == replyTo ? _self.replyTo : replyTo // ignore: cast_nullable_to_non_nullable
as ReplyTo?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RoomMessageStatus,
  ));
}
/// Create a copy of RoomMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReplyToCopyWith<$Res>? get replyTo {
    if (_self.replyTo == null) {
    return null;
  }

  return $ReplyToCopyWith<$Res>(_self.replyTo!, (value) {
    return _then(_self.copyWith(replyTo: value));
  });
}
}


/// Adds pattern-matching-related methods to [RoomMessage].
extension RoomMessagePatterns on RoomMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomMessage value)  $default,){
final _that = this;
switch (_that) {
case _RoomMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomMessage value)?  $default,){
final _that = this;
switch (_that) {
case _RoomMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String roomId,  String messageId,  String creatorId,  String creatorUsername,  String creatorName,  String creatorImgUrl,  bool hasValidTag,  int index,  bool isEdited,  String content,  DateTime creationDateTime,  bool isDeleted,  ReplyTo? replyTo, @JsonKey(includeFromJson: false, includeToJson: false)  RoomMessageStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomMessage() when $default != null:
return $default(_that.roomId,_that.messageId,_that.creatorId,_that.creatorUsername,_that.creatorName,_that.creatorImgUrl,_that.hasValidTag,_that.index,_that.isEdited,_that.content,_that.creationDateTime,_that.isDeleted,_that.replyTo,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String roomId,  String messageId,  String creatorId,  String creatorUsername,  String creatorName,  String creatorImgUrl,  bool hasValidTag,  int index,  bool isEdited,  String content,  DateTime creationDateTime,  bool isDeleted,  ReplyTo? replyTo, @JsonKey(includeFromJson: false, includeToJson: false)  RoomMessageStatus status)  $default,) {final _that = this;
switch (_that) {
case _RoomMessage():
return $default(_that.roomId,_that.messageId,_that.creatorId,_that.creatorUsername,_that.creatorName,_that.creatorImgUrl,_that.hasValidTag,_that.index,_that.isEdited,_that.content,_that.creationDateTime,_that.isDeleted,_that.replyTo,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String roomId,  String messageId,  String creatorId,  String creatorUsername,  String creatorName,  String creatorImgUrl,  bool hasValidTag,  int index,  bool isEdited,  String content,  DateTime creationDateTime,  bool isDeleted,  ReplyTo? replyTo, @JsonKey(includeFromJson: false, includeToJson: false)  RoomMessageStatus status)?  $default,) {final _that = this;
switch (_that) {
case _RoomMessage() when $default != null:
return $default(_that.roomId,_that.messageId,_that.creatorId,_that.creatorUsername,_that.creatorName,_that.creatorImgUrl,_that.hasValidTag,_that.index,_that.isEdited,_that.content,_that.creationDateTime,_that.isDeleted,_that.replyTo,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoomMessage extends RoomMessage {
  const _RoomMessage({required this.roomId, required this.messageId, required this.creatorId, required this.creatorUsername, required this.creatorName, required this.creatorImgUrl, required this.hasValidTag, required this.index, required this.isEdited, required this.content, required this.creationDateTime, this.isDeleted = false, this.replyTo, @JsonKey(includeFromJson: false, includeToJson: false) this.status = RoomMessageStatus.sent}): super._();
  factory _RoomMessage.fromJson(Map<String, dynamic> json) => _$RoomMessageFromJson(json);

@override final  String roomId;
@override final  String messageId;
@override final  String creatorId;
@override final  String creatorUsername;
@override final  String creatorName;
@override final  String creatorImgUrl;
@override final  bool hasValidTag;
@override final  int index;
@override final  bool isEdited;
@override final  String content;
@override final  DateTime creationDateTime;
@override@JsonKey() final  bool isDeleted;
@override final  ReplyTo? replyTo;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  RoomMessageStatus status;

/// Create a copy of RoomMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomMessageCopyWith<_RoomMessage> get copyWith => __$RoomMessageCopyWithImpl<_RoomMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoomMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomMessage&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.creatorId, creatorId) || other.creatorId == creatorId)&&(identical(other.creatorUsername, creatorUsername) || other.creatorUsername == creatorUsername)&&(identical(other.creatorName, creatorName) || other.creatorName == creatorName)&&(identical(other.creatorImgUrl, creatorImgUrl) || other.creatorImgUrl == creatorImgUrl)&&(identical(other.hasValidTag, hasValidTag) || other.hasValidTag == hasValidTag)&&(identical(other.index, index) || other.index == index)&&(identical(other.isEdited, isEdited) || other.isEdited == isEdited)&&(identical(other.content, content) || other.content == content)&&(identical(other.creationDateTime, creationDateTime) || other.creationDateTime == creationDateTime)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.replyTo, replyTo) || other.replyTo == replyTo)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,roomId,messageId,creatorId,creatorUsername,creatorName,creatorImgUrl,hasValidTag,index,isEdited,content,creationDateTime,isDeleted,replyTo,status);

@override
String toString() {
  return 'RoomMessage(roomId: $roomId, messageId: $messageId, creatorId: $creatorId, creatorUsername: $creatorUsername, creatorName: $creatorName, creatorImgUrl: $creatorImgUrl, hasValidTag: $hasValidTag, index: $index, isEdited: $isEdited, content: $content, creationDateTime: $creationDateTime, isDeleted: $isDeleted, replyTo: $replyTo, status: $status)';
}


}

/// @nodoc
abstract mixin class _$RoomMessageCopyWith<$Res> implements $RoomMessageCopyWith<$Res> {
  factory _$RoomMessageCopyWith(_RoomMessage value, $Res Function(_RoomMessage) _then) = __$RoomMessageCopyWithImpl;
@override @useResult
$Res call({
 String roomId, String messageId, String creatorId, String creatorUsername, String creatorName, String creatorImgUrl, bool hasValidTag, int index, bool isEdited, String content, DateTime creationDateTime, bool isDeleted, ReplyTo? replyTo,@JsonKey(includeFromJson: false, includeToJson: false) RoomMessageStatus status
});


@override $ReplyToCopyWith<$Res>? get replyTo;

}
/// @nodoc
class __$RoomMessageCopyWithImpl<$Res>
    implements _$RoomMessageCopyWith<$Res> {
  __$RoomMessageCopyWithImpl(this._self, this._then);

  final _RoomMessage _self;
  final $Res Function(_RoomMessage) _then;

/// Create a copy of RoomMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roomId = null,Object? messageId = null,Object? creatorId = null,Object? creatorUsername = null,Object? creatorName = null,Object? creatorImgUrl = null,Object? hasValidTag = null,Object? index = null,Object? isEdited = null,Object? content = null,Object? creationDateTime = null,Object? isDeleted = null,Object? replyTo = freezed,Object? status = null,}) {
  return _then(_RoomMessage(
roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,creatorId: null == creatorId ? _self.creatorId : creatorId // ignore: cast_nullable_to_non_nullable
as String,creatorUsername: null == creatorUsername ? _self.creatorUsername : creatorUsername // ignore: cast_nullable_to_non_nullable
as String,creatorName: null == creatorName ? _self.creatorName : creatorName // ignore: cast_nullable_to_non_nullable
as String,creatorImgUrl: null == creatorImgUrl ? _self.creatorImgUrl : creatorImgUrl // ignore: cast_nullable_to_non_nullable
as String,hasValidTag: null == hasValidTag ? _self.hasValidTag : hasValidTag // ignore: cast_nullable_to_non_nullable
as bool,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,isEdited: null == isEdited ? _self.isEdited : isEdited // ignore: cast_nullable_to_non_nullable
as bool,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,creationDateTime: null == creationDateTime ? _self.creationDateTime : creationDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,replyTo: freezed == replyTo ? _self.replyTo : replyTo // ignore: cast_nullable_to_non_nullable
as ReplyTo?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RoomMessageStatus,
  ));
}

/// Create a copy of RoomMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReplyToCopyWith<$Res>? get replyTo {
    if (_self.replyTo == null) {
    return null;
  }

  return $ReplyToCopyWith<$Res>(_self.replyTo!, (value) {
    return _then(_self.copyWith(replyTo: value));
  });
}
}

// dart format on
