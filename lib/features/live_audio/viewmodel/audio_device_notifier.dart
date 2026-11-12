import 'package:resonate/features/live_audio/data/services/audio_device_service.dart';
import 'package:resonate/features/live_audio/model/audio_device_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/audio_device_notifier.g.dart';

@Riverpod(keepAlive: true)
class AudioDeviceNotifier extends _$AudioDeviceNotifier {
  @override
  AudioDeviceState build() {
    final service = ref.read(audioDeviceServiceProvider);
    return AudioDeviceState(
      route: service.isSpeakerPreferred
          ? AudioOutputRoute.speaker
          : AudioOutputRoute.earpiece,
      canSwitch: service.canSwitchOutput,
    );
  }

  // Applied even when it matches what is already shown
  Future<void> selectRoute(AudioOutputRoute route) async {
    await ref
        .read(audioDeviceServiceProvider)
        .setSpeakerPreferred(route == AudioOutputRoute.speaker);
    state = state.copyWith(route: route);
  }
}
