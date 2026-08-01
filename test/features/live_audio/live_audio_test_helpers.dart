import 'package:resonate/features/live_audio/model/audio_device.dart';
import 'package:resonate/features/live_audio/model/audio_device_state.dart';
import 'package:resonate/features/live_audio/viewmodel/audio_device_notifier.dart';

export '../../helpers/pump_widget.dart';
export '../../helpers/test_root_container.dart';

// Fake AudioDeviceNotifier: build() serves an injected future, records selects.
class FakeAudioDevice extends AudioDeviceNotifier {
  FakeAudioDevice(this._future);
  final Future<AudioDeviceState> _future;
  final List<AudioDevice> selected = [];

  @override
  Future<AudioDeviceState> build() => _future;

  @override
  Future<void> selectOutput(AudioDevice device) async => selected.add(device);
}
