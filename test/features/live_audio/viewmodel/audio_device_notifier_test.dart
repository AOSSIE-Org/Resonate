import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/live_audio/model/audio_device_state.dart';
import 'package:resonate/features/live_audio/viewmodel/audio_device_notifier.dart';

import '../live_audio_test_helpers.dart';

ProviderContainer _container(FakeAudioDeviceService service) {
  final container = ProviderContainer(
    overrides: [audioDeviceServiceProvider.overrideWithValue(service)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('build', () {
    test('reports the speaker route when LiveKit prefers the speaker', () {
      final container = _container(FakeAudioDeviceService(speaker: true));
      final state = container.read(audioDeviceProvider);
      expect(state.route, AudioOutputRoute.speaker);
      expect(state.canSwitch, true);
    });

    test('reports the earpiece route when the speaker is not preferred', () {
      final container = _container(FakeAudioDeviceService(speaker: false));
      expect(container.read(audioDeviceProvider).route,
          AudioOutputRoute.earpiece);
    });

    test('carries through that the platform cannot switch output', () {
      final container = _container(
        FakeAudioDeviceService(canSwitchOutput: false),
      );
      expect(container.read(audioDeviceProvider).canSwitch, false);
    });
  });

  group('selectRoute', () {
    test('asks LiveKit for the earpiece and records the route', () async {
      final service = FakeAudioDeviceService(speaker: true);
      final container = _container(service);
      container.read(audioDeviceProvider);

      await container
          .read(audioDeviceProvider.notifier)
          .selectRoute(AudioOutputRoute.earpiece);

      expect(service.setCalls, [false]);
      expect(container.read(audioDeviceProvider).route,
          AudioOutputRoute.earpiece);
    });

    test('asks LiveKit for the speaker coming back the other way', () async {
      final service = FakeAudioDeviceService(speaker: false);
      final container = _container(service);
      container.read(audioDeviceProvider);

      await container
          .read(audioDeviceProvider.notifier)
          .selectRoute(AudioOutputRoute.speaker);

      expect(service.setCalls, [true]);
      expect(container.read(audioDeviceProvider).route,
          AudioOutputRoute.speaker);
    });

    test('selecting the route already in use touches nothing', () async {
      final service = FakeAudioDeviceService(speaker: true);
      final container = _container(service);
      container.read(audioDeviceProvider);

      await container
          .read(audioDeviceProvider.notifier)
          .selectRoute(AudioOutputRoute.speaker);

      expect(service.setCalls, isEmpty);
    });
  });
}
