import 'package:livekit_client/livekit_client.dart';


class AudioDeviceService {
  bool get canSwitchOutput => AudioManager.instance.canSwitchSpeakerphone;

  bool get isSpeakerPreferred => AudioManager.instance.isSpeakerOutputPreferred;

  // A connected headset keeps priority over the loudspeaker
  Future<void> setSpeakerPreferred(bool preferred, {bool force = false}) =>
      AudioManager.instance.setSpeakerOutputPreferred(preferred, force: force);
}
