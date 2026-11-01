import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/stories/model/chapter_player_state.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:resonate/features/stories/model/story_detail_state.dart';
import 'package:resonate/features/stories/view/pages/add_chapter_page.dart';
import 'package:resonate/features/stories/view/pages/chapter_play_page.dart';
import 'package:resonate/features/stories/view/pages/story_page.dart';
import 'package:resonate/features/stories/viewmodel/chapter_player_notifier.dart';
import 'package:resonate/features/stories/viewmodel/story_detail_notifier.dart';

import 'stories_test_helpers.dart';

/// Records the like toggle; FakeStoryDetail only serves canned state.
class _ToggleableDetail extends StoryDetail {
  _ToggleableDetail(this._state, {this.fails = false});

  final StoryDetailState _state;
  final bool fails;
  final List<String> toggled = [];

  @override
  Future<StoryDetailState> build(String storyId) async {
    if (fails) throw Exception('could not load the story');
    return _state;
  }

  @override
  Future<void> toggleLike(Story story) async => toggled.add(story.storyId);
}

/// The real player opens an AudioPlayer in initialize.
class _StubPlayer extends ChapterPlayer {
  @override
  ChapterPlayerState build(String chapterId) => const ChapterPlayerState();

  @override
  void initialize({
    required String audioUrl,
    required String lyrics,
    required Duration duration,
  }) {}
}

void main() {
  late _ToggleableDetail detail;

  Future<Story> pumpStory(
    WidgetTester tester, {
    StoryDetailState state = const StoryDetailState(),
    bool fails = false,
    List<String> tags = const [],
    String description = 'A short description',
    bool userIsCreator = false,
  }) async {
    final base = fakeStory(
      storyId: 's1',
      title: 'Story A',
      description: description,
    );
    // fakeStory takes no tags, so the chip cases rebuild the model directly.
    final story = Story(
      storyId: base.storyId,
      title: base.title,
      description: base.description,
      userIsCreator: userIsCreator,
      category: base.category,
      coverImageUrl: base.coverImageUrl,
      creatorId: base.creatorId,
      creatorName: base.creatorName,
      creatorImgUrl: base.creatorImgUrl,
      creationDate: base.creationDate,
      likesCount: base.likesCount,
      isLikedByCurrentUser: base.isLikedByCurrentUser,
      playDuration: base.playDuration,
      tintColor: base.tintColor,
      tags: tags,
    );
    detail = _ToggleableDetail(state, fails: fails);
    await pumpStoriesPage(
      tester,
      StoryPage(story: story),
      overrides: [
        storyDetailProvider('s1').overrideWith(() => detail),
        chapterPlayerProvider('chapter-1').overrideWith(_StubPlayer.new),
      ],
    );
    await tester.pumpAndSettle();
    return story;
  }

  group('loading the story', () {
    testStoryWidget('says so when the detail cannot be loaded', (tester) async {
      await pumpStory(tester, fails: true);

      expect(find.text('Error'), findsWidgets);
    });

    testStoryWidget('shows the title once it is loaded', (tester) async {
      await pumpStory(
        tester,
        state: StoryDetailState(chapters: [fakeChapter(title: 'My Chapter')]),
      );

      expect(find.text('Story A'), findsOneWidget);
      expect(find.text('My Chapter'), findsOneWidget);
    });
  });

  group('the description', () {
    testStoryWidget('expands and collapses when tapped', (tester) async {
      await pumpStory(
        tester,
        description: 'A description long enough to be worth expanding.',
      );

      final state = tester.state<State<StoryPage>>(find.byType(StoryPage));
      // ignore: avoid_dynamic_calls
      expect((state as dynamic).descriptionIsExpanded, isFalse);

      await tester.tap(find.textContaining('A description long enough'));
      await tester.pumpAndSettle();
      // ignore: avoid_dynamic_calls
      expect((state as dynamic).descriptionIsExpanded, isTrue);

      await tester.tap(find.textContaining('A description long enough'));
      await tester.pumpAndSettle();
      // ignore: avoid_dynamic_calls
      expect((state as dynamic).descriptionIsExpanded, isFalse);
    });
  });

  group('tags', () {
    testStoryWidget('are not drawn when the story has none', (tester) async {
      await pumpStory(tester);

      expect(find.byType(Chip), findsNothing);
    });

    testStoryWidget('show one chip per tag', (tester) async {
      await pumpStory(tester, tags: const ['mystery', 'noir']);

      expect(find.byType(Chip), findsNWidgets(2));
      expect(find.text('mystery'), findsOneWidget);
      expect(find.text('noir'), findsOneWidget);
    });
  });

  group('liking', () {
    testStoryWidget('the button asks the notifier to toggle', (tester) async {
      await pumpStory(
        tester,
        state: const StoryDetailState(
          likesCount: 5,
          isLikedByCurrentUser: false,
        ),
      );

      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pumpAndSettle();

      expect(detail.toggled, ['s1']);
    });

    testStoryWidget('an already-liked story shows a filled heart', (
      tester,
    ) async {
      await pumpStory(
        tester,
        state: const StoryDetailState(
          likesCount: 6,
          isLikedByCurrentUser: true,
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });

  group('chapters', () {
    testStoryWidget('tapping one opens the player', (tester) async {
      await pumpStory(
        tester,
        state: StoryDetailState(
          chapters: [fakeChapter(chapterId: 'chapter-1', title: 'My Chapter')],
        ),
      );

      await tester.tap(find.text('My Chapter'));
      await tester.pumpAndSettle();

      expect(find.byType(ChapterPlayPage), findsOneWidget);
    });

    // Adding chapters is offered on the author's own story only.
    testStoryWidget('the add button is hidden on another story', (
      tester,
    ) async {
      await pumpStory(
        tester,
        state: StoryDetailState(chapters: [fakeChapter(title: 'My Chapter')]),
      );

      expect(find.text('Add Chapter'), findsNothing);
    });

    testStoryWidget('the add button opens the chapter composer', (
      tester,
    ) async {
      await pumpStory(
        tester,
        userIsCreator: true,
        state: StoryDetailState(chapters: [fakeChapter(title: 'My Chapter')]),
      );

      await tester.ensureVisible(find.text('Add Chapter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add Chapter'));
      await tester.pumpAndSettle();

      expect(find.byType(AddChapterPage), findsOneWidget);
    });
  });
}
