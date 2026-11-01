import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/stories/data/repositories/stories_repository.dart';
import 'package:resonate/features/stories/model/explore_state.dart';
import 'package:resonate/features/stories/model/story_search_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/explore_stories_notifier.g.dart';


@Riverpod(keepAlive: true)
class ExploreStories extends _$ExploreStories {
  @override
  ExploreState build() {
    _loadRecommended();
    return const ExploreState();
  }
  
  Future<void> _loadRecommended() async {
    final uid = ref.read(requireUserProvider).uid;
    final result = await AsyncValue.guard(
      () => ref.read(storiesRepositoryProvider).fetchRecommendedStories(uid),
    );
    if (ref.mounted) state = state.copyWith(recommended: result);
  }

  Future<void> refresh() async {
    state = state.copyWith(recommended: const AsyncValue.loading());
    await _loadRecommended();
  }

  Future<void> search(String query) async {
    final uid = ref.read(requireUserProvider).uid;
    final results = await ref.read(storiesRepositoryProvider).search(query, uid);
    if (ref.mounted) state = state.copyWith(searchResults: results);
  }

  void clearSearch() {
    if (ref.mounted) {
      state = state.copyWith(searchResults: const StorySearchState());
    }
  }
}
