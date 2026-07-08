import 'dart:async';

import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

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
}
