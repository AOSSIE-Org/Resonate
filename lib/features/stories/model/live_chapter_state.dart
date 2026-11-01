import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/features/stories/model/live_chapter_model.dart';

part 'generated/live_chapter_state.freezed.dart';

@freezed
abstract class LiveChapterState with _$LiveChapterState {
  const factory LiveChapterState({
    LiveChapterModel? model,
    @Default(false) bool isMicOn,
  }) = _LiveChapterState;
}
