import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/chapter_player_state.freezed.dart';

@freezed
abstract class ChapterPlayerState with _$ChapterPlayerState {
  const factory ChapterPlayerState({
    @Default(0.0) double sliderProgress,
    @Default(false) bool isPlaying,
  }) = _ChapterPlayerState;
}
