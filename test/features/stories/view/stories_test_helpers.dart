import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:resonate/features/stories/model/chapter_player_state.dart';
import 'package:resonate/features/stories/model/explore_state.dart';
import 'package:resonate/features/stories/model/live_chapter_state.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:resonate/features/stories/model/story_detail_state.dart';
import 'package:resonate/features/stories/viewmodel/category_stories_notifier.dart';
import 'package:resonate/features/stories/viewmodel/chapter_player_notifier.dart';
import 'package:resonate/features/stories/viewmodel/explore_stories_notifier.dart';
import 'package:resonate/features/stories/data/services/live_chapter_coordinator.dart';
import 'package:resonate/features/stories/viewmodel/story_detail_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/enums/story_category.dart';
import 'package:resonate/utils/ui_sizes.dart';

export '../../../helpers/test_root_container.dart';

Widget storiesTestApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en')],
    home: Builder(
      builder: (context) {
        UiSizes.init(context);
        return Scaffold(body: child);
      },
    ),
  );
}

Future<void> pumpStoriesPage(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const [],
}) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: storiesTestApp(child),
    ),
  );
}

void testStoryWidget(
  String description,
  Future<void> Function(WidgetTester tester) body,
) {
  testWidgets(
    description,
    (tester) => mockNetworkImagesFor(() => body(tester)),
  );
}

class FakeExploreStories extends ExploreStories {
  FakeExploreStories(this._future);
  final Future<List<Story>> _future;
  @override
  ExploreState build() {
    // Mirror the real build: load the recommended list into state.recommended.
    _future.then((stories) {
      if (ref.mounted) {
        state = state.copyWith(recommended: AsyncData(stories));
      }
    });
    return const ExploreState();
  }
}

class FakeCategoryStories extends CategoryStories {
  FakeCategoryStories(this._future);
  final Future<List<Story>> _future;
  @override
  Future<List<Story>> build(StoryCategory category) => _future;
}

class FakeStoryDetail extends StoryDetail {
  FakeStoryDetail(this._state);
  final StoryDetailState _state;
  @override
  Future<StoryDetailState> build(String storyId) async => _state;
}

class FakeLiveChapter extends LiveChapter {
  FakeLiveChapter(this._state);
  final LiveChapterState _state;
  @override
  LiveChapterState build() => _state;
}

class FakeChapterPlayer extends ChapterPlayer {
  FakeChapterPlayer(this._state);
  final ChapterPlayerState _state;
  @override
  ChapterPlayerState build(String chapterId) => _state;
}
