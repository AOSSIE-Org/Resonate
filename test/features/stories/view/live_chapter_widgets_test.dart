import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/stories/model/live_chapter_attendees_model.dart';
import 'package:resonate/features/stories/model/live_chapter_state.dart';
import 'package:resonate/features/stories/view/widgets/live_chapter_attendee_block.dart';
import 'package:resonate/features/stories/view/widgets/live_chapter_header.dart';
import 'package:resonate/features/stories/view/widgets/live_chapter_list_tile.dart';
import 'package:resonate/features/stories/view/widgets/start_live_chapter_dialog.dart';
import 'package:resonate/features/stories/viewmodel/live_chapter_notifier.dart';

import 'stories_test_helpers.dart';

void main() {
  group('LiveChapterHeader', () {
    testStoryWidget('shows the chapter name and description', (tester) async {
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
    testStoryWidget('shows title, description and the Live label', (
      tester,
    ) async {
      final live = fakeLiveChapterModel(chapterTitle: 'Live Chapter One');
      await tester.pumpWidget(
        storiesTestApp(LiveChapterListTile(chapter: live)),
      );
      expect(find.text('Live Chapter One'), findsOneWidget);
      expect(find.text('Live description'), findsOneWidget); // default
      expect(find.text('Live'), findsOneWidget);
    });
  });

  group('LiveChapterAttendeeBlock', () {
    Future<void> pumpBlock(
      WidgetTester tester, {
      required String authorUid,
      required LiveChapterAttendee user,
    }) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            liveChapterProvider.overrideWith(
              () => FakeLiveChapter(
                LiveChapterState(
                  model: fakeLiveChapterModel(authorUid: authorUid),
                ),
              ),
            ),
          ],
          child: storiesTestApp(LiveChapterAttendeeBlock(user: user)),
        ),
      );
      await tester.pumpAndSettle();
    }

    testStoryWidget('labels the author and shows their first name', (
      tester,
    ) async {
      await pumpBlock(
        tester,
        authorUid: 'u1',
        user: LiveChapterAttendee(
          id: 'u1',
          name: 'Alice Smith',
          profileImageUrl: 'http://example.com/a.png',
        ),
      );
      expect(find.text('Alice'), findsOneWidget); // first word of the name
      expect(find.text('Author'), findsOneWidget);
      expect(find.text('Listener'), findsNothing);
    });

    testStoryWidget('labels a non-author as a listener', (tester) async {
      await pumpBlock(
        tester,
        authorUid: 'someone-else',
        user: LiveChapterAttendee(
          id: 'u2',
          name: 'Bob Jones',
          profileImageUrl: 'http://example.com/b.png',
        ),
      );
      expect(find.text('Listener'), findsOneWidget);
      expect(find.text('Author'), findsNothing);
    });
  });

  group('StartLiveChapterDialog', () {
    testStoryWidget('renders the title, two fields and the actions', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: storiesTestApp(StartLiveChapterDialog(story: fakeStory())),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Start a Live Chapter'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Start'), findsOneWidget);
    });

    testStoryWidget('Start with empty fields does not begin loading', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: storiesTestApp(StartLiveChapterDialog(story: fakeStory())),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Start'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
