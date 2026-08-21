import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/stories/data/repositories/stories_repository.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:resonate/utils/enums/story_category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/category_stories.g.dart';

// Stories within a single category, fetched when the category page opens.
@riverpod
class CategoryStories extends _$CategoryStories {
  @override
  Future<List<Story>> build(StoryCategory category) async {
    final uid = ref.read(requireUserProvider).uid;
    return ref
        .watch(storiesRepositoryProvider)
        .fetchStoriesByCategory(category, uid);
  }
}
