import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/features/stories/model/chapter.dart';
import 'package:resonate/features/stories/model/live_chapter_model.dart';

part 'generated/story_detail_state.freezed.dart';

// The reactive slice of a story shown on the detail page
@freezed
abstract class StoryDetailState with _$StoryDetailState {
  const factory StoryDetailState({
    @Default(<Chapter>[]) List<Chapter> chapters,
    @Default(0) int likesCount,
    @Default(false) bool isLikedByCurrentUser,
    LiveChapterModel? liveChapter,
  }) = _StoryDetailState;
}
