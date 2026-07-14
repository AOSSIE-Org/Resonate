import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/rooms/data/services/audio_device_service.dart';
import 'package:resonate/features/rooms/model/audio_device_state.dart';
import 'package:resonate/features/rooms/view/widgets/audio_selector_dialog.dart';
import 'package:resonate/features/rooms/viewmodel/audio_device_notifier.dart';
import 'package:resonate/features/rooms/model/audio_device.dart';
import 'package:resonate/utils/enums/audio_device_enum.dart';

import '../rooms_test_helpers.dart';

// Builds an AudioDevice; label drives displayName + iconName via the enum.
AudioDevice fakeAudioDevice({
  String deviceId = 'd-1',
  String label = 'Loudspeaker',
}) {
  return AudioDevice(
    deviceId: deviceId,
    label: label,
    kind: 'audiooutput',
    groupId: 'g-1',
    deviceType: AudioDeviceType.fromLabel(label),
  );
}

// Fake notifier whose build() throws so the dialog renders its error branch.
class FakeErrorAudioDevice extends AudioDeviceNotifier {
  FakeErrorAudioDevice(this._message);
  final String _message;

  @override
  Future<AudioDeviceState> build() async => throw _message;
}

// Pumps the dialog with the given audio-device notifier override.
Future<void> pumpDialog(
  WidgetTester tester, {
  required AudioDeviceNotifier notifier,
}) {
  return pumpRoomsPage(
    tester,
    const AudioDeviceSelectorDialog(),
    overrides: [
      audioDeviceProvider.overrideWith(() => notifier),
      audioDeviceServiceProvider.overrideWithValue(AudioDeviceService()),
    ],
  );
}

