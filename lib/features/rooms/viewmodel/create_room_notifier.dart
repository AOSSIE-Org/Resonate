import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/rooms/data/repositories/upcoming_rooms_repository.dart';
import 'package:resonate/features/rooms/data/services/room_launcher.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/data/live_rooms.dart';
import 'package:resonate/features/rooms/data/upcoming_rooms.dart';
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
      return await ref.read(roomLauncherProvider).createAndJoinLiveRoom(
            name: name,
            description: description,
            tags: tags,
          );
    } finally {
      // Refresh the global rooms list after any attempt.
      ref.invalidate(liveRoomsProvider);
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
