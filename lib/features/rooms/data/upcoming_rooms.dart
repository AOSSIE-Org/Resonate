import 'package:get_storage/get_storage.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/core/providers/get_storage_provider.dart';
import 'package:resonate/features/rooms/data/live_rooms.dart';
import 'package:resonate/features/rooms/data/repositories/upcoming_rooms_repository.dart';
import 'package:resonate/features/rooms/data/services/room_launcher.dart';
import 'package:resonate/features/rooms/model/appwrite_upcoming_room.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/upcoming_rooms.g.dart';

const String _removedUpcomingRoomsKey = 'removed_upcoming_rooms';

// Data-layer cache + CRUD for the upcoming rooms list
@Riverpod(keepAlive: true)
class UpcomingRoomsNotifier extends _$UpcomingRoomsNotifier {
  GetStorage get _storage => ref.read(getStorageBoxProvider);

  List<String> _readHidden() =>
      List<String>.from(_storage.read(_removedUpcomingRoomsKey) ?? <String>[]);

  Future<void> _writeHidden(List<String> ids) =>
      _storage.write(_removedUpcomingRoomsKey, ids);

  @override
  Future<List<AppwriteUpcomingRoom>> build() async {
    final repo = ref.watch(upcomingRoomsRepositoryProvider);
    final hidden = _readHidden();
    final rooms = await repo.loadUpcoming(
      userUid: ref.read(requireUserProvider).uid,
      hiddenRoomIds: hidden.toSet(),
    );

    final liveIds = await repo.liveUpcomingRoomIds();
    final cleaned = hidden.where(liveIds.contains).toList();
    if (cleaned.length != hidden.length) {
      await _writeHidden(cleaned);
    }
    return rooms;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(upcomingRoomsRepositoryProvider);
      return repo.loadUpcoming(
        userUid: ref.read(requireUserProvider).uid,
        hiddenRoomIds: _readHidden().toSet(),
      );
    });
  }

  Future<void> subscribe(String upcomingRoomId) async {
    final user = ref.read(requireUserProvider);
    await ref.read(upcomingRoomsRepositoryProvider).addSubscriber(
      upcomingRoomId: upcomingRoomId,
      userUid: user.uid,
      profileImageUrl: user.profileImageUrl ?? '',
    );
    await refresh();
  }

  Future<void> unsubscribe(String upcomingRoomId) async {
    await ref.read(upcomingRoomsRepositoryProvider).removeSubscriber(
      upcomingRoomId: upcomingRoomId,
      userUid: ref.read(requireUserProvider).uid,
    );
    await refresh();
  }

  Future<void> deleteUpcoming(String upcomingRoomId) async {
    await ref.read(upcomingRoomsRepositoryProvider).deleteUpcomingRoom(
      upcomingRoomId,
    );
    await refresh();
  }

  // Hide an upcoming room locally without deleting it server-side.
  Future<void> hideLocally(String upcomingRoomId) async {
    final hidden = _readHidden();
    if (!hidden.contains(upcomingRoomId)) {
      hidden.add(upcomingRoomId);
      await _writeHidden(hidden);
    }
    final current = state.value;
    if (current != null) {
      state = AsyncData(
        current.where((r) => r.id != upcomingRoomId).toList(),
      );
    }
  }

  // Promotes an upcoming room into a live room via the shared data-layer coordinator
  Future<void> convertToLive({
    required String upcomingRoomId,
    required String name,
    required String description,
    required List<String> tags,
  }) async {
    await ref.read(roomLauncherProvider).createAndJoinLiveRoom(
          name: name,
          description: description,
          tags: tags,
        );
    await deleteUpcoming(upcomingRoomId);
    ref.invalidate(liveRoomsProvider);
  }
}
