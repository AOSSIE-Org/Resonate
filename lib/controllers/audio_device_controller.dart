import 'dart:async';
import 'dart:developer';

import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:get/get.dart';
import 'package:resonate/models/audio_device.dart';
import 'package:resonate/utils/enums/audio_device_enum.dart';

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
    final deviceType = AudioDeviceType.fromLabel(device.label);
    log('Device label: "${device.label}" -> type: ${deviceType.name}');

    if (deviceType == AudioDeviceType.bluetoothAudio) {
      return device.label;
    } else if (deviceType == AudioDeviceType.unknown &&
        device.label.isNotEmpty) {
      return device.label;
    }
    return device.label.isNotEmpty ? deviceType.displayName : 'Unknown Device';
  }

  Future<void> refreshDevices() async {
    await enumerateDevices();
  }
}
