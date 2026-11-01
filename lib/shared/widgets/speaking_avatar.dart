import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/live_audio/data/speaking_bands.dart';
import 'package:resonate/features/live_audio/data/speaking_levels.dart';
import 'package:resonate/shared/widgets/audio_wave_ring.dart';

class SpeakingAvatar extends ConsumerWidget {
  const SpeakingAvatar({
    super.key,
    required this.uid,
    required this.radius,
    required this.child,
  });

  final String uid;

  final double radius;

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AudioWaveRing(
      level: ref.watch(speakingLevelProvider(uid)),
      bands: ref.watch(speakingBandsProvider(uid)),
      radius: radius,
      child: child,
    );
  }
}
