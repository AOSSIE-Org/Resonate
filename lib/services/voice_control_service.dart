import 'package:flutter/services.dart';

/// Lightweight signal-only bridge to native audio processing.
/// Flutter sends voice profile selection and preview toggle states;
/// all audio work is performed on the native side.
class VoiceControlService {
  static const _channel = MethodChannel('voice_control_channel');

  /// Sends the selected voice profile name to native code.
  /// [selectedVoice] – identifier of the chosen voice profile.
  static Future<void> setVoiceProfile(String selectedVoice) async {
    await _channel.invokeMethod('setVoiceProfile', {
      'selectedVoice': selectedVoice,
    });
  }

  /// Notifies native code to enable or disable preview playback.
  /// [isPreviewEnabled] – whether preview mode is active.
  static Future<void> setPreviewEnabled(bool isPreviewEnabled) async {
    await _channel.invokeMethod('setPreviewEnabled', {
      'isPreviewEnabled': isPreviewEnabled,
    });
  }
}
