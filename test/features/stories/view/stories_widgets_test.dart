import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:resonate/features/stories/model/story_detail_state.dart';
import 'package:resonate/features/stories/view/pages/category_page.dart';
import 'package:resonate/features/stories/view/pages/explore_page.dart';
import 'package:resonate/features/stories/view/pages/story_page.dart';
import 'package:resonate/features/stories/view/widgets/category_card.dart';
import 'package:resonate/features/stories/view/widgets/chapter_list_tile.dart';
import 'package:resonate/features/stories/view/widgets/filtered_list_tile.dart';
import 'package:resonate/features/stories/view/widgets/like_button.dart';
import 'package:resonate/features/stories/view/widgets/live_chapter_header.dart';
import 'package:resonate/features/stories/view/widgets/live_chapter_list_tile.dart';
import 'package:resonate/features/stories/view/widgets/story_card.dart';
import 'package:resonate/features/stories/view/widgets/story_list_tile.dart';
import 'package:resonate/features/stories/viewmodel/category_stories_notifier.dart';
import 'package:resonate/features/stories/viewmodel/explore_stories_notifier.dart';
import 'package:resonate/features/stories/viewmodel/story_detail_notifier.dart';
import 'package:resonate/utils/enums/story_category.dart';

import '../../../helpers/test_root_container.dart';
import 'stories_test_helpers.dart';

// Fake notifiers 
class _FakeExploreStories extends ExploreStories {
  _FakeExploreStories(this._future);
  final Future<List<Story>> _future;
  @override
  Future<List<Story>> build() => _future;
}

class _FakeCategoryStories extends CategoryStories {
  _FakeCategoryStories(this._future);
  final Future<List<Story>> _future;
  @override
  Future<List<Story>> build(StoryCategory category) => _future;
}

class _FakeStoryDetail extends StoryDetail {
  _FakeStoryDetail(this._state);
  final StoryDetailState _state;
  @override
  Future<StoryDetailState> build(String storyId) async => _state;
}

final _chapter = fakeChapter(
  chapterId: 'c1',
  title: 'My Chapter',
  coverImageUrl: 'http://example.com/cover.png',
  description: 'A chapter description',
  audioFileUrl: 'http://example.com/audio.mp3',
  playDuration: 65000, // 1:05
);

final _live = fakeLiveChapterModel(
  id: 'r1',
  authorUid: 'u1',
  authorProfileImageUrl: '',
  authorName: 'Author Name',
  chapterTitle: 'Live Chapter One',
  // chapterDescription defaults to Live description
);

final _user = fakeResonateUser(
  uid: 'u9',
  userName: 'janedoe',
  name: 'Jane Doe',
  profileImageUrl: 'http://example.com/u.png',
  userRating: 4.5,
);

final _story = fakeStory(
  title: 'Story A',
  storyId: 's1',
  description: 'story description',
  coverImageUrl: 'http://example.com/c.png',
  creatorId: 'u1',
  creatorName: 'Creator Name',
  creatorImgUrl: 'http://example.com/p.png',
  likesCount: 3,
  playDuration: 65000,
);

