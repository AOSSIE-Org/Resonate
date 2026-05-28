import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:resonate/core/container.dart';
import 'package:resonate/features/rooms/data/rooms_repository.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/model/participant.dart';
import 'package:resonate/features/rooms/model/single_room_state.dart';
import 'package:resonate/features/rooms/viewmodel/livekit_notifier.dart';
import 'package:resonate/features/rooms/viewmodel/rooms_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/single_room_notifier.g.dart';

@riverpod
class SingleRoomNotifier extends _$SingleRoomNotifier {
  StreamSubscription<RealtimeMessage>? _participantSub;

  @override
  Future<SingleRoomState> build(AppwriteRoom appwriteRoom) async {
    ref.onDispose(_disposeStream);

    final me = _meFor(appwriteRoom);
    final repo = ref.read(roomsRepositoryProvider);
    final participants = await repo.loadParticipants(appwriteRoom.id);
    final sorted = _sort(participants);

    _subscribe(appwriteRoom);

    return SingleRoomState(me: me, participants: sorted);
  }

  Participant _meFor(AppwriteRoom room) {
    final user = requireCurrentAuthUser;
    return Participant(
      uid: user.uid,
      email: user.email,
      name: user.userName ?? '',
      dpUrl: user.profileImageUrl ?? '',
      isAdmin: room.isUserAdmin,
      isMicOn: false,
      isModerator: room.isUserAdmin,
      isSpeaker: room.isUserAdmin,
      hasRequestedToBeSpeaker: false,
    );
  }

  void _subscribe(AppwriteRoom appwriteRoom) {
    final repo = ref.read(roomsRepositoryProvider);
    final channel = RoomsRepository.participantChannel();

    _participantSub = repo.participantStream(appwriteRoom.id).listen((event) async {
      final docId = event.payload['\$id'] as String;
      final action = event.events.first.substring(
        channel.length + 1 + docId.length + 1,
      );
      final current = state.value;
      if (current == null) return;

      switch (action) {
        case 'create':
          {
            final newParticipant = await repo.buildParticipantFromRow(
              Row.fromMap(event.payload),
            );
            final list = [...current.participants, newParticipant];
            state = AsyncData(current.copyWith(participants: _sort(list)));
            break;
          }
        case 'update':
          {
            final updatedUid = event.payload['uid'] as String;
            var nextMe = current.me;
            if (updatedUid == current.me.uid) {
              nextMe = current.me.copyWith(
                isModerator: event.payload['isModerator'] as bool,
                hasRequestedToBeSpeaker:
                    (event.payload['hasRequestedToBeSpeaker'] as bool?) ?? false,
                isMicOn: event.payload['isMicOn'] as bool,
                isSpeaker: event.payload['isSpeaker'] as bool,
              );
            }
            final updated = current.participants.map((p) {
              if (p.uid != updatedUid) return p;
              return p.copyWith(
                isModerator: event.payload['isModerator'] as bool,
                hasRequestedToBeSpeaker:
                    (event.payload['hasRequestedToBeSpeaker'] as bool?) ?? false,
                isMicOn: event.payload['isMicOn'] as bool,
                isSpeaker: event.payload['isSpeaker'] as bool,
              );
            }).toList();

            state = AsyncData(
              current.copyWith(me: nextMe, participants: _sort(updated)),
            );

            // If we got demoted from speaker while mic was on, mute.
            if (updatedUid == current.me.uid &&
                !(event.payload['isSpeaker'] as bool) &&
                current.me.isMicOn) {
              await turnOffMic(appwriteRoom);
            }
            break;
          }
        case 'delete':
          {
            final removedUid = event.payload['uid'] as String;
            if (removedUid == current.me.uid) {
              // We were kicked. Notifier disposal handled by view layer
              // observing the participant list / failure.
              break;
            }
            final filtered = current.participants
                .where((p) => p.uid != removedUid)
                .toList();
            state = AsyncData(current.copyWith(participants: filtered));
            break;
          }
      }
    });
  }

  Future<void> _disposeStream() async {
    await _participantSub?.cancel();
    _participantSub = null;
  }

  List<Participant> _sort(List<Participant> participants) {
    final sorted = [...participants];
    sorted.sort((a, b) {
      if (b.isAdmin && !a.isAdmin) return 1;
      if (!b.isAdmin && a.isAdmin) return -1;
      if (b.isModerator && !a.isModerator) return 1;
      if (!b.isModerator && a.isModerator) return -1;
      if (b.isSpeaker && !a.isSpeaker) return 1;
      if (!b.isSpeaker && a.isSpeaker) return -1;
      if (b.hasRequestedToBeSpeaker && !a.hasRequestedToBeSpeaker) return 1;
      if (!b.hasRequestedToBeSpeaker && a.hasRequestedToBeSpeaker) return -1;
      return 0;
    });
    return sorted;
  }

