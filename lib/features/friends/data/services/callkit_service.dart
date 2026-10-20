import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' show Color;
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:resonate/features/theme/viewmodel/theme_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/callkit_service.g.dart';

@Riverpod(keepAlive: true)
CallKitService callKitService(Ref ref) => CallKitService();

AndroidParams resonateCallAndroidParams() {
  final theme = storedThemeModel();
  return AndroidParams(
    isShowFullLockedScreen: true,
    backgroundColor: _hex(theme.surfaceColor),
    actionColor: _hex(theme.primaryColor),
    textColor: _hex(theme.onSurfaceColor),
  );
}

// Plugin to parse these 
String _hex(Color color) {
  String channel(double value) =>
      (value * 255).round().toRadixString(16).padLeft(2, '0');
  return '#${channel(color.r)}${channel(color.g)}${channel(color.b)}';
}

// Wraps the FlutterCallkitIncoming statics so callers stay testable.
class CallKitService {
  StreamSubscription<CallEvent?>? _sub;

  void start({
    required Future<void> Function(Map<String, dynamic> extra) onAccept,
    required Future<void> Function(Map<String, dynamic> extra) onDecline,
  }) {
    _sub?.cancel();
    _sub = FlutterCallkitIncoming.onEvent.listen((event) async {
      if (event == null) return;
      final extra = Map<String, dynamic>.from(event.body['extra'] as Map);
      switch (event.event) {
        case Event.actionCallAccept:
          await onAccept(extra);
        case Event.actionCallDecline:
          await onDecline(extra);
          await FlutterCallkitIncoming.showMissCallNotification(
            CallKitParams(),
          );
        default:
          break;
      }
    });
  }

  Future<void> stop() async {
    await _sub?.cancel();
    _sub = null;
  }

  // Presents the native incoming-call UI for an `incoming_call` FCM message.
  Future<void> showIncomingCall(RemoteMessage message) async {
    final params = CallKitParams(
      id: message.data['call_id'],
      nameCaller: message.data['caller_name'],
      avatar: message.data['caller_profile_image_url'],
      handle: message.data['caller_username'],
      type: 0, // 0 = audio, 1 = video
      duration: 30000, // ringing timeout
      extra: {
        "docData": jsonDecode(message.data['extra']),
        "livekit_room_id": message.data['livekit_room_id'],
        "call_id": message.data['call_id'],
      },
      appName: "Resonate",
      android: resonateCallAndroidParams(),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  Future<void> endAllCalls() async {
    await FlutterCallkitIncoming.endAllCalls();
  }
}
