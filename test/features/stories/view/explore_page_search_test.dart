import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/stories/data/explore_stories.dart';
import 'package:resonate/features/stories/model/explore_state.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:resonate/features/stories/model/story_search_state.dart';
import 'package:resonate/features/stories/view/pages/explore_page.dart';
import 'package:resonate/features/stories/view/widgets/filtered_list_tile.dart';
import 'package:resonate/shared/widgets/no_match_view.dart';
import 'package:resonate/shared/model/resonate_user.dart';

import 'stories_test_helpers.dart';

/// The search field debounces before it queries.
const _pastDebounce = Duration(milliseconds: 900);

/// Records what the page asks for and lets a test hand back results, which
/// FakeExploreStories (recommended-only) cannot do.
class _SearchableExplore extends ExploreStories {
  _SearchableExplore({this.results = const StorySearchState()});

  StorySearchState results;
  final List<String> searches = [];
  int clearCount = 0;
  int refreshCount = 0;

  @override
  ExploreState build() =>
      const ExploreState(recommended: AsyncData<List<Story>>(<Story>[]));

  @override
  Future<void> search(String query) async {
    searches.add(query);
    state = state.copyWith(searchResults: results);
  }

  @override
  void clearSearch() {
    clearCount++;
    state = state.copyWith(searchResults: const StorySearchState());
  }

  @override
  Future<void> refresh() async => refreshCount++;
}

void main() {
  late _SearchableExplore explore;

  Future<void> pumpExplore(
    WidgetTester tester, {
    StorySearchState results = const StorySearchState(),
  }) async {
    explore = _SearchableExplore(results: results);
    await pumpStoriesPage(
      tester,
      const ExplorePage(),
      overrides: [exploreStoriesProvider.overrideWith(() => explore)],
    );
    await tester.pumpAndSettle();
  }

  Finder searchField() => find.byType(TextField).first;

  // PopScope is generic, so byType with a concrete argument misses it.
  PopScope popScope(WidgetTester tester) =>
      tester.widgetList(find.byWidgetPredicate((w) => w is PopScope)).first
          as PopScope;

  Future<void> search(WidgetTester tester, String query) async {
    await tester.enterText(searchField(), query);
    await tester.pump(_pastDebounce);
    await tester.pumpAndSettle();
  }

  group('the search field', () {
    testStoryWidget('shows the recommended feed until something is typed', (
      tester,
    ) async {
      await pumpExplore(tester);

      expect(find.byType(NoMatchView), findsNothing);
      expect(explore.searches, isEmpty);
    });

    testStoryWidget('queries what was typed', (tester) async {
      await pumpExplore(tester);

      await search(tester, 'mystery');

      expect(explore.searches, ['mystery']);
    });

    // Only the last keystroke should cost a query.
    testStoryWidget('debounces a burst of typing into one query', (
      tester,
    ) async {
      await pumpExplore(tester);

      await tester.enterText(searchField(), 'my');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(searchField(), 'myst');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(searchField(), 'mystery');
      await tester.pump(_pastDebounce);
      await tester.pumpAndSettle();

      expect(explore.searches, ['mystery']);
    });

    // Emptying the box is not a search for "", it is a cancel.
    testStoryWidget('clearing the box drops the search instead of querying', (
      tester,
    ) async {
      await pumpExplore(tester);
      await search(tester, 'mystery');

      await tester.enterText(searchField(), '');
      await tester.pump(_pastDebounce);
      await tester.pumpAndSettle();

      expect(explore.clearCount, greaterThanOrEqualTo(1));
      expect(explore.searches, ['mystery'], reason: 'no empty query');
    });
  });

  group('the results', () {
    testStoryWidget('say so when nothing matched', (tester) async {
      await pumpExplore(tester);

      await search(tester, 'zzzz');

      expect(find.byType(NoMatchView), findsOneWidget);
    });

    testStoryWidget('list matching stories', (tester) async {
      await pumpExplore(
        tester,
        results: StorySearchState(
          stories: [fakeStory(storyId: 's1', title: 'A Mystery')],
        ),
      );

      await search(tester, 'mystery');

      expect(find.byType(NoMatchView), findsNothing);
      expect(find.byType(FilteredListTile), findsOneWidget);
    });

    testStoryWidget('list matching people too', (tester) async {
      await pumpExplore(
        tester,
        results: StorySearchState(
          stories: [fakeStory(storyId: 's1', title: 'A Mystery')],
          users: [
            ResonateUser(
              uid: 'u1',
              name: 'Ada',
              userName: 'ada',
              profileImageUrl: 'https://example.com/ada.jpg',
              userRating: 4.5,
            ),
          ],
        ),
      );

      await search(tester, 'ada');

      expect(find.byType(FilteredListTile), findsNWidgets(2));
    });

    // Every ResonateUser field is nullable; a hit built from a partial row
    // used to take the whole results list down with it.
    testStoryWidget('survive a user row with nothing but an id', (
      tester,
    ) async {
      await pumpExplore(
        tester,
        results: StorySearchState(users: [ResonateUser(uid: 'u1')]),
      );

      await search(tester, 'ada');

      expect(find.byType(FilteredListTile), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testStoryWidget('fall back to the name when there is no username', (
      tester,
    ) async {
      await pumpExplore(
        tester,
        results: StorySearchState(
          users: [ResonateUser(uid: 'u1', name: 'Ada Lovelace')],
        ),
      );

      await search(tester, 'ada');

      expect(find.text('Ada Lovelace'), findsWidgets);
    });
  });

  group('leaving the search', () {
    // Backing out of a search returns to the feed rather than the previous
    // screen, so the page refuses the pop and clears itself.
    testStoryWidget('a back gesture clears instead of popping', (tester) async {
      await pumpExplore(tester);
      await search(tester, 'mystery');

      final scope = popScope(tester);
      expect(scope.canPop, isFalse);

      scope.onPopInvokedWithResult!(false, null);
      await tester.pumpAndSettle();

      expect(explore.clearCount, greaterThanOrEqualTo(1));
      expect(find.byType(NoMatchView), findsNothing);
    });

    testStoryWidget('an untouched page pops normally', (tester) async {
      await pumpExplore(tester);

      expect(popScope(tester).canPop, isTrue);
    });
  });

  testStoryWidget('pull to refresh reloads the feed', (tester) async {
    await pumpExplore(tester);

    await tester.fling(searchField(), const Offset(0, 400), 1000);
    await tester.pumpAndSettle();

    expect(explore.refreshCount, 1);
  });
}
