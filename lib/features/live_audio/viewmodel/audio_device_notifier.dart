import 'package:resonate/features/live_audio/data/services/audio_device_service.dart';
import 'package:resonate/features/live_audio/model/audio_device_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/audio_device_notifier.g.dart';

@Riverpod(keepAlive: true)
AudioDeviceService audioDeviceService(Ref ref) => AudioDeviceService();

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

  Future<void> selectRoute(AudioOutputRoute route) async {
    if (route == state.route) return;
    await ref
        .read(audioDeviceServiceProvider)
        .setSpeakerPreferred(route == AudioOutputRoute.speaker);
    state = state.copyWith(route: route);
  }
}
