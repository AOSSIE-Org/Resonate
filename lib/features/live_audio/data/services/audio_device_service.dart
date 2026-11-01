import 'dart:developer';

import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:resonate/features/live_audio/model/audio_device.dart';
import 'package:resonate/utils/enums/audio_device_enum.dart';

class AudioDeviceService {
  Future<List<AudioDevice>> enumerateOutputDevices() async {
    final devices = await webrtc.navigator.mediaDevices.enumerateDevices();
    return devices
        .map((device) => AudioDevice.fromMediaDeviceInfo(device))
        .where((d) => d.isAudioOutput)
        .toList();
  }

  Future<bool> selectOutput(AudioDevice device) async {
    try {
      await webrtc.Helper.selectAudioOutput(device.deviceId);
      return true;
    } catch (e) {
      log('Error selecting audio output: $e');
      return false;
    }
  }

  String displayNameFor(AudioDevice device) {
    final deviceType = device.deviceType;
    if (deviceType == AudioDeviceType.bluetoothAudio) {
      return device.label;
    }
    if (deviceType == AudioDeviceType.unknown && device.label.isNotEmpty) {
      return device.label;
    }
    return device.label.isNotEmpty ? deviceType.displayName : 'Unknown Device';
  }
}
