import 'dart:async';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:resonate/features/auth/viewmodel/current_user.dart';
import 'package:resonate/features/auth/viewmodel/auth_notifier.dart';
import 'package:resonate/features/friends/data/pair_chat_repository.dart';
import 'package:resonate/features/friends/model/pair_chat_state.dart';
import 'package:resonate/features/rooms/viewmodel/livekit_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/models/resonate_user.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/shared/widgets/snackbar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/pair_chat_notifier.g.dart';

@Riverpod(keepAlive: true)
class PairChatNotifier extends _$PairChatNotifier {
  StreamSubscription<RealtimeMessage>? _activePairSub;
  StreamSubscription<RealtimeMessage>? _newUsersSub;

  @override
  PairChatState build() {
    ref.onDispose(_cancelSubs);
    return const PairChatState();
  }

  Future<void> reset() async {
    state = const PairChatState();
    await _cancelSubs();
  }

  void setAnonymous(bool isAnonymous) {
    state = state.copyWith(isAnonymous: isAnonymous);
  }

  void setLanguage(String languageIso) {
    state = state.copyWith(languageIso: languageIso);
  }

  void setPairRating(double rating) {
    state = state.copyWith(pairRating: rating);
  }

  Future<void> quickMatch() async {
    final me = ref.read(requireUserProvider);
    _listenForActivePair();

    final requestDocId =
        await ref.read(pairChatRepositoryProvider).createPairRequest(
      data: {
        'languageIso': state.languageIso,
        'isAnonymous': state.isAnonymous,
        'uid': me.uid,
        'isRandom': true,
        if (!state.isAnonymous) 'userName': me.userName,
      },
    );
    state = state.copyWith(requestDocId: requestDocId);
  }

  Future<void> choosePartner() async {
    final me = ref.read(requireUserProvider);
    state = state.copyWith(isAnonymous: false);
    _listenForNewUsers();
    _listenForActivePair();

    final requestDocId =
        await ref.read(pairChatRepositoryProvider).createPairRequest(
      data: {
        'languageIso': state.languageIso,
        'isAnonymous': false,
        'uid': me.uid,
        'isRandom': false,
        'profileImageUrl': me.profileImageUrl,
        'userName': me.userName,
        'name': me.displayName,
        'userRating':
            me.ratingCount == 0 ? 0 : me.ratingTotal / me.ratingCount,
      },
    );
    state = state.copyWith(requestDocId: requestDocId);
  }

  Future<void> convertToRandom() async {
    await _newUsersSub?.cancel();
    _newUsersSub = null;
    _listenForActivePair();
    await ref
        .read(pairChatRepositoryProvider)
        .convertRequestToRandom(state.requestDocId!);
  }

  Future<void> loadUsers() async {
    state = state.copyWith(isUserListLoading: true, onlineUsers: const []);
    try {
      final users = await ref
          .read(pairChatRepositoryProvider)
          .listOnlineUsers(excludeUid: ref.read(requireUserProvider).uid);
      if (!ref.mounted) return;
      state = state.copyWith(onlineUsers: users, isUserListLoading: false);
    } catch (e) {
      log('Loading pair chat users failed: $e');
      if (!ref.mounted) return;
      state = state.copyWith(isUserListLoading: false);
    }
  }

  Future<void> pairWithSelectedUser(ResonateUser user) async {
    final me = ref.read(requireUserProvider);
    await ref.read(pairChatRepositoryProvider).createActivePair(
      uid1: me.uid,
      uid2: user.uid!,
      userName1: me.userName,
      userName2: user.userName,
      requestDocId1: state.requestDocId,
      requestDocId2: user.docId,
    );
    // Both sides join through their own active-pair Realtime listener.
  }

  Future<void> cancelRequest() async {
    final requestDocId = state.requestDocId;
    state = state.copyWith(requestDocId: null);
    await _cancelSubs();
    if (requestDocId != null) {
      try {
        await ref
            .read(pairChatRepositoryProvider)
            .deletePairRequest(requestDocId);
      } catch (e) {
        log('Cancel pair request failed: $e');
      }
    }
  }

  Future<void> toggleMic() async {
    final next = !state.isMicOn;
    state = state.copyWith(isMicOn: next);
    try {
      await ref.read(liveKitProvider.notifier).setMicrophoneEnabled(next);
    } catch (e) {
      log('Mic toggle failed: $e');
    }
  }

  Future<void> toggleLoudSpeaker() async {
    final next = !state.isLoudSpeakerOn;
    state = state.copyWith(isLoudSpeakerOn: next);
    try {
      await ref.read(liveKitProvider.notifier).setSpeakerphoneOn(next);
    } catch (e) {
      log('Speaker toggle failed: $e');
    }
  }

