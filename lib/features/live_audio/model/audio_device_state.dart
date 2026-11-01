import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/audio_device_state.freezed.dart';

enum AudioOutputRoute { speaker, earpiece }

@freezed
abstract class AudioDeviceState with _$AudioDeviceState {
  const factory AudioDeviceState({
    @Default(AudioOutputRoute.speaker) AudioOutputRoute route,
    @Default(true) bool canSwitch,
  }) = _AudioDeviceState;
}
