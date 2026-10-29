import 'package:resonate/features/live_audio/data/services/audio_device_service.dart';
import 'package:resonate/features/live_audio/model/audio_device_state.dart';
import 'package:resonate/features/live_audio/viewmodel/audio_device_notifier.dart';

export '../../helpers/pump_widget.dart';
export '../../helpers/test_root_container.dart';

// Stands in for LiveKit's AudioManager, which is a singleton behind a platform
// channel and cannot run under `flutter test`.
class FakeAudioDeviceService implements AudioDeviceService {
  FakeAudioDeviceService({this.canSwitchOutput = true, bool speaker = true})
    : _speaker = speaker;

  @override
  final bool canSwitchOutput;

  bool _speaker;
  final List<bool> setCalls = [];

  @override
  bool get isSpeakerPreferred => _speaker;

  @override
  Future<void> setSpeakerPreferred(bool preferred, {bool force = false}) async {
    setCalls.add(preferred);
    _speaker = preferred;
  }
}

// Fake notifier serving a fixed state, recording the routes it is asked for.
class FakeAudioDevice extends AudioDeviceNotifier {
  FakeAudioDevice(this._state);
  final AudioDeviceState _state;
  final List<AudioOutputRoute> selected = [];

  @override
  AudioDeviceState build() => _state;

  @override
  Future<void> selectRoute(AudioOutputRoute route) async =>
      selected.add(route);
}
