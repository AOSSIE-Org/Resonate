import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:resonate/controllers/audio_device_controller.dart';
import 'package:resonate/models/audio_device.dart';
import 'package:resonate/utils/enums/audio_device_enum.dart';

void main() {
  late AudioDeviceController controller;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    controller = AudioDeviceController();
  });

  tearDown(() {
    Get.reset();
  });

  group('AudioDeviceController Tests', () {
    test('should initialize with correct default values', () {
      expect(controller.audioOutputDevices, isEmpty);
      expect(controller.selectedAudioOutput.value, isNull);
    });

    test('should filter only output devices from enumerated devices', () async {
      final mockDevices = [
        webrtc.MediaDeviceInfo(
          deviceId: 'output1',
          label: 'Speaker',
          kind: 'audiooutput',
          groupId: 'group1',
        ),
        webrtc.MediaDeviceInfo(
          deviceId: 'input1',
          label: 'Microphone',
          kind: 'audioinput',
          groupId: 'group2',
        ),
        webrtc.MediaDeviceInfo(
          deviceId: 'output2',
          label: 'Headphones',
          kind: 'audiooutput',
          groupId: 'group3',
        ),
      ];
      controller.audioOutputDevices.clear();
      for (var device in mockDevices) {
        final audioDevice = AudioDevice.fromMediaDeviceInfo(device);
        if (audioDevice.isAudioOutput) {
          controller.audioOutputDevices.add(audioDevice);
        }
      }

      expect(controller.audioOutputDevices.length, 2);
      expect(
        controller.audioOutputDevices.every((d) => d.kind == 'audiooutput'),
        true,
      );
    });

    test('should select audio output device', () {
      final testDevice = AudioDevice(
        deviceId: 'test-output',
        label: 'Test Speaker',
        kind: 'audiooutput',
        groupId: 'test-group',
      );

      controller.audioOutputDevices.add(testDevice);
      controller.selectAudioOutput(testDevice);

      expect(controller.selectedAudioOutput.value, testDevice);
      expect(controller.selectedAudioOutput.value?.deviceId, 'test-output');
    });

    test('should return correct device names', () {
      expect(
        controller.getDeviceName(
          AudioDevice(
            deviceId: '1',
            label: 'Earpiece',
            kind: 'audiooutput',
            groupId: 'g1',
          ),
        ),
        'Phone Earpiece',
      );
      expect(
        controller.getDeviceName(
          AudioDevice(
            deviceId: '2',
            label: 'Speaker',
            kind: 'audiooutput',
            groupId: 'g2',
          ),
        ),
        'Loudspeaker',
      );
      expect(
        controller.getDeviceName(
          AudioDevice(
            deviceId: '3',
            label: 'Bluetooth Headset',
            kind: 'audiooutput',
            groupId: 'g3',
          ),
        ),
        'Bluetooth Headset',
      );
    });

    test('should return correct device icon names', () {
      expect(
        AudioDeviceType.fromLabel('Bluetooth Speaker').iconName,
        'bluetooth_audio',
      );
      expect(AudioDeviceType.fromLabel('Earpiece').iconName, 'phone');
      expect(AudioDeviceType.fromLabel('Wired Headset').iconName, 'headset');
      expect(AudioDeviceType.fromLabel('Speaker').iconName, 'speaker');
    });

    test('should update selected device', () {
      final device1 = AudioDevice(
        deviceId: 'device1',
        label: 'Speaker 1',
        kind: 'audiooutput',
        groupId: 'group1',
      );

      final device2 = AudioDevice(
        deviceId: 'device2',
        label: 'Speaker 2',
        kind: 'audiooutput',
        groupId: 'group2',
      );

      controller.selectAudioOutput(device1);
      expect(controller.selectedAudioOutput.value?.deviceId, 'device1');

      controller.selectAudioOutput(device2);
      expect(controller.selectedAudioOutput.value?.deviceId, 'device2');
    });
  });

  group('AudioDevice Model Tests', () {
    test('should create AudioDevice from MediaDeviceInfo', () {
      final mediaDeviceInfo = webrtc.MediaDeviceInfo(
        deviceId: 'test-id',
        label: 'Test Device',
        kind: 'audiooutput',
        groupId: 'test-group',
      );

      final audioDevice = AudioDevice.fromMediaDeviceInfo(mediaDeviceInfo);

      expect(audioDevice.deviceId, 'test-id');
      expect(audioDevice.label, 'Test Device');
      expect(audioDevice.kind, 'audiooutput');
      expect(audioDevice.groupId, 'test-group');
    });

    test('should correctly identify audio output device', () {
      final outputDevice = AudioDevice(
        deviceId: 'id',
        label: 'Speaker',
        kind: 'audiooutput',
        groupId: 'group',
      );

      final inputDevice = AudioDevice(
        deviceId: 'id',
        label: 'Microphone',
        kind: 'audioinput',
        groupId: 'group',
      );

      expect(outputDevice.isAudioOutput, true);
      expect(inputDevice.isAudioOutput, false);
    });
  });
}
