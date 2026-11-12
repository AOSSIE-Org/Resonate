import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/recording_playback_state.freezed.dart';

@freezed
abstract class RecordingPlaybackState with _$RecordingPlaybackState {
  const factory RecordingPlaybackState({
    String? chapterId,
    @Default(false) bool isPlaying,
    @Default(Duration.zero) Duration position,
    @Default(Duration.zero) Duration duration,
  }) = _RecordingPlaybackState;
}
