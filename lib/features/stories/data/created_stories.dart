import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/stories/data/category_stories.dart';
import 'package:resonate/features/stories/data/explore_stories.dart';
import 'package:resonate/features/stories/data/repositories/stories_repository.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/created_stories.g.dart';

@riverpod
class CreatedStories extends _$CreatedStories {
  @override
  Future<List<Story>> build(String creatorId) async {
    final viewerUid = ref.read(currentUserProvider)?.uid;
    return ref
        .watch(storiesRepositoryProvider)
        .fetchCreatedStories(creatorId, viewerUid: viewerUid);
  }

  // Optimistic
  Future<void> deleteStory(Story story) async {
    // the profile page may be left while the delete is still running
    final link = ref.keepAlive();
    final previous = state.value;
    if (previous != null) {
      state = AsyncData(
        previous.where((s) => s.storyId != story.storyId).toList(),
      );
    }
    try {
      await ref.read(storiesRepositoryProvider).deleteStory(story);
      ref.invalidate(exploreStoriesProvider);
      ref.invalidate(categoryStoriesProvider(story.category));
    } catch (_) {
      if (previous != null) state = AsyncData(previous);
      rethrow;
    } finally {
      link.close();
    }
  }
}