void main() {
  group('LikeButton', () {
    testWidgets('renders the outline icon when not liked', (tester) async {
      await tester.pumpWidget(
        storiesTestApp(
          LikeButton(
            tintColor: const Color(0xffEE0000),
            isLikedByUser: false,
            onLiked: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('renders the filled icon when already liked', (tester) async {
      await tester.pumpWidget(
        storiesTestApp(
          LikeButton(
            tintColor: const Color(0xffEE0000),
            isLikedByUser: true,
            onLiked: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('tapping toggles to liked and reports true', (tester) async {
      bool? reported;
      await tester.pumpWidget(
        storiesTestApp(
          LikeButton(
            tintColor: const Color(0xffEE0000),
            isLikedByUser: false,
            onLiked: (v) => reported = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(LikeButton));
      await tester.pumpAndSettle();

      expect(reported, isTrue);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });

  group('LiveChapterHeader', () {
    testWidgets('shows the chapter name and description', (tester) async {
      await tester.pumpWidget(
        storiesTestApp(
          const LiveChapterHeader(
            chapterName: 'Header Title',
            chapterDescription: 'Header description',
          ),
        ),
      );
      expect(find.text('Header Title'), findsOneWidget);
      expect(find.text('Header description'), findsOneWidget);
    });
  });

  group('LiveChapterListTile', () {
    testWidgets('shows title, description and the Live label', (tester) async {
      await tester.pumpWidget(storiesTestApp(LiveChapterListTile(chapter: _live)));
      expect(find.text('Live Chapter One'), findsOneWidget);
      expect(find.text('Live description'), findsOneWidget);
      expect(find.text('Live'), findsOneWidget);
    });
  });

  group('CategoryCard', () {
    testWidgets('shows the localized category name', (tester) async {
      await tester.pumpWidget(
        storiesTestApp(
          const CategoryCard(
            category: StoryCategory.drama,
            color: Color(0xff336699),
          ),
        ),
      );
      expect(find.text('Drama'), findsOneWidget);
    });
  });

  group('ChapterListTile', () {
    testWidgets('shows title, description and formatted duration', (tester) async {
      await tester.pumpWidget(storiesTestApp(ChapterListTile(chapter: _chapter)));
      await tester.pump();

      expect(find.text('My Chapter'), findsOneWidget);
      expect(find.text('A chapter description'), findsOneWidget);
      expect(find.text('1:05 min'), findsOneWidget); // formatPlayDuration + lengthMinutes

      clearImageLoadErrors(tester);
    });
  });

  group('StoryListTile', () {
    testWidgets('shows title, creator and category', (tester) async {
      await tester.pumpWidget(storiesTestApp(StoryListTile(story: _story)));
      await tester.pump();

      expect(find.text('Story A'), findsOneWidget);
      expect(find.text('Creator Name'), findsOneWidget);
      expect(find.text('Drama'), findsOneWidget);

      clearImageLoadErrors(tester);
    });
  });

  group('StoryCard', () {
    testWidgets('shows the hashed story title', (tester) async {
      await tester.pumpWidget(storiesTestApp(StoryCard(story: _story)));
      await tester.pump();
      expect(find.text('# Story A'), findsOneWidget);
      clearImageLoadErrors(tester);
    });
  });

  group('FilteredListTile (story)', () {
    testWidgets('shows the story title and creator', (tester) async {
      await tester.pumpWidget(
        storiesTestApp(FilteredListTile(story: _story, isStory: true)),
      );
      await tester.pump();
      expect(find.text('Story A'), findsOneWidget);
      expect(find.textContaining('Creator Name'), findsOneWidget);
      clearImageLoadErrors(tester);
    });
  });

  group('FilteredListTile (user)', () {
    testWidgets('shows the username, name and rating', (tester) async {
      await tester.pumpWidget(
        storiesTestApp(FilteredListTile(user: _user, isStory: false)),
      );
      await tester.pump();
      expect(find.text('janedoe'), findsOneWidget); // title
      expect(find.textContaining('Test User'), findsOneWidget); // "User: Test User"
      expect(find.text('4.5'), findsOneWidget); // rating
      expect(find.byIcon(Icons.star), findsOneWidget);
      clearImageLoadErrors(tester);
    });
  });

  group('ExplorePage', () {
    testWidgets('shows a loader while recommended stories resolve', (tester) async {
      final completer = Completer<List<Story>>();
      await pumpStoriesPage(
        tester,
        const ExplorePage(),
        container: ProviderContainer(
          overrides: [
            exploreStoriesProvider.overrideWith(
              () => _FakeExploreStories(completer.future),
            ),
          ],
        ),
      );
      await tester.pump();
      expect(find.byType(LoadingIndicator), findsOneWidget);

      completer.complete(const []);
      await tester.pumpAndSettle();
      clearImageLoadErrors(tester);
    });

    testWidgets('renders recommended stories', (tester) async {
      await pumpStoriesPage(
        tester,
        const ExplorePage(),
        container: ProviderContainer(
          overrides: [
            exploreStoriesProvider.overrideWith(
              () => _FakeExploreStories(Future.value([_story])),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Story A'), findsWidgets);
      clearImageLoadErrors(tester);
    });
  });

  group('CategoryPage', () {
    testWidgets('renders the category stories', (tester) async {
      await pumpStoriesPage(
        tester,
        const CategoryPage(category: StoryCategory.drama),
        container: ProviderContainer(
          overrides: [
            categoryStoriesProvider(StoryCategory.drama).overrideWith(
              () => _FakeCategoryStories(Future.value([_story])),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Story A'), findsOneWidget);
      clearImageLoadErrors(tester);
    });

    testWidgets('shows the empty state when there are no stories', (tester) async {
      await pumpStoriesPage(
        tester,
        const CategoryPage(category: StoryCategory.drama),
        container: ProviderContainer(
          overrides: [
            categoryStoriesProvider(StoryCategory.drama).overrideWith(
              () => _FakeCategoryStories(Future.value(const [])),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(StoryListTile), findsNothing);
      expect(find.textContaining('Drama'), findsWidgets);
      clearImageLoadErrors(tester);
    });
  });

  group('StoryPage', () {
    testWidgets('renders the header and chapters from the detail state', (
      tester,
    ) async {
      await pumpStoriesPage(
        tester,
        StoryPage(story: _story),
        container: ProviderContainer(
          overrides: [
            storyDetailProvider(_story.storyId).overrideWith(
              () => _FakeStoryDetail(
                StoryDetailState(
                  chapters: [_chapter],
                  likesCount: 5,
                  isLikedByCurrentUser: false,
                ),
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Story A'), findsOneWidget); // header 
      expect(find.text('My Chapter'), findsOneWidget); // chapter 
      clearImageLoadErrors(tester);
    });
  });
}
