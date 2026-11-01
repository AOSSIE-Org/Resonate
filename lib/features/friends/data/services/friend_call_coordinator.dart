import 'dart:async';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/auth/data/services/callkit_service.dart';
import 'package:resonate/features/friends/data/repositories/friend_call_repository.dart';
import 'package:resonate/features/friends/model/friend_call_state.dart';
import 'package:resonate/features/friends/model/friends_model.dart';
import 'package:resonate/features/friends/model/friends_state.dart';
import 'package:resonate/features/activity_status/data/user_activity_status.dart';
import 'package:resonate/features/activity_status/model/call_blocked_by_activity_status.dart';
import 'package:resonate/features/rooms/data/services/livekit_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/enums/friend_call_status.dart';
import 'package:resonate/utils/realtime_event.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/shared/widgets/snackbar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/friend_call_coordinator.g.dart';


@Riverpod(keepAlive: true)
class FriendCallCoordinator extends _$FriendCallCoordinator {
  StreamSubscription<RealtimeMessage>? _callSub;

  @override
  FriendCallState build() {
    ref.onDispose(_cancelSub);
    return const FriendCallState();
  }

  // Starts a call to the other side and rings them over FCM.
  Future<void> startCall(FriendsModel friend) async {
    final me = ref.read(requireUserProvider);
    final amSender = friend.senderId == me.uid;
    final recieverFCMToken = amSender
        ? friend.recieverFCMToken
        : friend.senderFCMToken;
    if (recieverFCMToken == null) {
      throw const FriendsFailure.unknown('Friend has no notification token');
    }

    final recieverUid = amSender ? friend.recieverId : friend.senderId;
    final cachedStatus = ref.read(userActivityStatusProvider)[recieverUid];
    if (cachedStatus != null && cachedStatus.blocksCalls) {
      throw CallBlockedByActivityStatus(cachedStatus);
    }

    final repo = ref.read(friendCallRepositoryProvider);
    final call = await repo.createCall(
      callerName: amSender ? friend.senderName : friend.recieverName,
      recieverName: amSender ? friend.recieverName : friend.senderName,
      callerUsername: amSender
          ? friend.senderUsername
          : friend.recieverUsername,
      recieverUsername: amSender
          ? friend.recieverUsername
          : friend.senderUsername,
      callerUid: amSender ? friend.senderId : friend.recieverId,
      recieverUid: amSender ? friend.recieverId : friend.senderId,
      callerProfileImageUrl: amSender
          ? friend.senderProfileImgUrl
          : friend.recieverProfileImgUrl,
      recieverProfileImageUrl: amSender
          ? friend.recieverProfileImgUrl
          : friend.senderProfileImgUrl,
      livekitRoomId: friend.docId,
    );
    final blockedBy = await repo.sendCallNotification(
      call: call,
      recieverFCMToken: recieverFCMToken,
    );
    if (blockedBy != null) {
      try {
        await repo.setCallStatus(call, FriendCallStatus.declined);
      } catch (e) {
        log('startCall: could not close the blocked call row: $e');
      }
      throw CallBlockedByActivityStatus(blockedBy);
    }

    if (!ref.mounted) return;
    state = FriendCallState(activeCall: call);
    _listenToCall(call.docId);

    ref.read(routerProvider).push(RoutePaths.ringingScreen);
  }

  // CallKit accept callback receiver side.
  Future<void> onAnswerCall(Map<String, dynamic> extra) async {
    final repo = ref.read(friendCallRepositoryProvider);
    var call = await repo.getCall(extra['call_id'] as String);
    if (call.callStatus == FriendCallStatus.ended) {
      // Caller hung up before we answered, clear the lingering CallKit UI.
      await ref.read(callKitServiceProvider).endAllCalls();
      return;
    }

    call = await repo.setCallStatus(call, FriendCallStatus.connected);
    state = state.copyWith(
      activeCall: call,
      isMicOn: false,
      isLoudSpeakerOn: true,
    );
    _listenToCall(
      call.docId,
    ); // A leftover subscription could watch a previous call.

    await _joinCall(roomId: call.livekitRoomId, userId: call.recieverUid);
  }

  Future<void> onDeclinedCall(Map<String, dynamic> extra) async {
    final repo = ref.read(friendCallRepositoryProvider);
    final call = await repo.getCall(extra['call_id'] as String);
    final updated = await repo.setCallStatus(call, FriendCallStatus.declined);
    state = state.copyWith(activeCall: updated);
  }

