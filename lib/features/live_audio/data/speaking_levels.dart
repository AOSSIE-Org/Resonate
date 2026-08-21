import 'dart:async';

import 'package:resonate/features/live_audio/data/services/livekit_controller.dart';
import 'package:resonate/features/live_audio/data/speaking_throttle.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/speaking_levels.g.dart';


const double kSpeakingLevelThreshold = 0.05;
const double _levelStep = 0.02;

@Riverpod(keepAlive: true)
class SpeakingLevels extends _$SpeakingLevels {
  StreamSubscription<Map<String, double>>? _sub;

  late final _throttle = LeadingEdgeThrottle<Map<String, double>>(
    interval: kSpeakingSampleInterval,
    publish: (next) {
      if (ref.mounted && !_sameLevels(state, next)) state = next;
    },
  );

  @override
  Map<String, double> build() {
    final liveKit = ref.watch(liveKitControllerProvider.notifier);
    _sub = liveKit.speakerLevels.listen(_onSample);
    ref.onDispose(() {
      _sub?.cancel();
      _throttle.cancel();
    });
    return const {};
  }

  void _onSample(Map<String, double> raw) {
    _throttle.submit({
      for (final entry in raw.entries)
        if (entry.value >= kSpeakingLevelThreshold)
          entry.key: (entry.value / _levelStep).round() * _levelStep,
    });
  }

  bool _sameLevels(Map<String, double> a, Map<String, double> b) {
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      if (b[entry.key] != entry.value) return false;
    }
    return true;
  }
}

@riverpod
double speakingLevel(Ref ref, String uid) =>
    ref.watch(speakingLevelsProvider)[uid] ?? 0;
    