void main() {
  group('AudioDeviceSelectorDialog state rendering', () {
    testWidgets('loading shows a CircularProgressIndicator', (tester) async {
      final completer = Completer<AudioDeviceState>();
      await pumpDialog(tester, notifier: FakeAudioDevice(completer.future));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(const AudioDeviceState());
      await tester.pumpAndSettle();
    });

    testWidgets('error renders the error text', (tester) async {
      await pumpDialog(
        tester,
        notifier: FakeErrorAudioDevice('boom'),
      );
      await tester.pumpAndSettle();

      expect(find.text('boom'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('empty data shows the no-devices message', (tester) async {
      await pumpDialog(
        tester,
        notifier: FakeAudioDevice(Future.value(const AudioDeviceState())),
      );
      await tester.pumpAndSettle();

      expect(find.text('No audio output devices detected'), findsOneWidget);
    });

    testWidgets('data renders one item per device', (tester) async {
      final devices = [
        fakeAudioDevice(deviceId: 'd-1', label: 'Loudspeaker'),
        fakeAudioDevice(deviceId: 'd-2', label: 'Bluetooth Buds'),
      ];
      await pumpDialog(
        tester,
        notifier: FakeAudioDevice(
          Future.value(
            AudioDeviceState(devices: devices, selected: devices.first),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Two cards, one per device.
      expect(find.byType(Card), findsNWidgets(2));
      // Bluetooth keeps its raw label; speaker maps to enum display name.
      expect(find.text('Bluetooth Buds'), findsOneWidget);
      expect(find.text('Loudspeaker'), findsOneWidget);
    });
  });

  group('selected device indicator', () {
    testWidgets('the selected device shows a check_circle', (tester) async {
      final devices = [
        fakeAudioDevice(deviceId: 'd-1', label: 'Loudspeaker'),
        fakeAudioDevice(deviceId: 'd-2', label: 'Bluetooth Buds'),
      ];
      await pumpDialog(
        tester,
        notifier: FakeAudioDevice(
          Future.value(
            AudioDeviceState(devices: devices, selected: devices[1]),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Exactly one selected -> one check_circle.
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });
  });

  group('deviceType -> icon mapping', () {
    Future<void> pumpSingle(WidgetTester tester, String label) async {
      final device = fakeAudioDevice(label: label);
      await pumpDialog(
        tester,
        notifier: FakeAudioDevice(
          Future.value(AudioDeviceState(devices: [device], selected: null)),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('bluetooth label -> bluetooth_audio icon', (tester) async {
      await pumpSingle(tester, 'Bluetooth Headphones');
      expect(find.byIcon(Icons.bluetooth_audio), findsOneWidget);
    });

    testWidgets('earpiece label -> phone icon', (tester) async {
      await pumpSingle(tester, 'Phone Earpiece');
      expect(find.byIcon(Icons.phone), findsOneWidget);
    });

    testWidgets('wired headset label -> headset icon', (tester) async {
      await pumpSingle(tester, 'Wired Headset');
      expect(find.byIcon(Icons.headset), findsOneWidget);
    });

    testWidgets('speaker label -> speaker icon', (tester) async {
      await pumpSingle(tester, 'Loudspeaker');
      expect(find.byIcon(Icons.speaker), findsOneWidget);
    });

    testWidgets('unknown label -> default volume_up icon', (tester) async {
      await pumpSingle(tester, 'Some Random Device');
      expect(find.byIcon(Icons.volume_up), findsOneWidget);
    });
  });

  group('interactions', () {
    testWidgets('tapping a device calls selectOutput with it', (tester) async {
      final devices = [
        fakeAudioDevice(deviceId: 'd-1', label: 'Loudspeaker'),
        fakeAudioDevice(deviceId: 'd-2', label: 'Bluetooth Buds'),
      ];
      final notifier = FakeAudioDevice(
        Future.value(
          AudioDeviceState(devices: devices, selected: devices.first),
        ),
      );
      await pumpDialog(tester, notifier: notifier);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Bluetooth Buds'));
      await tester.pumpAndSettle();

      expect(notifier.selected, [devices[1]]);
    });

    testWidgets('Refresh rebuilds the provider', (tester) async {
      // A first build that resolves empty, then a rebuild that yields a device.
      var buildCount = 0;
      final notifier = _RefreshRecordingNotifier(() {
        buildCount++;
        return Future.value(
          buildCount == 1
              ? const AudioDeviceState()
              : AudioDeviceState(devices: [fakeAudioDevice()]),
        );
      });
      await pumpRoomsPage(
        tester,
        const AudioDeviceSelectorDialog(),
        overrides: [
          audioDeviceProvider.overrideWith(() => notifier),
          audioDeviceServiceProvider.overrideWithValue(AudioDeviceService()),
        ],
      );
      await tester.pumpAndSettle();
      expect(buildCount, 1);
      expect(find.byType(Card), findsNothing);

      await tester.tap(find.text('Refresh'));
      await tester.pumpAndSettle();

      // Invalidate re-ran build() and the new device rendered.
      expect(buildCount, greaterThan(1));
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('Done pops the dialog', (tester) async {
      await _pumpInNavigator(tester);
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.byType(AudioDeviceSelectorDialog), findsOneWidget);

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      expect(find.byType(AudioDeviceSelectorDialog), findsNothing);
    });

    testWidgets('close icon pops the dialog', (tester) async {
      await _pumpInNavigator(tester);
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.byType(AudioDeviceSelectorDialog), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.byType(AudioDeviceSelectorDialog), findsNothing);
    });
  });
}

// Notifier whose build() future is produced by a factory (so invalidate reruns).
class _RefreshRecordingNotifier extends AudioDeviceNotifier {
  _RefreshRecordingNotifier(this._factory);
  final Future<AudioDeviceState> Function() _factory;

  @override
  Future<AudioDeviceState> build() => _factory();
}

// Pushes the dialog via a button so a Navigator is present for pop() tests.
Future<void> _pumpInNavigator(WidgetTester tester) {
  return pumpRoomsPage(
    tester,
    Builder(
      builder: (context) => ElevatedButton(
        onPressed: () => showAudioDeviceSelector(context),
        child: const Text('Open'),
      ),
    ),
    overrides: [
      audioDeviceProvider.overrideWith(
        () => FakeAudioDevice(Future.value(const AudioDeviceState())),
      ),
      audioDeviceServiceProvider.overrideWithValue(AudioDeviceService()),
    ],
  );
}
