import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:appwrite/appwrite.dart';
import 'package:resonate/utils/dev_log.dart';
import 'package:resonate/core/providers/push_providers.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/auth/model/auth_user.dart';
import 'package:resonate/features/auth/data/services/notification_service.dart';
import 'package:resonate/features/friends/data/friend_call_coordinator.dart';
import 'package:resonate/features/friends/data/services/callkit_service.dart';
import 'package:resonate/features/shell/viewmodel/tabview_notifier.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/app_bootstrap.g.dart';

bool isTestMode = false;

// Boots app-wide services that need to be initialized after auth state
@Riverpod(keepAlive: true)
class AppBootstrap extends _$AppBootstrap {
  @override
  Future<void> build() async {
    final push = ref.watch(appwritePushProvider);

    if (!isTestMode) {
      await ref.read(callKitServiceProvider).requestFullScreenPermission();
    }

    final notifications = NotificationService(onTapPayload: _openUpcomingRoom);
    await notifications.initialize();
    PushSubscription? pushSubscription;
    String? subscribedUid;

    Future<void> syncPush(String? uid) async {
      if (uid == subscribedUid) return;
      subscribedUid = uid;
      pushSubscription?.unsubscribe();
      pushSubscription = null;
      if (uid == null) {
        log('[push] no signed-in user, not subscribing');
        return;
      }
      try {
        final subscription = await push.subscribe(
          null, //subscribes to signined-in user's topic, users/<uid>
          (message) async {
            log('[push] message on ${message.topic}');
            final Map<String, dynamic> envelope;
            try {
              envelope = (jsonDecode(message.data) as Map)
                  .cast<String, dynamic>();
            } catch (e) {
              log('[push] DROPPED, payload is not a JSON object: $e');
              return;
            }
            // Appwrite publishes an envelope, not the bare payload:
            // {messageId, notification: {title, body}, data: {...}, priority}.
            final data =
                (envelope['data'] as Map?)?.cast<String, dynamic>() ?? envelope;
            final notification = (envelope['notification'] as Map?)
                ?.cast<String, dynamic>();

            if (data['type'] == 'incoming_call') {
              log('[push] incoming call');
              if (!isTestMode) {
                await ref.read(callKitServiceProvider).showIncomingCall(data);
              }
              return;
            }

            final title =
                notification?['title'] as String? ?? data['title'] as String?;
            final body =
                notification?['body'] as String? ?? data['body'] as String?;
            if (title == null && body == null) {
              log('[push] DROPPED, payload carries no title or body');
              return;
            }

            String? payload;
            if (body != null) {
              final match = RegExp(
                r'The room (\w+) will Start Soon',
              ).firstMatch(body);
              payload = match?.group(1);
            }
            await notifications.show(
              title: title ?? '',
              body: body ?? '',
              payload: payload,
            );
          },
          background: true,
          title: 'Resonate',
        );
        // An incoming call has to ring the moment it arrives
        if (!isTestMode) {
          await push.setForeground(true);
        }

        log('[push] subscribed as $uid (SUBACK received)');
        pushSubscription = subscription;
      } catch (e, st) {
        // Push is degraded; the rest of the app is not.
        log('[push] subscribe FAILED, continuing without push: $e');
        developer.log('push subscribe failed', error: e, stackTrace: st);
        subscribedUid = null;
      }
    }

    ref.listen<AuthUser?>(
      currentUserProvider,
      (_, next) => unawaited(syncPush(next?.uid)),
      fireImmediately: true,
    );
    ref.onDispose(() => pushSubscription?.unsubscribe());

    if (!isTestMode) {
      final callKit = ref.read(callKitServiceProvider)
        ..start(
          onAccept: (extra) => ref
              .read(friendCallCoordinatorProvider.notifier)
              .onAnswerCall(extra),
          onDecline: (extra) => ref
              .read(friendCallCoordinatorProvider.notifier)
              .onDeclinedCall(extra),
        );
      ref.onDispose(callKit.stop);

      Future<void> openFromPush(PushNotificationOpened opened) async {
        if (opened.data['type'] != 'incoming_call') return;
        await ref.read(callKitServiceProvider).showIncomingCall(opened.data);
      }
      ref.onDispose(
        push.onNotificationOpened((opened) => unawaited(openFromPush(opened))),
      );
      // The tap that launched the app is reported here instead
      final launchTap = await push.getInitialNotification();
      if (launchTap != null) await openFromPush(launchTap);
    }
  }

  void _openUpcomingRoom(String roomName) {
    ref.read(tabViewProvider.notifier).setIndex(1);
    ref.read(routerProvider).go(RoutePaths.tabview);
  }
}
