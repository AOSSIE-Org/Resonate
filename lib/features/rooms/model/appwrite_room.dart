import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/utils/enums/room_state.dart';

part 'generated/appwrite_room.freezed.dart';

@freezed
abstract class AppwriteRoom with _$AppwriteRoom {
  const factory AppwriteRoom({
    required String id,
    required String name,
    required String description,
    required int totalParticipants,
    required List<String> tags,
    required List<String> memberAvatarUrls,
    required RoomState state,
    required bool isUserAdmin,
    @Default(<String>[]) List<String> reportedUsers,
    String? myDocId,
  }) = _AppwriteRoom;
}
