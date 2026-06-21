import 'package:resonate/core/container.dart';
import 'package:resonate/features/stories/data/repositories/stories_repository.dart';
import 'package:resonate/features/stories/model/story_search_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/story_search_notifier.g.dart';

// Holds the explore search results stories + users
@riverpod
class StorySearch extends _$StorySearch {
  @override
  StorySearchState build() => const StorySearchState();

  Future<void> search(String query) async {
    final uid = requireCurrentAuthUser.uid;
    final results = await ref
        .read(storiesRepositoryProvider)
        .search(query, uid);
    if (ref.mounted) state = results;
  }

  void clear() {
    if (ref.mounted) state = const StorySearchState();
  }
}
