import 'dart:async';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:resonate/features/auth/viewmodel/current_user.dart';
import 'package:resonate/features/rooms/viewmodel/livekit_notifier.dart';
import 'package:resonate/features/stories/data/repositories/live_chapter_repository.dart';
import 'package:resonate/features/stories/data/services/whisper_transcription_service.dart';
import 'package:resonate/features/stories/model/live_chapter_attendees_model.dart';
import 'package:resonate/features/stories/model/live_chapter_model.dart';
import 'package:resonate/features/stories/model/live_chapter_state.dart';
import 'package:resonate/features/stories/viewmodel/whisper_model_notifier.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/live_chapter_notifier.g.dart';

@Riverpod(keepAlive: true)
class LiveChapter extends _$LiveChapter {
  StreamSubscription<RealtimeMessage>? _attendeesSub;

  @override
  LiveChapterState build() {
    ref.onDispose(() => _attendeesSub?.cancel());
    return const LiveChapterState();
  }

  bool get isAdmin {
    final model = state.model;
    if (model == null) return false;
    return model.authorUid == ref.read(requireUserProvider).uid;
  }

  bool checkUserIsAdmin(String uid) => state.model?.authorUid == uid;

  Future<void> startLiveChapter({
    required String chapterTitle,
    required String chapterDescription,
    required String storyId,
    required String storyName,
    String? roomId, // injectable for tests; minted here so views never touch the SDK
  }) async {
    roomId ??= ID.unique();
    final user = ref.read(requireUserProvider);
    final model = LiveChapterModel(
      livekitRoomId: roomId,
      authorUid: user.uid,
      authorProfileImageUrl: user.profileImageUrl ?? '',
      authorName: user.displayName,
      chapterTitle: chapterTitle,
      chapterDescription: chapterDescription,
      storyId: storyId,
      followersFCMToken: user.followers.map((e) => e.fcmToken).toList(),
      attendees: LiveChapterAttendeesModel(
        liveChapterId: roomId,
        users: const [],
        userIds: const [],
      ),
      id: roomId,
    );

    final repo = ref.read(liveChapterRepositoryProvider);
    await repo.createLiveChapterDocs(model);
    final join = await repo.createLiveChapterRoom(
      appwriteRoomId: roomId,
      adminUid: user.uid,
    );
    final connected = await ref
        .read(liveKitProvider.notifier)
        .connect(
          liveKitUri: join.liveKitUri,
          roomToken: join.roomToken,
          isLiveChapter: true,
        );
    if (!connected) {
      await repo.deleteLiveChapterDocs(roomId);
      await repo.deleteLiveChapterRoom(roomId);
      throw StateError('Unable to connect to the live chapter room');
    }

    state = state.copyWith(model: model);

    if (user.followers.isNotEmpty) {
      await repo.sendLiveChapterNotification(
        creatorId: user.uid,
        title: 'Live Chapter Starting!',
        body:
            "${user.displayName} is starting a Live Chapter in $storyName: $chapterTitle. Tune In!",
      );
    }

    _listenForAttendees(roomId);
  }

  Future<void> joinLiveChapter(String roomId, LiveChapterModel data) async {
    final user = ref.read(requireUserProvider);
    final attendees =
        data.attendees ??
        LiveChapterAttendeesModel(
          liveChapterId: roomId,
          users: const [],
          userIds: const [],
        );
    final newAttendees = attendees.copyWith(
      userIds: [...attendees.users.map((e) => e.id), user.uid],
      users: [
        ...attendees.users,
        LiveChapterAttendee(
          id: user.uid,
          name: user.displayName,
          profileImageUrl: user.profileImageUrl,
        ),
      ],
    );

    final repo = ref.read(liveChapterRepositoryProvider);
    await repo.updateAttendees(roomId, newAttendees);
    state = state.copyWith(model: data.copyWith(attendees: newAttendees));

    final join = await repo.joinLiveChapterRoom(
      roomId: roomId,
      userId: user.uid,
    );
    final connected = await ref
        .read(liveKitProvider.notifier)
        .connect(
          liveKitUri: join.liveKitUri,
          roomToken: join.roomToken,
          isLiveChapter: true,
        );
    if (!connected) {
      throw StateError('Unable to connect to the live chapter room');
    }

    _listenForAttendees(roomId);
  }

