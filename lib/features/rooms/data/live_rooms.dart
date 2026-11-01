import 'dart:async';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/rooms/data/repositories/rooms_repository.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/utils/realtime_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/live_rooms.g.dart';

// Data-layer cache of the live rooms list
@Riverpod(keepAlive: true)
class LiveRooms extends _$LiveRooms {
  StreamSubscription<RealtimeMessage>? _roomSub;

  @override
  Future<List<AppwriteRoom>> build() async {
    final userUid = ref.read(requireUserProvider).uid;
    _subscribe(userUid);
    return ref.watch(roomsRepositoryProvider).loadRooms(userUid);
  }

  // Without this the list only ever changed from this device.
  void _subscribe(String userUid) {
    final repo = ref.read(roomsRepositoryProvider);
    _roomSub = repo.roomStream().listen((event) async {
      try {
        final roomId = event.payload[r'$id'] as String?;
        if (roomId == null) return;

        if (realtimeAction(event.events) case 'delete') {
          removeLocally(roomId);
          return;
        }

        final rooms = state.value;
        if (rooms == null) return;
        final index = rooms.indexWhere((room) => room.id == roomId);

        final reported = List<String>.from(
          event.payload['reportedUsers'] as List? ?? const [],
        );
        if (reported.contains(userUid)) {
          removeLocally(roomId);
          return;
        }

        // Patch rather than refetch: every participant, message and poll now
        // updates the room row too.
        if (index >= 0) {
          _replace(index, _patched(rooms[index], event.payload));
          return;
        }

        // An unknown room can arrive as a create or an update, so both add it.
        final room = await repo.getRoomById(roomId, userUid);
        if (room == null || !ref.mounted) return;
        addLocally(room);
      } catch (e) {
        log('live rooms listener error: $e');
      }
    });
    ref.onDispose(() {
      _roomSub?.cancel();
      _roomSub = null;
    });
  }

  AppwriteRoom _patched(AppwriteRoom room, Map<String, dynamic> payload) {
    final tags = payload['tags'];
    return room.copyWith(
      name: (payload['name'] as String?) ?? room.name,
      description: (payload['description'] as String?) ?? room.description,
      totalParticipants:
          (payload['totalParticipants'] as num?)?.toInt() ??
          room.totalParticipants,
      tags: tags is List ? List<String>.from(tags) : room.tags,
    );
  }

  void _replace(int index, AppwriteRoom room) {
    final rooms = state.value;
    if (rooms == null || index < 0 || index >= rooms.length) return;
    state = AsyncData([
      for (var i = 0; i < rooms.length; i++)
        if (i == index) room else rooms[i],
    ]);
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() async {
      final userUid = ref.read(requireUserProvider).uid;
      return ref.read(roomsRepositoryProvider).loadRooms(userUid);
    });
  }

  void addLocally(AppwriteRoom room) {
    final rooms = state.value;
    if (rooms == null) return;
    if (rooms.any((existing) => existing.id == room.id)) return;
    state = AsyncData([room, ...rooms]);
  }

  // Drops a room from the cache
  void removeLocally(String roomId) {
    final rooms = state.value;
    if (rooms == null) return;
    state = AsyncData([
      for (final room in rooms)
        if (room.id != roomId) room,
    ]);
  }
}
