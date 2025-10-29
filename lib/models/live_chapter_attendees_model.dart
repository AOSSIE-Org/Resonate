import 'package:freezed_annotation/freezed_annotation.dart';

part 'live_chapter_attendees_model.freezed.dart';
part 'live_chapter_attendees_model.g.dart';

@freezed
abstract class LiveChapterAttendeesModel with _$LiveChapterAttendeesModel {
  factory LiveChapterAttendeesModel({
    required String liveChapterId,
    @JsonKey(includeToJson: false) required List<Map<String, dynamic>> users,
    @JsonKey(includeFromJson: false, name: "users", includeToJson: true)
    List<String>? userIds,
  }) = _LiveChapterAttendeesModel;

  factory LiveChapterAttendeesModel.fromJson(Map<String, dynamic> json) =>
      _$LiveChapterAttendeesModelFromJson(json);
}
