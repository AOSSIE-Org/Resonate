import 'package:resonate/features/auth/viewmodel/current_user.dart';
import 'package:resonate/features/rooms/data/repositories/rooms_repository.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/model/room_failure.dart';
import 'package:resonate/features/rooms/model/rooms_state.dart';
import 'package:resonate/features/rooms/viewmodel/livekit_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/rooms_notifier.g.dart';

@Riverpod(keepAlive: true)
class RoomsNotifier extends _$RoomsNotifier {
  @override
  Future<RoomsState> build() async {
    final userUid = ref.read(requireUserProvider).uid;
    final rooms = await ref.watch(roomsRepositoryProvider).loadRooms(userUid);
    return RoomsState.ready(rooms: rooms);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final userUid = ref.read(requireUserProvider).uid;
      final rooms = await ref.read(roomsRepositoryProvider).loadRooms(userUid);
      return RoomsState.ready(rooms: rooms);
    });
  }

  Future<AppwriteRoom> joinRoom(AppwriteRoom room) async {
    final repo = ref.read(roomsRepositoryProvider);
    final userId = ref.read(requireUserProvider).uid;
    final result = await repo.joinRoom(
      roomId: room.id,
      userId: userId,
      isAdmin: room.isUserAdmin,
    );
    final connected = await ref.read(liveKitProvider.notifier).connect(
      liveKitUri: result.liveKitUri,
      roomToken: result.roomToken,
    );
    if (!connected) {
      try {
        await repo.leaveRoom(roomId: room.id, userId: userId);
      } catch (_) {}
      throw const RoomFailure.liveKit('Could not connect to the audio session.');
    }
    return room.copyWith(myDocId: result.myDocId);
  }

  void searchLiveRooms(String query) {
    final current = state.value;
    if (current is! RoomsStateReady) return;

    if (query.isEmpty) {
      state = AsyncData(
        current.copyWith(
          filteredRooms: const [],
          isSearching: false,
          searchBarIsEmpty: true,
        ),
      );
      return;
    }

    final lower = query.toLowerCase();
    final filtered = current.rooms.where((r) {
      return r.name.toLowerCase().contains(lower) ||
          r.description.toLowerCase().contains(lower);
    }).toList();

    state = AsyncData(
      current.copyWith(
        filteredRooms: filtered,
        isSearching: true,
        searchBarIsEmpty: false,
      ),
    );
  }

  void clearLiveSearch() {
    final current = state.value;
    if (current is! RoomsStateReady) return;
    state = AsyncData(
      current.copyWith(
        filteredRooms: const [],
        isSearching: false,
        searchBarIsEmpty: true,
      ),
    );
  }
}
