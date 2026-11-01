// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../recorded_chapter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecordedChapter _$RecordedChapterFromJson(Map<String, dynamic> json) =>
    _RecordedChapter(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      audioFilePath: json['audioFilePath'] as String,
      durationMs: (json['durationMs'] as num).toInt(),
      transcript: json['transcript'] as String,
      recordedAt: DateTime.parse(json['recordedAt'] as String),
    );

Map<String, dynamic> _$RecordedChapterToJson(_RecordedChapter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'audioFilePath': instance.audioFilePath,
      'durationMs': instance.durationMs,
      'transcript': instance.transcript,
      'recordedAt': instance.recordedAt.toIso8601String(),
    };
