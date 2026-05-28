// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../reply_to.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReplyTo _$ReplyToFromJson(Map<String, dynamic> json) => _ReplyTo(
  messageId: json['messageId'] as String,
  creatorUsername: json['creatorUsername'] as String,
  creatorImgUrl: json['creatorImgUrl'] as String,
  index: (json['index'] as num).toInt(),
  content: json['content'] as String,
);

Map<String, dynamic> _$ReplyToToJson(_ReplyTo instance) => <String, dynamic>{
  'messageId': instance.messageId,
  'creatorUsername': instance.creatorUsername,
  'creatorImgUrl': instance.creatorImgUrl,
  'index': instance.index,
  'content': instance.content,
};
