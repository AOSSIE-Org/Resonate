// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../poll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Poll _$PollFromJson(Map<String, dynamic> json) => _Poll(
  pollId: json[r'$id'] as String,
  roomId: json['roomId'] as String,
  question: json['question'] as String,
  options:
      (json['options'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  createdBy: json['createdBy'] as String,
  isClosed: json['isClosed'] as bool? ?? false,
);

Map<String, dynamic> _$PollToJson(_Poll instance) => <String, dynamic>{
  r'$id': instance.pollId,
  'roomId': instance.roomId,
  'question': instance.question,
  'options': instance.options,
  'createdBy': instance.createdBy,
  'isClosed': instance.isClosed,
};
