import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/friend_calling_controller.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/core/providers/firebase_providers.dart';
import 'package:resonate/features/auth/data/callkit_service.dart';
import 'package:resonate/features/auth/data/notification_service.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/app_bootstrap_notifier.g.dart';

// Boots app-wide services that need to be initialized after auth state is known.
@Riverpod(keepAlive: true)
class AppBootstrap extends _$AppBootstrap {
  @override
  Future<void> build() async {
    final messaging = ref.watch(firebaseMessagingProvider);

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (!Get.testMode) {
      await FlutterCallkitIncoming.canUseFullScreenIntent();
      await FlutterCallkitIncoming.requestFullIntentPermission();
    }

    final notifications = NotificationService(
      onTapPayload: _openUpcomingRoom,
    );
    await notifications.initialize();

    final fcmSub = FirebaseMessaging.onMessage.listen((message) async {
      log('Got a message whilst in the foreground!');
      if (message.data['type'] == 'incoming_call') {
        log('saw incoming call');
        await FriendCallingController.onCallRecieved(message);
        return;
      }
      final notification = message.notification;
      if (notification == null) return;

      final body = notification.body;
      String? payload;
      if (body != null) {
        final match = RegExp(r'The room (\w+) will Start Soon').firstMatch(body);
        payload = match?.group(1);
      }
      await notifications.show(
        title: notification.title ?? '',
        body: body ?? '',
        payload: payload,
      );
    });
    ref.onDispose(fcmSub.cancel);

    if (!Get.testMode) {
      final friendCalling = Get.put(
        FriendCallingController(),
        permanent: true,
      );
      final callKit = CallKitService()
        ..start(
          onAccept: friendCalling.onAnswerCall,
          onDecline: friendCalling.onDeclinedCall,
        );
      ref.onDispose(callKit.stop);
    }
  }

  void _openUpcomingRoom(String roomName) {
    Get.find<TabViewController>().setIndex(1);
    appRouter.go(RoutePaths.tabview);
  }
}
