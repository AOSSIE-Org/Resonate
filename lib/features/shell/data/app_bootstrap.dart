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
        );
        // Foreground mode is deliberately OFF. It keeps the connection open in
        // a service, and Android requires every foreground service to show a
        // permanent notification, which is not something to leave in a user's
        // shade for the life of the install. Background delivery still works
        // without it, on the plugin's scheduled wake-ups.
        //
        // Set explicitly rather than left uncalled: the flag is PERSISTED, so
        // an install that once enabled it keeps resuming the service on every
        // launch. Writing false is what clears it.
        //
        // The cost is that a message arriving while the app is closed waits for
        // the next wake-up (15s, 60s privileged) instead of a live socket, and
        // Doze throttles those `setAndAllowWhileIdle` alarms further, so an
        // incoming call can miss CallKit's 30s ring window. That was the reason
        // foreground mode was on.
        //
        // To turn it back on, pass true here: `NotificationService` already
        // pins the plugin's `appwrite-push-service` channel to minimum
        // importance, so the service notification carries no status-bar icon
        // and collapses to the bottom of the shade. The open question is
        // whether the battery-optimisation exemption makes the wake-up path
        // punctual enough on its own; if it does, leave this off.
        if (!isTestMode) {
          await push.setForeground(false);
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
        final type = opened.data['type'];
        log('[push] notification tapped, type=$type');
        if (type != 'incoming_call') return;
        try {
          await ref.read(callKitServiceProvider).showIncomingCall(opened.data);
          log('[push] re-presented the incoming call from a tap');
        } catch (e, st) {
          log('[push] could not re-present the tapped call: $e');
          developer.log('showIncomingCall failed', error: e, stackTrace: st);
        }
      }

      ref.onDispose(
        push.onNotificationOpened((opened) => unawaited(openFromPush(opened))),
      );
      // The tap that launched the app is reported here instead
      final launchTap = await push.getInitialNotification();
      log('[push] launch tap: ${launchTap == null ? 'none' : launchTap.topic}');
      if (launchTap != null) await openFromPush(launchTap);
      final status = await push.backgroundStatus();
      if (status != null) {
        log(
          '[push] background delivery: bestEffort=${status.bestEffort} '
          'batteryExempt=${status.ignoringBatteryOptimizations} '
          'restricted=${status.backgroundRestricted} '
          'exactAlarms=${status.exactAlarms} '
          'foregroundService=${status.foregroundService}',
        );
      }
    }
  }

  void _openUpcomingRoom(String roomName) {
    ref.read(tabViewProvider.notifier).setIndex(1);
    ref.read(routerProvider).go(RoutePaths.tabview);
  }
}
