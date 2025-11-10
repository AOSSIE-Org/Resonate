// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_chapter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LiveChapterModel _$LiveChapterModelFromJson(Map<String, dynamic> json) =>
    _LiveChapterModel(
      livekitRoomId: json['livekitRoomId'] as String,
      authorUid: json['authorUid'] as String,
      authorProfileImageUrl: json['authorProfileImageUrl'] as String,
      authorName: json['authorName'] as String,
      chapterTitle: json['chapterTitle'] as String,
      chapterDescription: json['chapterDescription'] as String,
      storyId: json['storyId'] as String,
      followersFCMToken: (json['followersFCMToken'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      id: json[r'$id'] as String,
    );

Map<String, dynamic> _$LiveChapterModelToJson(_LiveChapterModel instance) =>
    <String, dynamic>{
      'livekitRoomId': instance.livekitRoomId,
      'authorUid': instance.authorUid,
      'authorProfileImageUrl': instance.authorProfileImageUrl,
      'authorName': instance.authorName,
      'chapterTitle': instance.chapterTitle,
      'chapterDescription': instance.chapterDescription,
      'storyId': instance.storyId,
      'followersFCMToken': instance.followersFCMToken,
    };
