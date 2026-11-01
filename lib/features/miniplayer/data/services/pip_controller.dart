import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_pip_mode/simple_pip.dart';

part 'generated/pip_controller.g.dart';


@Riverpod(keepAlive: true)
class PipMode extends _$PipMode {
  SimplePip? _pip;

  @override
  bool build() {
    if (!_isAndroid) return false;
    _pip = SimplePip(
      onPipEntered: () => _report(inPip: true),
      onPipExited: () => _report(inPip: false),
    );
    return false;
  }

  bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  void _report({required bool inPip}) {
    if (ref.mounted) state = inPip;
  }

  // Whether the system enters PiP by itself Android.
  bool? _autoEnterSupported;

  Future<bool> get _autoEnter async {
    try {
      return _autoEnterSupported ??= await SimplePip.isAutoPipAvailable;
    } catch (e) {
      log('PiP: unavailable: $e');
      return false;
    }
  }

  // Android 12+ 
  Future<void> setSessionActive({required bool active}) async {
    final pip = _pip;
    if (pip == null || !await _autoEnter) return;
    try {
      await pip.setAutoPipMode(aspectRatio: _aspectRatio, autoEnter: active);
    } catch (e) {
      log('PiP: auto mode unavailable: $e');
    }
  }

// for Android 11 and below
  Future<void> enterNow() async {
    final pip = _pip;
    if (pip == null || state) return;
    if (await _autoEnter) return;
    try {
      if (await SimplePip.isPipAvailable) {
        await pip.enterPipMode(aspectRatio: _aspectRatio);
      }
    } catch (e) {
      log('PiP: could not enter: $e');
    }
  }

  // Square shaped pip
  static const _aspectRatio = (1, 1);
}
