import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/live_audio/model/audio_device_state.dart';
import 'package:resonate/features/live_audio/view/widgets/audio_selector_dialog.dart';
import 'package:resonate/features/live_audio/viewmodel/audio_device_notifier.dart';

import '../live_audio_test_helpers.dart';

Future<void> _pumpDialog(
  WidgetTester tester, {
  required FakeAudioDevice notifier,
}) {
  return pumpTestApp(
    tester,
    const AudioDeviceSelectorDialog(),
    overrides: [
      audioDeviceProvider.overrideWith(() => notifier),
      audioDeviceServiceProvider.overrideWithValue(FakeAudioDeviceService()),
    ],
  );
}

Finder _tile(AudioOutputRoute route) =>
    find.byKey(ValueKey('audio-route-${route.name}'));

void main() {
  group('rendering', () {
    testWidgets('offers exactly the loudspeaker and the earpiece', (
      tester,
    ) async {
      await _pumpDialog(
        tester,
        notifier: FakeAudioDevice(const AudioDeviceState()),
      );

      expect(_tile(AudioOutputRoute.speaker), findsOneWidget);
      expect(_tile(AudioOutputRoute.earpiece), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(2));
    });

    testWidgets('notes that a headset overrides the choice', (tester) async {
      await _pumpDialog(
        tester,
        notifier: FakeAudioDevice(const AudioDeviceState()),
      );

      expect(
        find.textContaining('headset', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('a platform that cannot switch offers no routes at all', (
      tester,
    ) async {
      await _pumpDialog(
        tester,
        notifier: FakeAudioDevice(const AudioDeviceState(canSwitch: false)),
      );

      expect(find.byType(ListTile), findsNothing);
      expect(_tile(AudioOutputRoute.speaker), findsNothing);
    });
  });

  group('the selected route', () {
    testWidgets('the speaker carries the check when it is active', (
      tester,
    ) async {
      await _pumpDialog(
        tester,
        notifier: FakeAudioDevice(
          const AudioDeviceState(route: AudioOutputRoute.speaker),
        ),
      );

      final tile = tester.widget<ListTile>(_tile(AudioOutputRoute.speaker));
      expect(tile.trailing, isA<Icon>());
      final other = tester.widget<ListTile>(_tile(AudioOutputRoute.earpiece));
      expect(other.trailing, isNull);
    });

    testWidgets('the earpiece carries it when that is active instead', (
      tester,
    ) async {
      await _pumpDialog(
        tester,
        notifier: FakeAudioDevice(
          const AudioDeviceState(route: AudioOutputRoute.earpiece),
        ),
      );

      final tile = tester.widget<ListTile>(_tile(AudioOutputRoute.earpiece));
      expect(tile.trailing, isA<Icon>());
    });
  });

  group('interactions', () {
    testWidgets('tapping the earpiece asks for that route', (tester) async {
      final notifier = FakeAudioDevice(
        const AudioDeviceState(route: AudioOutputRoute.speaker),
      );
      await _pumpDialog(tester, notifier: notifier);

      await tester.tap(_tile(AudioOutputRoute.earpiece));
      await tester.pumpAndSettle();

      expect(notifier.selected, [AudioOutputRoute.earpiece]);
    });

    testWidgets('Done pops the sheet', (tester) async {
      await _pumpDialog(
        tester,
        notifier: FakeAudioDevice(const AudioDeviceState()),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(AudioDeviceSelectorDialog), findsNothing);
    });

    testWidgets('the close icon pops it too', (tester) async {
      await _pumpDialog(
        tester,
        notifier: FakeAudioDevice(const AudioDeviceState()),
      );

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.byType(AudioDeviceSelectorDialog), findsNothing);
    });
  });
}
