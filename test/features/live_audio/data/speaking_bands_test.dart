import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/live_audio/data/services/livekit_controller.dart';
import 'package:resonate/features/live_audio/data/speaking_bands.dart';
import 'package:resonate/features/live_audio/data/speaking_throttle.dart';

import '../../../helpers/test_root_container.dart';

void main() {
  late FakeLiveKitController liveKit;

  ProviderContainer buildContainer() {
    liveKit = FakeLiveKitController();
    final container = ProviderContainer(
      overrides: [liveKitControllerProvider.overrideWith(() => liveKit)],
    );
    addTearDown(container.dispose);
    container.read(speakingSpectrumProvider);
    return container;
  }

  Future<void> waitInterval() =>
      Future<void>.delayed(kSpeakingSampleInterval * 2);

  test('starts empty', () {
    final container = buildContainer();
    expect(container.read(speakingSpectrumProvider), isEmpty);
  });

  test('publishes a speaker\'s bands', () async {
    final container = buildContainer();
    liveKit.emitSpeakerBands('alice', const [0.1, 0.5, 0.2]);
    await Future<void>.value();

    expect(container.read(speakingBandsProvider('alice')), [0.1, 0.5, 0.2]);
  });

  test('keeps speakers independent', () async {
    final container = buildContainer();
    liveKit.emitSpeakerBands('alice', const [0.1, 0.5, 0.2]);
    liveKit.emitSpeakerBands('bob', const [0.9, 0.9, 0.9]);
    await Future<void>.value();
    await waitInterval();

    expect(container.read(speakingBandsProvider('alice')), [0.1, 0.5, 0.2]);
    expect(container.read(speakingBandsProvider('bob')), [0.9, 0.9, 0.9]);
  });

  test('an empty band list drops that uid', () async {
    final container = buildContainer();
    liveKit.emitSpeakerBands('alice', const [0.1, 0.5, 0.2]);
    await Future<void>.value();
    await waitInterval();

    // What the tracker sends when it detaches a visualizer.
    liveKit.emitSpeakerBands('alice', const []);
    await waitInterval();

    expect(container.read(speakingSpectrumProvider), isEmpty);
    expect(container.read(speakingBandsProvider('alice')), isEmpty);
  });

  test('reports empty for a uid that never had bands', () {
    final container = buildContainer();
    expect(container.read(speakingBandsProvider('nobody')), isEmpty);
  });

  test('coalesces the native FFT firehose into one update per interval',
      () async {
    final container = buildContainer();
    var publishes = 0;
    container.listen(speakingSpectrumProvider, (_, _) => publishes++);

    // The native analyzer emits on every audio frame; this is what that burst
    // looks like arriving between two throttle ticks.
    liveKit.emitSpeakerBands('alice', const [0.1]);
    await Future<void>.value();
    for (var i = 0; i < 20; i++) {
      liveKit.emitSpeakerBands('alice', [i / 20]);
    }
    await waitInterval();

    expect(publishes, 2);
    expect(container.read(speakingBandsProvider('alice')), [19 / 20]);
  });

  test('only notifies the uid whose bands moved', () async {
    final container = buildContainer();
    var aliceNotifications = 0;
    container.listen(
      speakingBandsProvider('alice'),
      (_, _) => aliceNotifications++,
    );

    const aliceBands = [0.1, 0.5, 0.2];
    liveKit.emitSpeakerBands('alice', aliceBands);
    await Future<void>.value();
    await waitInterval();
    liveKit.emitSpeakerBands('bob', const [0.9, 0.9, 0.9]);
    await waitInterval();

    expect(container.read(speakingBandsProvider('bob')), isNotEmpty);
    expect(aliceNotifications, 1);
  });
}
