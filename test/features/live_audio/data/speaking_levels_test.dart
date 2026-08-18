import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/live_audio/data/services/livekit_controller.dart';
import 'package:resonate/features/live_audio/data/speaking_levels.dart';
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
    // Instantiate so the notifier subscribes to the speaker feed.
    container.read(speakingLevelsProvider);
    return container;
  }


  Future<void> waitInterval() =>
      Future<void>.delayed(kSpeakingSampleInterval * 2);

  group('sampling', () {
    test('starts empty', () {
      final container = buildContainer();
      expect(container.read(speakingLevelsProvider), isEmpty);
    });

    test('publishes the first sample immediately', () async {
      final container = buildContainer();
      liveKit.emitSpeakerLevels({'alice': 0.6});
      await Future<void>.value();

      expect(container.read(speakingLevelsProvider), {'alice': closeTo(0.6, 0.03)});
    });

    test('drops participants below the speaking threshold', () async {
      final container = buildContainer();
      liveKit.emitSpeakerLevels({
        'alice': 0.6,
        'bob': kSpeakingLevelThreshold / 2,
      });
      await Future<void>.value();

      expect(container.read(speakingLevelsProvider).keys, ['alice']);
    });

    test('clears when the room falls silent', () async {
      final container = buildContainer();
      liveKit.emitSpeakerLevels({'alice': 0.6});
      await Future<void>.value();
      await waitInterval();

      liveKit.emitSpeakerLevels(const {});
      await waitInterval();

      expect(container.read(speakingLevelsProvider), isEmpty);
    });
  });

  group('throttling', () {
    test('coalesces bursts into one update per interval', () async {
      final container = buildContainer();
      final published = <Map<String, double>>[];
      container.listen(
        speakingLevelsProvider,
        (_, next) => published.add(next),
        fireImmediately: false,
      );

      liveKit.emitSpeakerLevels({'alice': 0.2});
      await Future<void>.value();
      liveKit.emitSpeakerLevels({'alice': 0.4});
      liveKit.emitSpeakerLevels({'alice': 0.6});
      liveKit.emitSpeakerLevels({'alice': 0.9});
      await waitInterval();

      expect(published.length, 2);
      expect(published.last['alice'], closeTo(0.9, 0.03));
    });

    test('does not republish an unchanged map', () async {
      final container = buildContainer();
      var publishes = 0;
      container.listen(speakingLevelsProvider, (_, _) => publishes++);

      liveKit.emitSpeakerLevels({'alice': 0.6});
      await Future<void>.value();
      await waitInterval();
      liveKit.emitSpeakerLevels({'alice': 0.6});
      await waitInterval();

      expect(publishes, 1);
    });

    test('treats levels within one rounding step as unchanged', () async {
      final container = buildContainer();
      var publishes = 0;
      container.listen(speakingLevelsProvider, (_, _) => publishes++);

      liveKit.emitSpeakerLevels({'alice': 0.60});
      await Future<void>.value();
      await waitInterval();
      liveKit.emitSpeakerLevels({'alice': 0.605});
      await waitInterval();

      expect(publishes, 1);
    });
  });

  group('speakingLevelProvider', () {
    test('reports 0 for a silent uid', () async {
      final container = buildContainer();
      liveKit.emitSpeakerLevels({'alice': 0.6});
      await Future<void>.value();

      expect(container.read(speakingLevelProvider('bob')), 0);
    });

    test('only notifies the uid whose level moved', () async {
      final container = buildContainer();
      var aliceNotifications = 0;
      container.listen(
        speakingLevelProvider('alice'),
        (_, _) => aliceNotifications++,
      );
      container.listen(speakingLevelProvider('bob'), (_, _) {});

      liveKit.emitSpeakerLevels({'alice': 0.6});
      await Future<void>.value();
      await waitInterval();
      // Only bob changes; alice's level is identical, so alice must not rebuild.
      liveKit.emitSpeakerLevels({'alice': 0.6, 'bob': 0.8});
      await waitInterval();

      expect(container.read(speakingLevelProvider('bob')), closeTo(0.8, 0.03));
      expect(aliceNotifications, 1);
    });
  });
}
