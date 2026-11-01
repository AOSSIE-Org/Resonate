import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/stories/data/repositories/stories_repository.dart';
import 'package:resonate/features/stories/model/chapter.dart';
import 'package:resonate/features/stories/viewmodel/category_stories_notifier.dart';
import 'package:resonate/features/stories/viewmodel/explore_stories_notifier.dart';
import 'package:resonate/utils/enums/story_category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/create_story_notifier.g.dart';

@Riverpod(keepAlive: true) // kept alive as was dying mid upload
class CreateStory extends _$CreateStory {
  @override
  void build() {}

  Future<Chapter> buildChapter({
    required String title,
    required String description,
    required String coverImgPath,
    required String audioFilePath,
    required String lyricsFilePath,
  }) => ref
      .read(storiesRepositoryProvider)
      .buildChapterFromFiles(
        title: title,
        description: description,
        coverImgPath: coverImgPath,
        audioFilePath: audioFilePath,
        lyricsFilePath: lyricsFilePath,
      );

  Future<Chapter> buildRecordedChapter({
    required String chapterId,
    required String title,
    required String description,
    required String coverImgPath,
    required String audioFilePath,
    required String lyrics,
  }) => ref
      .read(storiesRepositoryProvider)
      .buildRecordedChapter(
        chapterId: chapterId,
        title: title,
        description: description,
        coverImgPath: coverImgPath,
        audioFilePath: audioFilePath,
        lyrics: lyrics,
      );

  Future<void> createStory({
    required String title,
    required String description,
    required StoryCategory category,
    required String coverImgRef,
    required int storyPlayDuration,
    required List<Chapter> chapters,
  }) async {
    await ref
        .read(storiesRepositoryProvider)
        .createStory(
          user: ref.read(requireUserProvider),
          title: title,
          description: description,
          category: category,
          coverImgRef: coverImgRef,
          storyPlayDuration: storyPlayDuration,
          chapters: chapters,
        );
    ref.invalidate(exploreStoriesProvider);
    ref.invalidate(categoryStoriesProvider(category));
  }

  Future<void> addChaptersToStory(
    List<Chapter> chapters,
    String storyId,
  ) async {
    await ref
        .read(storiesRepositoryProvider)
        .addChaptersToStory(chapters, storyId);
    ref.invalidate(exploreStoriesProvider);
  }
}
