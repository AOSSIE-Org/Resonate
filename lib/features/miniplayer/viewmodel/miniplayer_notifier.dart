import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/friends/data/services/friend_call_coordinator.dart';
import 'package:resonate/features/friends/model/friend_call_model.dart';
import 'package:resonate/features/live_audio/data/speaking_levels.dart';
import 'package:resonate/features/miniplayer/model/miniplayer_session.dart';
import 'package:resonate/features/rooms/data/active_room.dart';
import 'package:resonate/features/rooms/data/services/room_session.dart';
import 'package:resonate/features/rooms/model/participant.dart';
import 'package:resonate/utils/enums/friend_call_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/miniplayer_notifier.g.dart';

@riverpod
class Miniplayer extends _$Miniplayer {
  @override
  MiniplayerSession? build() => _callSession() ?? _roomSession();

  MiniplayerSession? _callSession() {
    final callState = ref.watch(friendCallCoordinatorProvider);
    final call = callState.activeCall;
    if (call == null || call.callStatus != FriendCallStatus.connected) {
      return null;
    }

    final remote = call.sidesFor(ref.watch(currentUserProvider)?.uid).remote;
    return MiniplayerSession(
      speakerUid: remote.uid,
      avatarUrl: remote.imageUrl,
      isMicOn: callState.isMicOn,
      canToggleMic: true,
    );
  }

  MiniplayerSession? _roomSession() {
    final room = ref.watch(activeRoomProvider);
    if (room == null) return null;

    final state = ref.watch(roomSessionProvider(room)).value;
    if (state == null) return null;

    final speaker = _loudest(state.participants) ?? state.me;
    return MiniplayerSession(
      speakerUid: speaker.uid,
      avatarUrl: speaker.dpUrl,
      isMicOn: state.me.isMicOn,
      canToggleMic: state.me.isSpeaker,
      title: room.name,
      room: room,
    );
  }

  // Whoever is loudest right now, else the host
  Participant? _loudest(List<Participant> participants) {
    if (participants.isEmpty) return null;
    final levels = ref.watch(speakingLevelsProvider);

    Participant? loudest;
    var best = 0.0;
    for (final participant in participants) {
      final level = levels[participant.uid] ?? 0;
      if (level > best) {
        best = level;
        loudest = participant;
      }
    }
    return loudest ??
        participants.firstWhere(
          (p) => p.isAdmin,
          orElse: () => participants.first,
        );
  }

  Future<void> toggleMic() async {
    final session = state;
    if (session == null || !session.canToggleMic) return;

    final room = session.room;
    if (room == null) {
      await ref.read(friendCallCoordinatorProvider.notifier).toggleMic();
      return;
    }

    final notifier = ref.read(roomSessionProvider(room).notifier);
    if (session.isMicOn) {
      await notifier.turnOffMic(room);
    } else {
      await notifier.turnOnMic(room);
    }
  }
}
