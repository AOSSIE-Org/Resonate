import 'dart:async';

import 'package:resonate/features/live_audio/data/services/audio_band_tracker.dart';
import 'package:resonate/features/live_audio/data/services/livekit_controller.dart';
import 'package:resonate/features/live_audio/data/speaking_throttle.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/speaking_bands.g.dart';

@Riverpod(keepAlive: true)
class SpeakingSpectrum extends _$SpeakingSpectrum {
  StreamSubscription<SpeakerBands>? _sub;

  late final _throttle = LeadingEdgeThrottle<Map<String, List<double>>>(
    interval: kSpeakingSampleInterval,
    publish: (next) {
      if (ref.mounted && !_sameBands(state, next)) state = next;
    },
  );

  @override
  Map<String, List<double>> build() {
    final liveKit = ref.watch(liveKitControllerProvider.notifier);
    _sub = liveKit.speakerBands.listen(_onBands);
    ref.onDispose(() {
      _sub?.cancel();
      _throttle.cancel();
    });
    return const {};
  }

  void _onBands(SpeakerBands event) {
    final next = _throttle.pending ?? Map<String, List<double>>.of(state);
    if (event.bands.isEmpty) {
      next.remove(event.uid);
    } else {
      next[event.uid] = event.bands;
    }
    _throttle.submit(next);
  }

  bool _sameBands(Map<String, List<double>> a, Map<String, List<double>> b) {
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      if (!identical(b[entry.key], entry.value)) return false;
    }
    return true;
  }
}

@riverpod
List<double> speakingBands(Ref ref, String uid) =>
    ref.watch(speakingSpectrumProvider)[uid] ?? const [];
