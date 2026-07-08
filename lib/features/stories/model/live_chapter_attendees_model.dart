import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/live_chapter_attendees_model.freezed.dart';
part 'generated/live_chapter_attendees_model.g.dart';

/// One hydrated attendee row ("users" comes back from Appwrite as expanded
/// user documents; on upload only the IDs are written — see [userIds]).
@freezed
abstract class LiveChapterAttendee with _$LiveChapterAttendee {
  factory LiveChapterAttendee({
    @JsonKey(name: '\$id') required String id,
    String? name,
    String? profileImageUrl,
  }) = _LiveChapterAttendee;

  factory LiveChapterAttendee.fromJson(Map<String, dynamic> json) =>
      _$LiveChapterAttendeeFromJson(json);
}

@freezed
abstract class LiveChapterAttendeesModel with _$LiveChapterAttendeesModel {
  factory LiveChapterAttendeesModel({
    required String liveChapterId,
    @JsonKey(includeToJson: false) required List<LiveChapterAttendee> users,
    @JsonKey(includeFromJson: false, name: "users", includeToJson: true)
    List<String>? userIds,
  }) = _LiveChapterAttendeesModel;

  factory LiveChapterAttendeesModel.fromJson(Map<String, dynamic> json) =>
      _$LiveChapterAttendeesModelFromJson(json);
}
