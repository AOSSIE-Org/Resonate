import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/rooms/data/repositories/rooms_repository.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/live_rooms.g.dart';

// Data-layer cache of the live rooms list
@Riverpod(keepAlive: true)
class LiveRooms extends _$LiveRooms {
  @override
  Future<List<AppwriteRoom>> build() async {
    final userUid = ref.read(requireUserProvider).uid;
    return ref.watch(roomsRepositoryProvider).loadRooms(userUid);
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() async {
      final userUid = ref.read(requireUserProvider).uid;
      return ref.read(roomsRepositoryProvider).loadRooms(userUid);
    });
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
