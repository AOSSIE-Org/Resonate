// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../room_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoomMessage _$RoomMessageFromJson(Map<String, dynamic> json) => _RoomMessage(
  roomId: json['roomId'] as String,
  messageId: json['messageId'] as String,
  creatorId: json['creatorId'] as String,
  creatorUsername: json['creatorUsername'] as String,
  creatorName: json['creatorName'] as String,
  creatorImgUrl: json['creatorImgUrl'] as String,
  hasValidTag: json['hasValidTag'] as bool,
  index: (json['index'] as num).toInt(),
  isEdited: json['isEdited'] as bool,
  content: json['content'] as String,
  creationDateTime: DateTime.parse(json['creationDateTime'] as String),
  isDeleted: json['isDeleted'] as bool? ?? false,
  pollId: json['pollId'] as String?,
  replyTo: json['replyTo'] == null
      ? null
      : ReplyTo.fromJson(json['replyTo'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RoomMessageToJson(_RoomMessage instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'messageId': instance.messageId,
      'creatorId': instance.creatorId,
      'creatorUsername': instance.creatorUsername,
      'creatorName': instance.creatorName,
      'creatorImgUrl': instance.creatorImgUrl,
      'hasValidTag': instance.hasValidTag,
      'index': instance.index,
      'isEdited': instance.isEdited,
      'content': instance.content,
      'creationDateTime': instance.creationDateTime.toIso8601String(),
      'isDeleted': instance.isDeleted,
      'pollId': instance.pollId,
      'replyTo': instance.replyTo,
    };
