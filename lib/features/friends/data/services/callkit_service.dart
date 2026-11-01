import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart' show Color;
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:resonate/features/theme/data/stored_theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/callkit_service.g.dart';

@Riverpod(keepAlive: true)
CallKitService callKitService(Ref ref) => CallKitService();

AndroidParams resonateCallAndroidParams() {
  final theme = storedThemeModel();
  return AndroidParams(
    isShowFullLockedScreen: false,
    isImportant: true,
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

  Future<bool> canUseFullScreen() async =>
      FlutterCallkitIncoming.canUseFullScreenIntent();

  Future<void> requestFullScreenPermission() async {
    await FlutterCallkitIncoming.requestFullIntentPermission();
  }

  static Map<String, dynamic> _extraOf(CallKitParams params) =>
      Map<String, dynamic>.from(params.extra ?? const <String, dynamic>{});

  void start({
    required Future<void> Function(Map<String, dynamic> extra) onAccept,
    required Future<void> Function(Map<String, dynamic> extra) onDecline,
  }) {
    _sub?.cancel();
    _sub = FlutterCallkitIncoming.onEvent.listen((event) async {
      if (event == null) return;
      // 3.1 replaced the `event`/`body` pair with a sealed CallEvent whose
      // subclasses carry a typed CallKitParams, so the payload is read off
      // the matched case rather than an untyped map.
      switch (event) {
        case CallEventActionCallAccept(:final callKitParams):
          await onAccept(_extraOf(callKitParams));
        case CallEventActionCallDecline(:final callKitParams):
          await onDecline(_extraOf(callKitParams));
          await FlutterCallkitIncoming.showMissCallNotification(
            CallKitParams(id: callKitParams.id),
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

  // Presents the native incoming-call UI for an incoming_call push payload.
  Future<void> showIncomingCall(Map<String, dynamic> data) async {
    final params = CallKitParams(
      id: data['call_id'],
      nameCaller: data['caller_name'],
      avatar: data['caller_profile_image_url'],
      handle: data['caller_username'],
      type: 0, // 0 = audio, 1 = video
      duration: 30000, // ringing timeout
      extra: {
        "docData": jsonDecode(data['extra']),
        "livekit_room_id": data['livekit_room_id'],
        "call_id": data['call_id'],
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
