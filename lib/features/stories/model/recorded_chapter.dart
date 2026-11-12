import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/recorded_chapter.freezed.dart';
part 'generated/recorded_chapter.g.dart';

// A live chapter recording kept on this device.
@freezed
abstract class RecordedChapter with _$RecordedChapter {
  const factory RecordedChapter({
    required String id,
    required String title,
    required String description,
    required String audioFilePath,
    required int durationMs,
    required String transcript,
    // Stored UTC; the detail view converts it for display.
    required DateTime recordedAt,
  }) = _RecordedChapter;

  factory RecordedChapter.fromJson(Map<String, dynamic> json) =>
      _$RecordedChapterFromJson(json);
}
