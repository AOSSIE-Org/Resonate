import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/core/providers/get_storage_provider.dart';
import 'package:resonate/features/settings/model/app_feature.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:resonate/features/stories/model/story_detail_state.dart';
import 'package:resonate/features/stories/view/pages/category_page.dart';
import 'package:resonate/features/stories/view/pages/explore_page.dart';
import 'package:resonate/features/stories/view/pages/story_page.dart';
import 'package:resonate/features/stories/view/widgets/live_chapter_list_tile.dart';
import 'package:resonate/features/stories/view/widgets/story_list_tile.dart';
import 'package:resonate/features/stories/data/category_stories.dart';
import 'package:resonate/features/stories/data/explore_stories.dart';
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

    Future<void> pumpStory(
      WidgetTester tester, {
      required bool liveChapterEnabled,
      required bool userIsCreator,
    }) async {
      final story = fakeStory(storyId: 's1', userIsCreator: userIsCreator);
      final storage = FakeGetStorage();
      if (!liveChapterEnabled) {
        await storage.write(AppFeature.liveChapter.storageKey, false);
      }
      await pumpStoriesPage(
        tester,
        StoryPage(story: story),
        overrides: [
          getStorageBoxProvider.overrideWithValue(storage),
          storyDetailProvider(story.storyId).overrideWith(
            () => FakeStoryDetail(
              StoryDetailState(
                chapters: [fakeChapter(title: 'My Chapter')],
                liveChapter: fakeLiveChapterModel(
                  chapterTitle: 'Live Chapter One',
                ),
              ),
            ),
          ),
        ],
      );
      await tester.pumpAndSettle();
    }

    testStoryWidget('shows the live chapter tile and the host button while '
        'the feature is on', (tester) async {
      await pumpStory(tester, liveChapterEnabled: true, userIsCreator: true);

      expect(find.byType(LiveChapterListTile), findsOneWidget);
      expect(find.text('Live Chapter One'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Live Chapter'), findsOneWidget);
    });

    testStoryWidget('hides the ongoing live chapter tile while the feature is '
        'off', (tester) async {
      await pumpStory(tester, liveChapterEnabled: false, userIsCreator: false);

      expect(find.byType(LiveChapterListTile), findsNothing);
      expect(find.text('Live Chapter One'), findsNothing);
      // The recorded chapters are untouched.
      expect(find.text('My Chapter'), findsOneWidget);
    });

    testStoryWidget('hides the host-a-live-chapter button while the feature '
        'is off', (tester) async {
      await pumpStory(tester, liveChapterEnabled: false, userIsCreator: true);

      expect(find.widgetWithText(ElevatedButton, 'Live Chapter'), findsNothing);
      // The creator's other actions stay.
      expect(find.widgetWithText(ElevatedButton, 'Add Chapter'), findsOneWidget);
    });
  });
}