  Future<void> turnOnMic(AppwriteRoom appwriteRoom) => _setMic(appwriteRoom, true);
  Future<void> turnOffMic(AppwriteRoom appwriteRoom) => _setMic(appwriteRoom, false);

  Future<void> _setMic(AppwriteRoom appwriteRoom, bool enabled) async {
    // Optimistic UI update so the button reacts even if LiveKit/Appwrite are
    // slow or fail. The Realtime stream will overwrite this with the
    // authoritative value once the update propagates.
    final current = state.value;
    if (current != null) {
      state = AsyncData(
        current.copyWith(me: current.me.copyWith(isMicOn: enabled)),
      );
    }

    try {
      await ref.read(liveKitProvider.notifier).setMicrophoneEnabled(enabled);
    } catch (_) {}

    final docId = appwriteRoom.myDocId;
    if (docId == null) return;
    try {
      await ref.read(roomsRepositoryProvider).updateParticipantDoc(
        docId: docId,
        data: {'isMicOn': enabled},
      );
    } catch (_) {}
  }

  Future<void> raiseHand(AppwriteRoom appwriteRoom) async {
    await ref.read(roomsRepositoryProvider).updateParticipantDoc(
      docId: appwriteRoom.myDocId!,
      data: {'hasRequestedToBeSpeaker': true},
    );
    final current = state.value;
    if (current != null) {
      state = AsyncData(
        current.copyWith(me: current.me.copyWith(hasRequestedToBeSpeaker: true)),
      );
    }
  }

  Future<void> unRaiseHand(AppwriteRoom appwriteRoom) async {
    await ref.read(roomsRepositoryProvider).updateParticipantDoc(
      docId: appwriteRoom.myDocId!,
      data: {'hasRequestedToBeSpeaker': false},
    );
    final current = state.value;
    if (current != null) {
      state = AsyncData(
        current.copyWith(me: current.me.copyWith(hasRequestedToBeSpeaker: false)),
      );
    }
  }

  Future<void> makeModerator(AppwriteRoom appwriteRoom, Participant participant) =>
      _participantMutation(appwriteRoom, participant, {
        'isSpeaker': true,
        'hasRequestedToBeSpeaker': false,
        'isModerator': true,
      });

  Future<void> removeModerator(AppwriteRoom appwriteRoom, Participant participant) =>
      _participantMutation(appwriteRoom, participant, {
        'isSpeaker': false,
        'hasRequestedToBeSpeaker': false,
        'isModerator': false,
      });

  Future<void> makeSpeaker(AppwriteRoom appwriteRoom, Participant participant) =>
      _participantMutation(appwriteRoom, participant, {
        'isSpeaker': true,
        'hasRequestedToBeSpeaker': false,
      });

  Future<void> makeListener(AppwriteRoom appwriteRoom, Participant participant) =>
      _participantMutation(appwriteRoom, participant, {
        'isSpeaker': false,
        'hasRequestedToBeSpeaker': false,
      });

  Future<void> _participantMutation(
    AppwriteRoom appwriteRoom,
    Participant participant,
    Map<String, dynamic> data,
  ) async {
    final repo = ref.read(roomsRepositoryProvider);
    final docId = await repo.getParticipantDocId(
      roomId: appwriteRoom.id,
      participantUid: participant.uid,
    );
    await repo.updateParticipantDoc(docId: docId, data: data);
  }

  Future<void> kickOutParticipant(
    AppwriteRoom appwriteRoom,
    Participant participant,
  ) async {
    final repo = ref.read(roomsRepositoryProvider);
    final docId = await repo.getParticipantDocId(
      roomId: appwriteRoom.id,
      participantUid: participant.uid,
    );
    await repo.kickParticipant(docId);
  }

  Future<void> reportAndKick(
    AppwriteRoom appwriteRoom,
    Participant participant,
  ) async {
    final repo = ref.read(roomsRepositoryProvider);
    await repo.reportParticipant(
      roomId: appwriteRoom.id,
      participantUid: participant.uid,
      currentReported: appwriteRoom.reportedUsers,
    );
    await kickOutParticipant(appwriteRoom, participant);
  }

  Future<void> leaveRoom(AppwriteRoom appwriteRoom) async {
    final current = state.value;
    if (current != null) {
      state = AsyncData(current.copyWith(isLoading: true));
    }
    await _disposeStream();
    await ref.read(roomsRepositoryProvider).leaveRoom(
      roomId: appwriteRoom.id,
      userId: requireCurrentAuthUser.uid,
    );
    await ref.read(liveKitProvider.notifier).disconnect();
  }

  Future<void> deleteRoom(AppwriteRoom appwriteRoom) async {
    final current = state.value;
    if (current != null) {
      state = AsyncData(current.copyWith(isLoading: true));
    }
    await ref.read(roomsRepositoryProvider).deleteRoom(roomId: appwriteRoom.id);
    await ref.read(liveKitProvider.notifier).disconnect();
    ref.invalidate(roomsProvider);
  }
}
