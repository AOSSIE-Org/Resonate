import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/live_audio/data/services/audio_device_service.dart';
import 'package:resonate/features/live_audio/model/audio_device.dart';
import 'package:resonate/features/live_audio/viewmodel/audio_device_notifier.dart';
import 'package:resonate/utils/enums/audio_device_enum.dart';

AudioDevice device(String id, {String? label}) => AudioDevice(
  deviceId: id,
  label: label ?? id,
  kind: 'audiooutput',
  groupId: 'g-$id',
  deviceType: AudioDeviceType.fromLabel(label ?? id),
);

class FakeAudioDeviceService implements AudioDeviceService {
  FakeAudioDeviceService([this.devices = const []]);

  List<AudioDevice> devices;
  Object? enumerateError;
  int enumerateCalls = 0;
  final List<AudioDevice> selected = [];

  @override
  Future<List<AudioDevice>> enumerateOutputDevices() async {
    enumerateCalls++;
    if (enumerateError != null) throw enumerateError!;
    return devices;
  }

  @override
  Future<bool> selectOutput(AudioDevice device) async {
    selected.add(device);
    return true;
  }

  @override
  String displayNameFor(AudioDevice device) => device.label;
}

void main() {
  late FakeAudioDeviceService service;

  setUp(() {
    service = FakeAudioDeviceService();
  });

  ProviderContainer makeContainer({bool disposeOnTearDown = true}) {
    final container = ProviderContainer(
      overrides: [audioDeviceServiceProvider.overrideWithValue(service)],
    );
    if (disposeOnTearDown) addTearDown(container.dispose);
    container.listen(audioDeviceProvider, (_, _) {});
    return container;
  }

  group('build', () {
    test('selects the first device it finds', () async {
      service.devices = [device('earpiece'), device('speaker')];
      final container = makeContainer();

      final state = await container.read(audioDeviceProvider.future);

      expect(state.devices, hasLength(2));
      expect(state.selected, device('earpiece'));
    });

    test('leaves the selection null when there are no devices', () async {
      final container = makeContainer();

      final state = await container.read(audioDeviceProvider.future);

      expect(state.devices, isEmpty);
      expect(state.selected, isNull);
    });
  });

  group('selectOutput', () {
    test('routes to the device and records it as selected', () async {
      service.devices = [device('earpiece'), device('speaker')];
      final container = makeContainer();
      await container.read(audioDeviceProvider.future);

      await container
          .read(audioDeviceProvider.notifier)
          .selectOutput(device('speaker'));

      expect(service.selected, [device('speaker')]);
      expect(
        container.read(audioDeviceProvider).value!.selected,
        device('speaker'),
      );
    });
  });

  // The notifier re-enumerates on a 5s timer so a headset plugged in mid-call
  // shows up without the user reopening the sheet.
  group('periodic refresh', () {
    testWidgets('picks up devices that appear later', (tester) async {
      final container = makeContainer(disposeOnTearDown: false);
      await container.read(audioDeviceProvider.future);
      expect(container.read(audioDeviceProvider).value!.devices, isEmpty);

      service.devices = [device('bluetooth headset')];
      await tester.pump(const Duration(seconds: 5));

      final state = container.read(audioDeviceProvider).value!;
      expect(state.devices, hasLength(1));
      expect(state.selected, device('bluetooth headset'));
      container.dispose();
    });

    // Re-enumerating must not silently reset the user's choice back to the
    // first device in the list.
    testWidgets('keeps the current selection across a refresh', (tester) async {
      service.devices = [device('earpiece'), device('speaker')];
      final container = makeContainer(disposeOnTearDown: false);
      await container.read(audioDeviceProvider.future);
      await container
          .read(audioDeviceProvider.notifier)
          .selectOutput(device('speaker'));

      service.devices = [device('earpiece'), device('speaker'), device('usb')];
      await tester.pump(const Duration(seconds: 5));

      final state = container.read(audioDeviceProvider).value!;
      expect(state.devices, hasLength(3));
      expect(state.selected, device('speaker'));
      container.dispose();
    });

    testWidgets('a failed enumeration leaves the last good state', (
      tester,
    ) async {
      service.devices = [device('earpiece')];
      final container = makeContainer(disposeOnTearDown: false);
      await container.read(audioDeviceProvider.future);

      service.enumerateError = StateError('platform channel down');
      await tester.pump(const Duration(seconds: 5));

      final state = container.read(audioDeviceProvider).value!;
      expect(state.devices, [device('earpiece')]);
      expect(state.selected, device('earpiece'));
      container.dispose();
    });

    testWidgets('disposing stops the timer', (tester) async {
      final container = ProviderContainer(
        overrides: [audioDeviceServiceProvider.overrideWithValue(service)],
      );
      container.listen(audioDeviceProvider, (_, _) {});
      await container.read(audioDeviceProvider.future);
      expect(service.enumerateCalls, 1);

      container.dispose();
      await tester.pump(const Duration(seconds: 15));

      expect(service.enumerateCalls, 1);
    });
  });
}
