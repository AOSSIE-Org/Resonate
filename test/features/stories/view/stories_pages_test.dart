import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:resonate/features/stories/model/story_detail_state.dart';
import 'package:resonate/features/stories/view/pages/category_page.dart';
import 'package:resonate/features/stories/view/pages/explore_page.dart';
import 'package:resonate/features/stories/view/pages/story_page.dart';
import 'package:resonate/features/stories/view/widgets/story_list_tile.dart';
import 'package:resonate/features/stories/viewmodel/category_stories_notifier.dart';
import 'package:resonate/features/stories/viewmodel/explore_stories_notifier.dart';
import 'package:resonate/features/stories/viewmodel/story_detail_notifier.dart';
import 'package:resonate/utils/enums/story_category.dart';

import 'stories_test_helpers.dart';

void main() {
  group('ExplorePage', () {
    testStoryWidget('shows a loader while recommended stories resolve', (
      tester,
    ) async {
      final completer = Completer<List<Story>>();
      await pumpStoriesPage(
        tester,
        const ExplorePage(),
        overrides: [
          exploreStoriesProvider.overrideWith(
            () => FakeExploreStories(completer.future),
          ),
        ],
      );
      await tester.pump();
      expect(find.byType(LoadingIndicator), findsOneWidget);

      completer.complete(const []);
      await tester.pumpAndSettle();
    });

    testStoryWidget('renders recommended stories', (tester) async {
      await pumpStoriesPage(
        tester,
        const ExplorePage(),
        overrides: [
          exploreStoriesProvider.overrideWith(
            () => FakeExploreStories(Future.value([fakeStory(title: 'Story A')])),
          ),
        ],
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Story A'), findsWidgets);
    });
  });

  group('CategoryPage', () {
    testStoryWidget('renders the category stories', (tester) async {
      await pumpStoriesPage(
        tester,
        const CategoryPage(category: StoryCategory.drama),
        overrides: [
          categoryStoriesProvider(StoryCategory.drama).overrideWith(
            () =>
                FakeCategoryStories(Future.value([fakeStory(title: 'Story A')])),
          ),
        ],
      );
      await tester.pumpAndSettle();
      expect(find.text('Story A'), findsOneWidget);
    });

    testStoryWidget('shows the empty state when there are no stories', (
      tester,
    ) async {
      await pumpStoriesPage(
        tester,
        const CategoryPage(category: StoryCategory.drama),
        overrides: [
          categoryStoriesProvider(
            StoryCategory.drama,
          ).overrideWith(() => FakeCategoryStories(Future.value(const []))),
        ],
      );
      await tester.pumpAndSettle();
      expect(find.byType(StoryListTile), findsNothing);
      expect(find.textContaining('Drama'), findsWidgets);
    });
  });

  group('StoryPage', () {
    testStoryWidget('renders the header and chapters from the detail state', (
      tester,
    ) async {
      final story = fakeStory(title: 'Story A', storyId: 's1');
      await pumpStoriesPage(
        tester,
        StoryPage(story: story),
        overrides: [
          storyDetailProvider(story.storyId).overrideWith(
            () => FakeStoryDetail(
              StoryDetailState(
                chapters: [fakeChapter(title: 'My Chapter')],
                likesCount: 5,
                isLikedByCurrentUser: false,
              ),
            ),
          ),
        ],
      );
      await tester.pumpAndSettle();
      expect(find.text('Story A'), findsOneWidget); // header
      expect(find.text('My Chapter'), findsOneWidget); // chapter
    });
  });
}
