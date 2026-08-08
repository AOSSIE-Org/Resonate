import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/rooms/data/repositories/rooms_repository.dart';
import 'package:resonate/features/live_audio/data/services/livekit_controller.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/model/room_failure.dart';
import 'package:resonate/utils/enums/room_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/room_launcher.g.dart';

@Riverpod(keepAlive: true)
RoomLauncher roomLauncher(Ref ref) => RoomLauncher(ref);

class RoomLauncher {
  RoomLauncher(this._ref);

  final Ref _ref;

  Future<AppwriteRoom> createAndJoinLiveRoom({
    required String name,
    required String description,
    required List<String> tags,
  }) async {
    final repo = _ref.read(roomsRepositoryProvider);
    final result = await repo.createRoom(
      name: name,
      description: description,
      tags: tags,
      adminUid: _ref.read(requireUserProvider).uid,
    );

    final connected =
        await _ref.read(liveKitControllerProvider.notifier).connect(
              liveKitUri: result.liveKitUri,
              roomToken: result.roomToken,
            );
    if (!connected) {
      try {
        await repo.deleteRoom(roomId: result.roomId);
      } catch (_) {}
      throw const RoomFailure.liveKit(
        'Could not connect to the audio session.',
      );
    }

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
  }

  /// Resolves a room id — a deep link, say — into a room the current user can
  /// join, or null if there's no signed-in user or no such room.
  ///
  /// Exists so callers outside this feature don't have to reach into the rooms
  /// repository, or know that resolving a room needs the user's uid.
  Future<AppwriteRoom?> findRoomById(String roomId) async {
    final uid = _ref.read(currentUserProvider)?.uid;
    if (uid == null) return null;
    return _ref.read(roomsRepositoryProvider).getRoomById(roomId, uid);
  }

  Future<AppwriteRoom> joinRoom(AppwriteRoom room) async {
    final repo = _ref.read(roomsRepositoryProvider);
    final userId = _ref.read(requireUserProvider).uid;
    final result = await repo.joinRoom(
      roomId: room.id,
      userId: userId,
      isAdmin: room.isUserAdmin,
    );
    final connected =
        await _ref.read(liveKitControllerProvider.notifier).connect(
              liveKitUri: result.liveKitUri,
              roomToken: result.roomToken,
            );
    if (!connected) {
      try {
        await repo.leaveRoom(roomId: room.id, userId: userId);
      } catch (_) {}
      throw const RoomFailure.liveKit(
        'Could not connect to the audio session.',
      );
    }
    return room.copyWith(myDocId: result.myDocId);
  }
}
