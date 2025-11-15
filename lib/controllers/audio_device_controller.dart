import 'dart:async';
import 'dart:developer';

import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:get/get.dart';
import 'package:resonate/models/audio_device.dart';

class AudioDeviceController extends GetxController {
  final RxList<AudioDevice> audioOutputDevices = <AudioDevice>[].obs;
  final Rx<AudioDevice?> selectedAudioOutput = Rx<AudioDevice?>(null);

  Timer? _deviceEnumerationTimer;

  @override
  void onInit() {
    super.onInit();
    enumerateDevices();
    _deviceEnumerationTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => enumerateDevices(),
    );
  }

  @override
  void onClose() {
    _deviceEnumerationTimer?.cancel();
    super.onClose();
  }

  Future<void> enumerateDevices() async {
    try {
      final devices = await webrtc.navigator.mediaDevices.enumerateDevices();
      final outputs = devices
          .map((device) => AudioDevice.fromMediaDeviceInfo(device))
          .where((d) => d.isAudioOutput)
          .toList();
      audioOutputDevices.value = outputs;
      selectedAudioOutput.value ??= outputs.firstOrNull;
      log('Enumerated ${outputs.length} output devices');
    } catch (e) {
      log('Error enumerating devices: $e');
    }
  }

  Future<void> selectAudioOutput(AudioDevice device) async {
    try {
      selectedAudioOutput.value = device;
      await webrtc.Helper.selectAudioOutput(device.deviceId);
      log('Selected audio output: ${device.label}');
    } catch (e) {
      log('Error selecting audio output: $e');
    }
  }

  String getDeviceName(AudioDevice device) {
    final label = device.label.toLowerCase();
    if (label.contains('earpiece') || label.contains('receiver')) {
      return 'Phone Earpiece';
    } else if (label.contains('speaker')) {
      return 'Loudspeaker';
    } else if (label.contains('bluetooth')) {
      return 'Bluetooth ${device.label}';
    } else if (label.contains('wired') ||
        label.contains('headset') ||
        label.contains('headphone')) {
      return 'Wired Headset';
    } else if (label.contains('usb')) {
      return 'USB Audio';
    }
    return device.label.isNotEmpty ? device.label : 'Unknown Device';
  }

  String getDeviceIcon(AudioDevice device) {
    final label = device.label.toLowerCase();
    if (label.contains('earpiece') || label.contains('receiver')) {
      return 'phone';
    } else if (label.contains('bluetooth')) {
      return 'bluetooth_audio';
    } else if (label.contains('headset') || label.contains('headphone')) {
      return 'headset';
    } else if (label.contains('speaker')) {
      return 'speaker';
    }
    return 'volume_up';
  }

  Future<void> refreshDevices() async {
    await enumerateDevices();
  }
}