  void _listenForAttendees(String roomId) {
    final repo = ref.read(liveChapterRepositoryProvider);
    _attendeesSub?.cancel();
    _attendeesSub = repo.attendeesStream(roomId).listen((event) async {
      try {
        final eventName = event.events.first;
        if (eventName.endsWith('.update')) {
          final model = state.model;
          if (model == null || !ref.mounted) return;
          final newAttendees = LiveChapterAttendeesModel.fromJson(
            event.payload,
          );
          state = state.copyWith(
            model: model.copyWith(attendees: newAttendees),
          );
        } else if (eventName.endsWith('.delete')) {
          if (!isAdmin) {
            await _attendeesSub?.cancel();
            await ref.read(liveKitProvider.notifier).disconnect();
            if (!ref.mounted) return;
            ref.read(routerProvider).go(RoutePaths.tabview);
            state = const LiveChapterState();
          }
        }
      } catch (e) {
        log('live chapter attendees listener error: $e');
      }
    });
  }

  Future<void> turnOnMic() async {
    await ref.read(liveKitProvider.notifier).setMicrophoneEnabled(true);
    state = state.copyWith(isMicOn: true);
  }

  Future<void> turnOffMic() async {
    await ref.read(liveKitProvider.notifier).setMicrophoneEnabled(false);
    state = state.copyWith(isMicOn: false);
  }

  Future<void> setRecording(bool recording) =>
      ref.read(liveKitProvider.notifier).setRecording(recording);

  Future<void> leaveRoom() async {
    final model = state.model;
    if (model == null) return;
    final user = ref.read(requireUserProvider);
    await _attendeesSub?.cancel();

    final attendees = model.attendees;
    if (attendees != null) {
      final remainingUsers = attendees.users
          .where((element) => element.id != user.uid)
          .toList();
      final updated = attendees.copyWith(
        users: remainingUsers,
        userIds: remainingUsers.map((e) => e.id).toList(),
      );
      await ref
          .read(liveChapterRepositoryProvider)
          .updateAttendees(model.id, updated);
    }
    await ref.read(liveKitProvider.notifier).disconnect();
    state = const LiveChapterState();
    ref.read(routerProvider).go(RoutePaths.tabview);
  }

  Future<String> endLiveChapter() async {
    final model = state.model;
    if (model == null) return '';
    final repo = ref.read(liveChapterRepositoryProvider);

    await ref.read(liveKitProvider.notifier).setRecording(false);
    
    try {
      await repo.deleteLiveChapterDocs(model.id);
    } catch (e) {
      log('endLiveChapter: deleteLiveChapterDocs failed: $e');
    }
    String lyrics = '';
    try {
      final whisperModel = await ref.read(whisperModelSettingProvider.future);
      lyrics = await ref
          .read(whisperTranscriptionServiceProvider(whisperModel))
          .transcribeChapter(model.livekitRoomId);
    } catch (e) {
      log('endLiveChapter: transcription failed: $e');
    }
    try {
      await repo.deleteLiveChapterRoom(model.livekitRoomId);
    } catch (e) {
      log('endLiveChapter: deleteLiveChapterRoom failed: $e');
    }
    await _attendeesSub?.cancel();
    try {
      await ref.read(liveKitProvider.notifier).disconnect();
    } catch (e) {
      log('endLiveChapter: disconnect failed: $e');
    }
    return lyrics;
  }

  void reset() {
    _attendeesSub?.cancel();
    _attendeesSub = null;
    state = const LiveChapterState();
  }
}
