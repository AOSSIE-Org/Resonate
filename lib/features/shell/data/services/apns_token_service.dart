import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

// The device's APNs token, from the channel AppDelegate installs.
class ApnsTokenService {
  static const MethodChannel _channel = MethodChannel('resonate/apns');

  // Registers for remote notifications and resolves the token
  Future<String?> token({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    if (!Platform.isIOS) return null;

    final completer = Completer<String?>();
    _channel.setMethodCallHandler((call) async {
      if (completer.isCompleted) return null;
      switch (call.method) {
        case 'onToken':
          completer.complete(call.arguments as String?);
        case 'onError':
          completer.complete(null);
      }
      return null;
    });

    try {
      // Returns a token registered earlier in the launch, else null and the
      // handler above resolves it.
      final cached = await _channel.invokeMethod<String>('register');
      if (cached != null && cached.isNotEmpty && !completer.isCompleted) {
        completer.complete(cached);
      }
    } on PlatformException {
      if (!completer.isCompleted) completer.complete(null);
    } on MissingPluginException {
      if (!completer.isCompleted) completer.complete(null);
    }

    return completer.future
        .timeout(timeout, onTimeout: () => null)
        .whenComplete(() => _channel.setMethodCallHandler(null));
  }
}
