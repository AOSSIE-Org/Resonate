import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/appwrite_upcoming_room.freezed.dart';

@freezed
abstract class AppwriteUpcomingRoom with _$AppwriteUpcomingRoom {
  const factory AppwriteUpcomingRoom({
    required String id,
    required String name,
    required bool isTime,
    required DateTime scheduledDateTime,
    required String description,
    required int totalSubscriberCount,
    required List<String> tags,
    required List<String> subscribersAvatarUrls,
    required bool userIsCreator,
    required bool hasUserSubscribed,
  }) = _AppwriteUpcomingRoom;
}
