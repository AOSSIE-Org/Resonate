// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_chapter_attendees_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LiveChapterAttendeesModel _$LiveChapterAttendeesModelFromJson(
  Map<String, dynamic> json,
) => _LiveChapterAttendeesModel(
  liveChapterId: json['liveChapterId'] as String,
  users: (json['users'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
);

Map<String, dynamic> _$LiveChapterAttendeesModelToJson(
  _LiveChapterAttendeesModel instance,
) => <String, dynamic>{
  'liveChapterId': instance.liveChapterId,
  'users': instance.userIds,
};
