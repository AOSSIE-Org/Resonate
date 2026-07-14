import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:resonate/features/stories/model/story_search_state.dart';


class ExploreState {
  const ExploreState({
    this.recommended = const AsyncValue<List<Story>>.loading(),
    this.searchResults = const StorySearchState(),
  });

  final AsyncValue<List<Story>> recommended;
  final StorySearchState searchResults;

  ExploreState copyWith({
    AsyncValue<List<Story>>? recommended,
    StorySearchState? searchResults,
  }) =>
      ExploreState(
        recommended: recommended ?? this.recommended,
        searchResults: searchResults ?? this.searchResults,
      );
}