  Future<void> endCall() async {
    final call = state.activeCall;
    if (call == null) return;

    try {
      final updated = await ref
          .read(friendCallRepositoryProvider)
          .setCallStatus(call, FriendCallStatus.ended);
      state = state.copyWith(activeCall: updated);
    } catch (e) {
      log('endCall: setCallStatus failed: $e');
    }

    await _teardownCall();
    ref.read(routerProvider).go(RoutePaths.tabview);
  }

  Future<void> toggleMic() async {
    final next = !state.isMicOn;
    state = state.copyWith(isMicOn: next);
    try {
      await ref
          .read(liveKitControllerProvider.notifier)
          .setMicrophoneEnabled(next);
    } catch (e) {
      log('Mic toggle failed: $e');
    }
  }

  Future<void> toggleLoudSpeaker() async {
    final next = !state.isLoudSpeakerOn;
    state = state.copyWith(isLoudSpeakerOn: next);
    try {
      await ref
          .read(liveKitControllerProvider.notifier)
          .setSpeakerphoneOn(next);
    } catch (e) {
      log('Speaker toggle failed: $e');
    }
  }

  Future<void> _joinCall({
    required String roomId,
    required String userId,
  }) async {
    try {
      final joinInfo = await ref
          .read(friendCallRepositoryProvider)
          .callJoinInfo(roomId: roomId, userId: userId);
      final connected = await ref
          .read(liveKitControllerProvider.notifier)
          .connect(
            liveKitUri: joinInfo.liveKitUri,
            roomToken: joinInfo.roomToken,
          );
      if (state.activeCall?.callStatus != FriendCallStatus.connected) {
        await ref.read(liveKitControllerProvider.notifier).disconnect();
        return;
      }
      if (!connected) throw Exception('LiveKit connection failed');

      ref.read(routerProvider).push(RoutePaths.friendCallScreen);
    } catch (e) {
      log('Joining call failed: $e');
      _notifyConnectionFailed();
      await _teardownCall();
      ref.read(routerProvider).go(RoutePaths.tabview);
    }
  }

  void _listenToCall(String callDocId) {
    _callSub?.cancel();
    _callSub = ref
        .read(friendCallRepositoryProvider)
        .callStream(callDocId)
        .listen((event) async {
          if (realtimeAction(event.events) != 'update') return;
          final call = state.activeCall;
          if (call == null) return;
          final status = event.payload['callStatus'];
          if (status == FriendCallStatus.connected.name &&
              call.callStatus != FriendCallStatus.connected) {
            state = state.copyWith(
              activeCall: call.copyWith(callStatus: FriendCallStatus.connected),
            );
            await _joinCall(roomId: call.livekitRoomId, userId: call.callerUid);
          } else if (status == FriendCallStatus.ended.name &&
              call.callStatus != FriendCallStatus.ended) {
            state = state.copyWith(
              activeCall: call.copyWith(callStatus: FriendCallStatus.ended),
            );
            await _teardownCall();
            ref.read(routerProvider).go(RoutePaths.tabview);
          } else if (status == FriendCallStatus.declined.name &&
              call.callStatus != FriendCallStatus.declined) {
            state = state.copyWith(
              activeCall: call.copyWith(callStatus: FriendCallStatus.declined),
            );
            _notifyDeclined(call.recieverName);
            await _teardownCall();
            ref.read(routerProvider).go(RoutePaths.tabview);
          }
        });
  }

  void _notifyDeclined(String recieverName) {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null) return;
    customSnackbar(
      AppLocalizations.of(ctx)!.callDeclined,
      AppLocalizations.of(ctx)!.callDeclinedTo(recieverName),
      LogType.info,
    );
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

  Future<void> _teardownCall() async {
    await _cancelSub();
    try {
      await ref.read(liveKitControllerProvider.notifier).disconnect();
    } catch (e) {
      log('teardownCall: disconnect failed: $e');
    }
    try {
      await ref.read(callKitServiceProvider).endAllCalls();
    } catch (e) {
      log('CallKit endAllCalls failed: $e');
    }
  }

  Future<void> _cancelSub() async {
    final sub = _callSub;
    _callSub = null;
    await sub?.cancel();
  }
}
