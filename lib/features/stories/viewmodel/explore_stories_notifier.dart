import 'package:resonate/features/auth/viewmodel/current_user.dart';
import 'package:resonate/features/stories/data/repositories/stories_repository.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/explore_stories_notifier.g.dart';

@Riverpod(keepAlive: true)
class ExploreStories extends _$ExploreStories {
  @override
  Future<List<Story>> build() async {
    final uid = ref.read(requireUserProvider).uid;
    return ref.watch(storiesRepositoryProvider).fetchRecommendedStories(uid);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      final uid = ref.read(requireUserProvider).uid;
      return ref.read(storiesRepositoryProvider).fetchRecommendedStories(uid);
    });
  }
}
