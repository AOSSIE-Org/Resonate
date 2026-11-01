import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/rooms/data/services/audio_device_service.dart';
import 'package:resonate/features/rooms/model/audio_device.dart';
import 'package:resonate/utils/enums/audio_device_enum.dart';

// Helper to build an AudioDevice with the fields displayNameFor uses.
AudioDevice buildDevice({
  required String label,
  required AudioDeviceType deviceType,
}) {
  return AudioDevice(
    deviceId: 'id',
    label: label,
    kind: 'audiooutput',
    groupId: 'group',
    deviceType: deviceType,
  );
}

void main() {
  late AudioDeviceService service;

  setUp(() {
    service = AudioDeviceService();
  });

  group('AudioDeviceService.displayNameFor', () {
    test('bluetoothAudio returns label verbatim', () {
      final device = buildDevice(
        label: 'My BT Headphones',
        deviceType: AudioDeviceType.bluetoothAudio,
      );
      expect(service.displayNameFor(device), 'My BT Headphones');
    });

    test('bluetoothAudio returns empty label verbatim', () {
      final device = buildDevice(
        label: '',
        deviceType: AudioDeviceType.bluetoothAudio,
      );
      expect(service.displayNameFor(device), '');
    });

    test('unknown type with non-empty label returns label', () {
      final device = buildDevice(
        label: 'Some Device',
        deviceType: AudioDeviceType.unknown,
      );
      expect(service.displayNameFor(device), 'Some Device');
    });

    // Code returns displayName only when label is non-empty (line 34).
    test('known type with non-empty label returns deviceType.displayName', () {
      final device = buildDevice(
        label: 'Speaker A',
        deviceType: AudioDeviceType.headset,
      );
      expect(service.displayNameFor(device), AudioDeviceType.headset.displayName);
    });

    test('known type with empty label returns Unknown Device', () {
      final device = buildDevice(
        label: '',
        deviceType: AudioDeviceType.speaker,
      );
      expect(service.displayNameFor(device), 'Unknown Device');
    });

    test('unknown type with empty label returns Unknown Device', () {
      final device = buildDevice(
        label: '',
        deviceType: AudioDeviceType.unknown,
      );
      expect(service.displayNameFor(device), 'Unknown Device');
    });
  });
}