  Future<void> endChat() async {
    if (state.ended) return;
    state = state.copyWith(ended: true);

    await _cancelSubs();
    final activePairDocId = state.activePairDocId;
    if (activePairDocId != null) {
      try {
        await ref
            .read(pairChatRepositoryProvider)
            .deleteActivePair(activePairDocId);
      } catch (e) {
        log('Deleting active pair failed: $e');
      }
    }
    await ref.read(liveKitProvider.notifier).disconnect();
  }

  Future<void> submitRating() async {
    final me = ref.read(requireUserProvider);
    await ref.read(pairChatRepositoryProvider).updateUserRating(
      uid: me.uid,
      ratingTotal: me.ratingTotal + state.pairRating,
      ratingCount: me.ratingCount + 1,
    );
    await ref.read(authProvider.notifier).refresh();
  }

  void _listenForActivePair() {
    if (_activePairSub != null) return;
    final uid = ref.read(requireUserProvider).uid;
    final channel = PairChatRepository.activePairsChannel();

    _activePairSub = ref
        .read(pairChatRepositoryProvider)
        .activePairsStream()
        .listen((event) async {
      final uid1 = event.payload['uid1'] as String?;
      final uid2 = event.payload['uid2'] as String?;
      if (uid1 != uid && uid2 != uid) return;

      final docId = event.payload['\$id'].toString();
      final action = event.events.first.substring(
        channel.length + 1 + docId.length + 1,
      );
      switch (action) {
        case 'create':
          await _onPaired(event.payload, amUser1: uid1 == uid);
          break;
        case 'delete':
          await endChat();
          break;
      }
    });
  }

  Future<void> _onPaired(
    Map<String, dynamic> payload, {
    required bool amUser1,
  }) async {
    final repo = ref.read(pairChatRepositoryProvider);
    final partnerUid =
        (amUser1 ? payload['uid2'] : payload['uid1']) as String;
    final pairUsername =
        (amUser1 ? payload['userName2'] : payload['userName1']) as String?;
    final pairProfileImageUrl = await repo.getUserProfileImageUrl(partnerUid);
    if (_activePairSub == null) return;

    final activePairDocId = payload['\$id'] as String;
    state = state.copyWith(
      activePairDocId: activePairDocId,
      pairUsername: pairUsername,
      pairProfileImageUrl: pairProfileImageUrl,
      isMicOn: false,
      isLoudSpeakerOn: true,
      ended: false,
    );

    try {
      final joinInfo = await repo.pairJoinInfo(
        roomId: activePairDocId,
        userId: ref.read(requireUserProvider).uid,
      );
      if (_activePairSub == null || state.ended) return;

      final connected = await ref.read(liveKitProvider.notifier).connect(
        liveKitUri: joinInfo.liveKitUri,
        roomToken: joinInfo.roomToken,
      );
      if (_activePairSub == null || state.ended) {
        await ref.read(liveKitProvider.notifier).disconnect();
        return;
      }
      if (!connected) throw Exception('LiveKit connection failed');

      ref.read(routerProvider).push(RoutePaths.pairChat);
    } catch (e) {
      log('Joining pair chat failed: $e');
      _notifyConnectionFailed();
      await endChat();
      ref.read(routerProvider).go(RoutePaths.tabview);
    }
  }

  void _notifyConnectionFailed() {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null) return;
    customSnackbar(
      AppLocalizations.of(ctx)!.connectionFailed,
      AppLocalizations.of(ctx)!.unableToJoinRoom,
      LogType.error,
    );
  }

  void _listenForNewUsers() {
    if (_newUsersSub != null) return;
    final uid = ref.read(requireUserProvider).uid;

    _newUsersSub = ref
        .read(pairChatRepositoryProvider)
        .pairRequestsStream()
        .listen((event) {
      final eventName = event.events.first;
      if (eventName.endsWith('.create')) {
        // Skip our own request and anonymous ones
        if (event.payload['uid'] == uid ||
            event.payload['isAnonymous'] == true) {
          return;
        }
        try {
          final eventSplit = eventName.split('.');
          final docId = eventSplit[eventSplit.length - 2];
          final newUser =
              ResonateUser.fromJson({...event.payload, 'docId': docId});
          state = state.copyWith(onlineUsers: [...state.onlineUsers, newUser]);
        } catch (e) {
          log('Skipping malformed pair request payload: $e');
        }
      } else if (eventName.endsWith('.delete')) {
        final removedUid = event.payload['uid'];
        state = state.copyWith(
          onlineUsers: state.onlineUsers
              .where((user) => user.uid != removedUid)
              .toList(),
        );
      }
    });
  }

  // Nulls the fields before the async cancels
  Future<void> _cancelSubs() async {
    final activePairSub = _activePairSub;
    final newUsersSub = _newUsersSub;
    _activePairSub = null;
    _newUsersSub = null;
    await activePairSub?.cancel();
    await newUsersSub?.cancel();
  }
}
