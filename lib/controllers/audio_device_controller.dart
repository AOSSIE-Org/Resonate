import 'dart:async';
import 'dart:developer';

import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:get/get.dart';
import 'package:resonate/models/audio_device.dart';

class AudioDeviceController extends GetxController {
  final RxList<AudioDevice> audioInputDevices = <AudioDevice>[].obs;
  final RxList<AudioDevice> audioOutputDevices = <AudioDevice>[].obs;
  final Rx<AudioDevice?> selectedAudioInput = Rx<AudioDevice?>(null);
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
      final audioDevices = devices
          .map((device) => AudioDevice.fromMediaDeviceInfo(device))
          .toList();

      final inputs = audioDevices.where((d) => d.isAudioInput).toList();
      final outputs = audioDevices.where((d) => d.isAudioOutput).toList();

      audioInputDevices.value = inputs;
      audioOutputDevices.value = outputs;
      if (selectedAudioInput.value == null && inputs.isNotEmpty) {
        selectedAudioInput.value = inputs.first;
        log('Default audio input device: ${inputs.first.label}');
      }
      if (selectedAudioOutput.value == null && outputs.isNotEmpty) {
        selectedAudioOutput.value = outputs.first;
        log('Default audio output device: ${outputs.first.label}');
      }
      log(
        'Enumerated ${inputs.length} input and ${outputs.length} output devices',
      );
    } catch (e) {
      log('Error enumerating devices: $e');
    }
  }

  Future<void> selectAudioOutput(AudioDevice device) async {
    try {
      selectedAudioOutput.value = device;
      await webrtc.Helper.selectAudioOutput(device.deviceId);
      await _autoSelectInputDevice(device);
      log('Selected audio output: ${device.label}');
    } catch (e) {
      log('Error selecting audio output: $e');
    }
  }

  Future<void> _autoSelectInputDevice(AudioDevice outputDevice) async {
    try {
      AudioDevice? inputDevice;
      if (outputDevice.groupId.isNotEmpty) {
        inputDevice = audioInputDevices.firstWhereOrNull(
          (input) => input.groupId == outputDevice.groupId,
        );
      }
      if (inputDevice == null) {
        final outputLabel = outputDevice.label.toLowerCase();
        if (outputLabel.contains('bluetooth')) {
          inputDevice = audioInputDevices.firstWhereOrNull(
            (input) => input.label.toLowerCase().contains('bluetooth'),
          );
        } else if (outputLabel.contains('headset') ||
            outputLabel.contains('headphone')) {
          inputDevice = audioInputDevices.firstWhereOrNull(
            (input) =>
                input.label.toLowerCase().contains('headset') ||
                input.label.toLowerCase().contains('headphone'),
          );
        } else if (outputLabel.contains('usb')) {
          inputDevice = audioInputDevices.firstWhereOrNull(
            (input) => input.label.toLowerCase().contains('usb'),
          );
        }
      }
      inputDevice ??= audioInputDevices.firstWhereOrNull(
        (input) =>
            input.label.toLowerCase().contains('built-in') ||
            input.label.toLowerCase().contains('internal') ||
            input.label.toLowerCase().contains('phone') ||
            input.label.toLowerCase().contains('default'),
      );
      inputDevice ??= audioInputDevices.firstOrNull;
      if (inputDevice != null) {
        selectedAudioInput.value = inputDevice;
        await webrtc.Helper.selectAudioInput(inputDevice.deviceId);
        log(
          'Auto-selected input device: ${inputDevice.label} for output: ${outputDevice.label}',
        );
      } else {
        log('Warning: No input device found to pair with output device');
      }
    } catch (e) {
      log('Error auto-selecting input device: $e');
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
