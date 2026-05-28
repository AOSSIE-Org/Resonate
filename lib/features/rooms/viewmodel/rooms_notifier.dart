import 'package:resonate/core/container.dart';
import 'package:resonate/features/rooms/data/rooms_repository.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/model/rooms_state.dart';
import 'package:resonate/features/rooms/viewmodel/livekit_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/rooms_notifier.g.dart';

@Riverpod(keepAlive: true)
class RoomsNotifier extends _$RoomsNotifier {
  @override
  Future<RoomsState> build() async {
    final userUid = requireCurrentAuthUser.uid;
    final rooms = await ref.watch(roomsRepositoryProvider).loadRooms(userUid);
    return RoomsState.ready(rooms: rooms);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final userUid = requireCurrentAuthUser.uid;
      final rooms = await ref.read(roomsRepositoryProvider).loadRooms(userUid);
      return RoomsState.ready(rooms: rooms);
    });
  }

  Future<AppwriteRoom> joinRoom(AppwriteRoom room) async {
    final repo = ref.read(roomsRepositoryProvider);
    final result = await repo.joinRoom(
      roomId: room.id,
      userId: requireCurrentAuthUser.uid,
      isAdmin: room.isUserAdmin,
    );
    await ref.read(liveKitProvider.notifier).connect(
      liveKitUri: result.liveKitUri,
      roomToken: result.roomToken,
    );
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
