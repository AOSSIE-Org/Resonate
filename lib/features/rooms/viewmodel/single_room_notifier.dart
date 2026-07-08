import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:resonate/features/auth/viewmodel/current_user.dart';
import 'package:resonate/features/rooms/data/repositories/rooms_repository.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/model/participant.dart';
import 'package:resonate/features/rooms/model/single_room_state.dart';
import 'package:resonate/features/rooms/viewmodel/livekit_notifier.dart';
import 'package:resonate/features/rooms/viewmodel/rooms_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/single_room_notifier.g.dart';

enum ParticipantRole { moderator, speaker, listener }

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
    final user = ref.read(requireUserProvider);
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

    _participantSub = repo.participantStream(appwriteRoom.id).listen((
      event,
    ) async {
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
                    (event.payload['hasRequestedToBeSpeaker'] as bool?) ??
                    false,
                isMicOn: event.payload['isMicOn'] as bool,
                isSpeaker: event.payload['isSpeaker'] as bool,
              );
            }
            final updated = current.participants.map((p) {
              if (p.uid != updatedUid) return p;
              return p.copyWith(
                isModerator: event.payload['isModerator'] as bool,
                hasRequestedToBeSpeaker:
                    (event.payload['hasRequestedToBeSpeaker'] as bool?) ??
                    false,
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
              // kicked
              await _disposeStream();
              await ref.read(liveKitProvider.notifier).disconnect();
              final latest = state.value;
              if (latest != null) {
                state = AsyncData(latest.copyWith(wasKicked: true));
              }
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

  Future<void> turnOnMic(AppwriteRoom appwriteRoom) =>
      _setMic(appwriteRoom, true);
  Future<void> turnOffMic(AppwriteRoom appwriteRoom) =>
      _setMic(appwriteRoom, false);

  Future<void> _setMic(AppwriteRoom appwriteRoom, bool enabled) async {
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
      await ref
          .read(roomsRepositoryProvider)
          .updateParticipantDoc(docId: docId, data: {'isMicOn': enabled});
    } catch (_) {}
  }

  Future<void> raiseHand(AppwriteRoom appwriteRoom) async {
    await ref
        .read(roomsRepositoryProvider)
        .updateParticipantDoc(
          docId: appwriteRoom.myDocId!,
          data: {'hasRequestedToBeSpeaker': true},
        );
    final current = state.value;
    if (current != null) {
      state = AsyncData(
        current.copyWith(
          me: current.me.copyWith(hasRequestedToBeSpeaker: true),
        ),
      );
    }
  }

  Future<void> unRaiseHand(AppwriteRoom appwriteRoom) async {
    await ref
        .read(roomsRepositoryProvider)
        .updateParticipantDoc(
          docId: appwriteRoom.myDocId!,
          data: {'hasRequestedToBeSpeaker': false},
        );
    final current = state.value;
    if (current != null) {
      state = AsyncData(
        current.copyWith(
          me: current.me.copyWith(hasRequestedToBeSpeaker: false),
        ),
      );
    }
  }

  Future<void> setRole(
    AppwriteRoom appwriteRoom,
    Participant participant,
    ParticipantRole role,
  ) async {
    final repo = ref.read(roomsRepositoryProvider);
    final docId = await repo.getParticipantDocId(
      roomId: appwriteRoom.id,
      participantUid: participant.uid,
    );
    if (docId == null) return; // participant already left
    await repo.updateParticipantDoc(
      docId: docId,
      data: {
        'isModerator': role == ParticipantRole.moderator,
        'isSpeaker': role != ParticipantRole.listener,
        'hasRequestedToBeSpeaker': false,
      },
    );
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
    if (docId == null) return; // participant already left
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
    await ref
        .read(roomsRepositoryProvider)
        .leaveRoom(roomId: appwriteRoom.id, userId: ref.read(requireUserProvider).uid);
    await ref.read(liveKitProvider.notifier).disconnect();
    ref.invalidate(roomsProvider);
  }

  Future<void> deleteRoom(AppwriteRoom appwriteRoom) async {
    final current = state.value;
    if (current != null) {
      state = AsyncData(current.copyWith(isLoading: true));
    }
    await _disposeStream();
    await ref.read(roomsRepositoryProvider).deleteRoom(roomId: appwriteRoom.id);
    await ref.read(liveKitProvider.notifier).disconnect();
    ref.invalidate(roomsProvider);
  }
}
