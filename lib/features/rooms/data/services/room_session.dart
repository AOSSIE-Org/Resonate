import 'dart:async';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/rooms/data/repositories/rooms_repository.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/model/participant.dart';
import 'package:resonate/features/rooms/model/single_room_state.dart';
import 'package:resonate/features/rooms/model/user_report_model.dart';
import 'package:resonate/features/live_audio/data/services/livekit_controller.dart';
import 'package:resonate/utils/realtime_event.dart';
import 'package:resonate/features/rooms/data/live_rooms.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/room_session.g.dart';

enum ParticipantRole { moderator, speaker, listener }

@riverpod
class RoomSession extends _$RoomSession {
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

    _participantSub = repo.participantStream(appwriteRoom.id).listen((
      event,
    ) async {
      try {
        final action = realtimeAction(event.events);
        final current = state.value;
        if (current == null) return;

        switch (action) {
          case 'create':
            {
              final newParticipant = await repo.buildParticipantFromRow(
                Row.fromMap(event.payload),
              );
              if (!ref.mounted) return;
              final latest = state.value;
              if (latest == null) return;
              final list = [...latest.participants, newParticipant];
              state = AsyncData(latest.copyWith(participants: _sort(list)));
              break;
            }
          case 'update':
            {
              final updatedUid = event.payload['uid'] as String;
              var nextMe = current.me;
              if (updatedUid == current.me.uid) {
                nextMe = current.me.copyWith(
                  isModerator:
                      event.payload['isModerator'] as bool? ??
                      current.me.isModerator,
                  hasRequestedToBeSpeaker:
                      (event.payload['hasRequestedToBeSpeaker'] as bool?) ??
                      false,
                  isMicOn:
                      event.payload['isMicOn'] as bool? ?? current.me.isMicOn,
                  isSpeaker:
                      event.payload['isSpeaker'] as bool? ??
                      current.me.isSpeaker,
                );
              }
              final updated = current.participants.map((p) {
                if (p.uid != updatedUid) return p;
                return p.copyWith(
                  isModerator:
                      event.payload['isModerator'] as bool? ?? p.isModerator,
                  hasRequestedToBeSpeaker:
                      (event.payload['hasRequestedToBeSpeaker'] as bool?) ??
                      false,
                  isMicOn: event.payload['isMicOn'] as bool? ?? p.isMicOn,
                  isSpeaker:
                      event.payload['isSpeaker'] as bool? ?? p.isSpeaker,
                );
              }).toList();

              state = AsyncData(
                current.copyWith(me: nextMe, participants: _sort(updated)),
              );
              // If we got demoted from speaker while mic was on, mute.
              if (updatedUid == current.me.uid &&
                  !((event.payload['isSpeaker'] as bool?) ??
                      current.me.isSpeaker) &&
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
                await ref.read(liveKitControllerProvider.notifier).disconnect();
                if (!ref.mounted) return;
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
      } catch (e) {
        log('single room participant listener error: $e');
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
      await ref.read(liveKitControllerProvider.notifier).setMicrophoneEnabled(enabled);
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

  /// Files [report] against [participant], then removes them from the room.
  /// Returns false if filing failed, so the view can say so.
  Future<bool> reportAndKick(
    AppwriteRoom appwriteRoom,
    Participant participant, {
    required ReportDraft report,
  }) async {
    final repo = ref.read(roomsRepositoryProvider);
    try {
      await repo.submitUserReport(
        UserReportModel(
          reporterUid: ref.read(requireUserProvider).uid,
          reportedUid: participant.uid,
          reportType: report.type,
          reportText: report.details,
          reportedUser: participant.uid,
        ),
      );
    } catch (e) {
      log('reportAndKick: submitting the report failed: $e');
      return false;
    }
    await repo.reportParticipant(
      roomId: appwriteRoom.id,
      participantUid: participant.uid,
      currentReported: appwriteRoom.reportedUsers,
    );
    await kickOutParticipant(appwriteRoom, participant);
    return true;
  }

  Future<void> leaveRoom(AppwriteRoom appwriteRoom) async {
    await _disposeStream();
    try {
      await ref
          .read(roomsRepositoryProvider)
          .leaveRoom(
            roomId: appwriteRoom.id,
            userId: ref.read(requireUserProvider).uid,
          );
    } catch (e) {
      log('leaveRoom: repo.leaveRoom failed: $e');
    }
    try {
      await ref.read(liveKitControllerProvider.notifier).disconnect();
    } catch (e) {
      log('leaveRoom: disconnect failed: $e');
    }
    ref.invalidate(liveRoomsProvider);
  }

  Future<void> deleteRoom(AppwriteRoom appwriteRoom) async {
    await _disposeStream();
    // never strand the admin on delete.
    try {
      await ref
          .read(roomsRepositoryProvider)
          .deleteRoom(roomId: appwriteRoom.id);
    } catch (e) {
      log('deleteRoom: repo.deleteRoom failed: $e');
    }
    try {
      await ref.read(liveKitControllerProvider.notifier).disconnect();
    } catch (e) {
      log('deleteRoom: disconnect failed: $e');
    }
    ref.invalidate(liveRoomsProvider);
  }
}
