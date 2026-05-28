import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/models/audio_device.dart';

part 'generated/audio_device_state.freezed.dart';

@freezed
abstract class AudioDeviceState with _$AudioDeviceState {
  const factory AudioDeviceState({
    @Default(<AudioDevice>[]) List<AudioDevice> devices,
    AudioDevice? selected,
  }) = _AudioDeviceState;
}
