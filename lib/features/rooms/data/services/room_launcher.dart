import 'dart:developer';

import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/rooms/data/active_room.dart';
import 'package:resonate/features/rooms/data/live_rooms.dart';
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

  Future<AppwriteRoom> createAndEnterLiveRoom({
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

    final room = AppwriteRoom(
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
    _ref.read(activeRoomProvider.notifier).enter(room);
    _ref.read(liveRoomsProvider.notifier).addLocally(room);
    return room;
  }

  Future<AppwriteRoom?> findRoomById(String roomId) async {
    final uid = _ref.read(currentUserProvider)?.uid;
    if (uid == null) return null;
    return _ref.read(roomsRepositoryProvider).getRoomById(roomId, uid);
  }

  Future<AppwriteRoom> enterRoom(AppwriteRoom room) async {
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
    final entered = room.copyWith(myDocId: result.myDocId);
    _ref.read(activeRoomProvider.notifier).enter(entered);
    return entered;
  }

  // Takes the current user out ending it if they are the host.
  Future<void> leave(AppwriteRoom room) async {
    final repo = _ref.read(roomsRepositoryProvider);
    final liveKit = _ref.read(liveKitControllerProvider.notifier);
    final rooms = _ref.read(liveRoomsProvider.notifier);
    final userId = _ref.read(requireUserProvider).uid;
    final endsTheRoom = room.isUserAdmin;

    // Before the first await, so the list is right the moment the page pops
    // and the miniplayer goes away with it.
    _ref.read(activeRoomProvider.notifier).clear();
    if (endsTheRoom) rooms.removeLocally(room.id);
    try {
      await liveKit.disconnect();
    } catch (e) {
      log('leave: disconnect failed: $e');
    }
    try {
      if (endsTheRoom) {
        await repo.deleteRoom(roomId: room.id);
      } else {
        await repo.leaveRoom(roomId: room.id, userId: userId);
      }
    } catch (e) {
      log('leave: teardown failed: $e');
    }
    await rooms.refresh();
  }
}
