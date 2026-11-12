// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../live_chapter_attendees_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LiveChapterAttendee _$LiveChapterAttendeeFromJson(Map<String, dynamic> json) =>
    _LiveChapterAttendee(
      id: json[r'$id'] as String,
      name: json['name'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
    );

Map<String, dynamic> _$LiveChapterAttendeeToJson(
  _LiveChapterAttendee instance,
) => <String, dynamic>{
  r'$id': instance.id,
  'name': instance.name,
  'profileImageUrl': instance.profileImageUrl,
};

_LiveChapterAttendeesModel _$LiveChapterAttendeesModelFromJson(
  Map<String, dynamic> json,
) => _LiveChapterAttendeesModel(
  liveChapterId: json['liveChapterId'] as String,
  users: (json['users'] as List<dynamic>)
      .map((e) => LiveChapterAttendee.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LiveChapterAttendeesModelToJson(
  _LiveChapterAttendeesModel instance,
) => <String, dynamic>{
  'liveChapterId': instance.liveChapterId,
  'users': instance.userIds,
};
