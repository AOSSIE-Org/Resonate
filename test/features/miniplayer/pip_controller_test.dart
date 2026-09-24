import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/miniplayer/data/services/pip_controller.dart';

// The plugin's own channel; the controller is only a thin, guarded wrapper.
const _channel = MethodChannel('puntito.simple_pip_mode');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<MethodCall> calls;

  void stubPlugin({required bool autoEnter, bool available = true}) {
    calls = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (call) async {
          calls.add(call);
          return switch (call.method) {
            'isAutoPipAvailable' => autoEnter,
            'isPipAvailable' => available,
            _ => true,
          };
        });
  }

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
  });

  ProviderContainer container() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  test(
    'Android 12+ is armed for auto-enter and never asked directly',
    () async {
      stubPlugin(autoEnter: true);
      final pip = container().read(pipModeProvider.notifier);

      await pip.setSessionActive(active: true);
      expect(calls.map((c) => c.method), contains('setAutoPipMode'));

      // Entering while the system is already moving the task into PiP crashes
      // SystemUI's shell, so this must be a no-op here.
      calls.clear();
      await pip.enterNow();
      expect(calls.map((c) => c.method), isNot(contains('enterPipMode')));
    },
  );

  test('older releases enter on request, and are not armed', () async {
    stubPlugin(autoEnter: false);
    final pip = container().read(pipModeProvider.notifier);

    await pip.setSessionActive(active: true);
    expect(calls.map((c) => c.method), isNot(contains('setAutoPipMode')));

    await pip.enterNow();
    expect(calls.map((c) => c.method), contains('enterPipMode'));
  });

  test('a device without PiP at all is left alone', () async {
    stubPlugin(autoEnter: false, available: false);
    final pip = container().read(pipModeProvider.notifier);

    await pip.enterNow();
    expect(calls.map((c) => c.method), isNot(contains('enterPipMode')));
  });

  test('already in PiP: nothing is asked for again', () async {
    stubPlugin(autoEnter: false);
    final c = container();
    final pip = c.read(pipModeProvider.notifier);
    // Simulate the plugin reporting that the window is already up.
    await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage(
          _channel.name,
          _channel.codec.encodeMethodCall(const MethodCall('onPipEntered')),
          (_) {},
        );
    expect(c.read(pipModeProvider), isTrue);

    calls.clear();
    await pip.enterNow();
    expect(calls, isEmpty);
  });
}
