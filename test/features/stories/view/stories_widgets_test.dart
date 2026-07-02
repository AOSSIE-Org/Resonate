import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/stories/model/chapter_player_state.dart';
import 'package:resonate/features/stories/view/widgets/category_card.dart';
import 'package:resonate/features/stories/view/widgets/chapter_list_tile.dart';
import 'package:resonate/features/stories/view/widgets/chapter_player.dart';
import 'package:resonate/features/stories/view/widgets/cover_image_picker.dart';
import 'package:resonate/features/stories/view/widgets/filtered_list_tile.dart';
import 'package:resonate/features/stories/view/widgets/like_button.dart';
import 'package:resonate/features/stories/view/widgets/secondary_list_card.dart';
import 'package:resonate/features/stories/view/widgets/story_card.dart';
import 'package:resonate/features/stories/view/widgets/story_list_tile.dart';
import 'package:resonate/features/stories/viewmodel/chapter_player_notifier.dart';
import 'package:resonate/utils/enums/story_category.dart';

import 'stories_test_helpers.dart';

void main() {
  group('LikeButton', () {
    testStoryWidget('renders the outline icon when not liked', (tester) async {
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

    testStoryWidget('renders the filled icon when already liked', (
      tester,
    ) async {
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

    testStoryWidget('tapping toggles to liked and reports true', (tester) async {
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

  group('CategoryCard', () {
    testStoryWidget('shows the localized category name', (tester) async {
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
    testStoryWidget('shows title, description and formatted duration', (
      tester,
    ) async {
      final chapter = fakeChapter(
        title: 'My Chapter',
        description: 'A chapter description',
        coverImageUrl: 'http://example.com/cover.png',
        playDuration: 65000, // 1:05
      );
      await tester.pumpWidget(storiesTestApp(ChapterListTile(chapter: chapter)));
      await tester.pump();

      expect(find.text('My Chapter'), findsOneWidget);
      expect(find.text('A chapter description'), findsOneWidget);
      expect(find.text('1:05 min'), findsOneWidget);
    });
  });

  group('StoryListTile', () {
    testStoryWidget('shows title, creator and category', (tester) async {
      final story = fakeStory(title: 'Story A', creatorName: 'Creator Name');
      await tester.pumpWidget(storiesTestApp(StoryListTile(story: story)));
      await tester.pump();

      expect(find.text('Story A'), findsOneWidget);
      expect(find.text('Creator Name'), findsOneWidget);
      expect(find.text('Drama'), findsOneWidget); // default category
    });
  });

  group('StoryCard', () {
    testStoryWidget('shows the hashed story title', (tester) async {
      final story = fakeStory(title: 'Story A');
      await tester.pumpWidget(storiesTestApp(StoryCard(story: story)));
      await tester.pump();
      expect(find.text('# Story A'), findsOneWidget);
    });
  });

  group('FilteredListTile', () {
    testStoryWidget('story variant shows the title and creator', (tester) async {
      final story = fakeStory(title: 'Story A', creatorName: 'Creator Name');
      await tester.pumpWidget(
        storiesTestApp(FilteredListTile(story: story, isStory: true)),
      );
      await tester.pump();
      expect(find.text('Story A'), findsOneWidget);
      expect(find.textContaining('Creator Name'), findsOneWidget);
    });

    testStoryWidget('user variant shows the username, name and rating', (
      tester,
    ) async {
      final user = fakeResonateUser(
        userName: ' testuser',
        name: ' Test User',
        profileImageUrl: 'http://example.com/u.png',
        userRating: 4.5,
      );
      await tester.pumpWidget(
        storiesTestApp(FilteredListTile(user: user, isStory: false)),
      );
      await tester.pump();
      expect(find.text(' testuser'), findsOneWidget);
      expect(find.textContaining('Test User'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });

  group('SecondaryListCard', () {
    testStoryWidget('wraps and shows its child', (tester) async {
      await tester.pumpWidget(
        storiesTestApp(const SecondaryListCard(child: Text('inner content'))),
      );
      expect(find.text('inner content'), findsOneWidget);
    });
  });

  group('CoverImagePicker', () {
    testStoryWidget('shows the placeholder image and change button', (
      tester,
    ) async {
      await tester.pumpWidget(
        storiesTestApp(
          CoverImagePicker(
            image: null,
            placeholderUrl: 'http://example.com/ph.png',
            onTap: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Image), findsOneWidget);
      expect(find.text('Change Cover Image'), findsOneWidget);
      expect(find.byIcon(Icons.change_circle), findsOneWidget);
    });

    testStoryWidget('fires onTap when the change button is tapped', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        storiesTestApp(
          CoverImagePicker(
            image: null,
            placeholderUrl: 'http://example.com/ph.png',
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.change_circle));
      expect(tapped, isTrue);
    });
  });

  group('ChapterPlayerView', () {
    testStoryWidget('renders the chapter title and a transport slider', (
      tester,
    ) async {
      final chapter = fakeChapter(
        chapterId: 'c1',
        title: 'My Chapter',
        coverImageUrl: 'http://example.com/cover.png',
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            chapterPlayerProvider(
              chapter.chapterId,
            ).overrideWith(() => FakeChapterPlayer(const ChapterPlayerState())),
          ],
          child: storiesTestApp(
            // Bounded so the absolutely-positioned transport lays out.
            SizedBox(
              height: 600,
              width: 400,
              child: ChapterPlayerView(chapter: chapter, progress: 0.0),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('My Chapter'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
    });
  });
}
