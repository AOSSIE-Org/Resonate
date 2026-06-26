import 'package:resonate/features/auth/viewmodel/current_user.dart';
import 'package:resonate/features/rooms/data/repositories/rooms_repository.dart';
import 'package:resonate/features/rooms/data/repositories/upcoming_rooms_repository.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/model/room_failure.dart';
import 'package:resonate/features/rooms/viewmodel/livekit_notifier.dart';
import 'package:resonate/features/rooms/viewmodel/rooms_notifier.dart';
import 'package:resonate/features/rooms/viewmodel/upcoming_rooms_notifier.dart';
import 'package:resonate/utils/enums/room_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/create_room_notifier.g.dart';

@riverpod
class CreateRoomNotifier extends _$CreateRoomNotifier {
  @override
  bool build() => false; // isLoading

  Future<AppwriteRoom?> createLiveRoom({
    required String name,
    required String description,
    required List<String> tags,
  }) async {
    state = true;
    try {
      final repo = ref.read(roomsRepositoryProvider);
      final result = await repo.createRoom(
        name: name,
        description: description,
        tags: tags,
        adminUid: ref.read(requireUserProvider).uid,
      );
      final connected = await ref.read(liveKitProvider.notifier).connect(
        liveKitUri: result.liveKitUri,
        roomToken: result.roomToken,
      );
      if (!connected) {
        try {
          await repo.deleteRoom(roomId: result.roomId);
        } catch (_) {}
        ref.invalidate(roomsProvider);
        throw const RoomFailure.liveKit(
          'Could not connect to the audio session.',
        );
      }
      // Refresh global rooms list.
      ref.invalidate(roomsProvider);

      return AppwriteRoom(
        id: result.roomId,
        name: name,
        description: description,
        totalParticipants: 1,
        tags: tags,
        memberAvatarUrls: const [],
        state: RoomState.live,
        isUserAdmin: true,
        myDocId: result.myDocId,
        reportedUsers: const [],
      );
    } finally {
      state = false;
    }
  }

  // Schedules an upcoming room. Returns true on success.
  Future<bool> createScheduledRoom({
    required String name,
    required String description,
    required List<String> tags,
    required String scheduledDateTime,
  }) async {
    state = true;
    try {
      final repo = ref.read(upcomingRoomsRepositoryProvider);
      await repo.createUpcomingRoom(
        name: name,
        description: description,
        tags: tags,
        scheduledDateTime: scheduledDateTime,
        creatorUid: ref.read(requireUserProvider).uid,
      );
      ref.invalidate(upcomingRoomsProvider);
      return true;
    } finally {
      state = false;
    }
  }
}

extension TagValidator on String {
  bool get isValidTag {
    final hashtag = trim();
    if (!hashtag.startsWith(RegExp(r'[a-zA-Z0-9]'))) return false;
    if (!hashtag.contains(RegExp(r'^[a-zA-Z0-9_]+$'))) return false;
    if (hashtag.length > 30) return false;
    return true;
  }
}
