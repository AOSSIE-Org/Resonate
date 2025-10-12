import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/models/live_chapter_attendees_model.dart';

part 'live_chapter_model.freezed.dart';
part 'live_chapter_model.g.dart';

@freezed
abstract class LiveChapterModel with _$LiveChapterModel {
  factory LiveChapterModel({
    required String livekitRoomId,
    required String authorUid,
    required String authorProfileImageUrl,
    required String authorName,
    required String chapterTitle,
    required String chapterDescription,
    required String storyId,
    required List<String> followersFCMToken,
    @JsonKey(includeToJson: false, includeFromJson: false)
    LiveChapterAttendeesModel? attendees,
    @JsonKey(name: '\$id', includeToJson: false) required String id,
  }) = _LiveChapterModel;

  factory LiveChapterModel.fromJson(Map<String, dynamic> json) =>
      _$LiveChapterModelFromJson(json);
}
