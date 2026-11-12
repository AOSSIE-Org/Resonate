import 'package:livekit_client/livekit_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/audio_device_service.g.dart';

@Riverpod(keepAlive: true)
AudioDeviceService audioDeviceService(Ref ref) => AudioDeviceService();

class AudioDeviceService {
  bool get canSwitchOutput => AudioManager.instance.canSwitchSpeakerphone;

  bool get isSpeakerPreferred => AudioManager.instance.isSpeakerOutputPreferred;

  // A connected headset keeps priority over the loudspeaker
  Future<void> setSpeakerPreferred(bool preferred, {bool force = false}) =>
      AudioManager.instance.setSpeakerOutputPreferred(preferred, force: force);
}
