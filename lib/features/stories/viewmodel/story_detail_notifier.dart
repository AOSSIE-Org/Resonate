import 'package:resonate/features/auth/viewmodel/current_user.dart';
import 'package:resonate/features/stories/data/repositories/stories_repository.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:resonate/features/stories/model/story_detail_state.dart';
import 'package:resonate/features/stories/viewmodel/category_stories_notifier.dart';
import 'package:resonate/features/stories/viewmodel/explore_stories_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/story_detail_notifier.g.dart';

// The reactive slice of a single story
@riverpod
class StoryDetail extends _$StoryDetail {
  @override
  Future<StoryDetailState> build(String storyId) async {
    final uid = ref.read(requireUserProvider).uid;
    return ref.watch(storiesRepositoryProvider).loadStoryDetail(storyId, uid);
  }

  Future<void> toggleLike(Story story) async {
    final current = state.value;
    if (current == null) return;
    final uid = ref.read(requireUserProvider).uid;
    final repo = ref.read(storiesRepositoryProvider);
    final liveStory = story.copyWith(likesCount: current.likesCount);

    final willLike = !current.isLikedByCurrentUser;
    state = AsyncData(
      current.copyWith(
        isLikedByCurrentUser: willLike,
        likesCount: current.likesCount + (willLike ? 1 : -1),
      ),
    );

    try {
      if (willLike) {
        await repo.likeStory(liveStory, uid);
      } else {
        await repo.unlikeStory(liveStory, uid);
      }
      final likes = await repo.fetchLikesCount(story.storyId);
      final liked = await repo.checkIfStoryLikedByUser(story.storyId, uid);
      if (ref.mounted) {
        state = AsyncData(
          current.copyWith(likesCount: likes, isLikedByCurrentUser: liked),
        );
      }
    } catch (_) {
      if (ref.mounted) state = AsyncData(current);
    }
  }

  Future<void> deleteStory(Story story) async {
    await ref.read(storiesRepositoryProvider).deleteStory(story);
    ref.invalidate(exploreStoriesProvider);
    ref.invalidate(categoryStoriesProvider(story.category));
  }
}
