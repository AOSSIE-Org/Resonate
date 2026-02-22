import 'package:get/get.dart';
import '../services/voice_control_service.dart';

class VoiceProfileController extends GetxController {
  /// Available predefined voice profiles.
  final List<String> voiceProfiles = const [
    'Default',
    'Deep',
    'Soft',
    'Energetic',
    'Calm',
  ];

  /// Currently selected voice profile.
  var selectedVoice = 'Default'.obs;

  /// Whether preview playback is active.
  var isPreviewEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Notify native layer of the initial defaults.
    _sendVoiceProfile();
    _sendPreviewState();
  }

  /// Called when the user picks a different voice profile.
  Future<void> onVoiceProfileChanged(String? voice) async {
    if (voice == null || voice == selectedVoice.value) return;
    selectedVoice.value = voice;
    await _sendVoiceProfile();
  }

  /// Called when the user toggles the preview switch.
  Future<void> onPreviewToggled(bool value) async {
    isPreviewEnabled.value = value;
    await _sendPreviewState();
  }

  // ─── private helpers ───────────────────────────────────────────────────────

  Future<void> _sendVoiceProfile() async {
    await VoiceControlService.setVoiceProfile(selectedVoice.value);
  }

  Future<void> _sendPreviewState() async {
    await VoiceControlService.setPreviewEnabled(isPreviewEnabled.value);
  }
}
