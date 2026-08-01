import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:resonate/shared/model/resonate_user.dart';

part 'generated/story_search_state.freezed.dart';

@freezed
abstract class StorySearchState with _$StorySearchState {
  const factory StorySearchState({
    @Default(<Story>[]) List<Story> stories,
    @Default(<ResonateUser>[]) List<ResonateUser> users,
  }) = _StorySearchState;
}
