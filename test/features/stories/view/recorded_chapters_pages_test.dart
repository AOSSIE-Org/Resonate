import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/features/live_audio/data/services/livekit_controller.dart';
import 'package:resonate/features/stories/data/services/recording_audio.dart';
import 'package:resonate/features/stories/model/recorded_chapter.dart';
import 'package:resonate/features/stories/view/pages/recorded_chapter_detail_page.dart';
import 'package:resonate/features/stories/view/pages/recorded_chapters_page.dart';
import 'package:resonate/features/stories/view/widgets/recorded_chapter_tile.dart';
import 'package:resonate/features/stories/viewmodel/recorded_chapters_notifier.dart';

import 'stories_test_helpers.dart';

Future<void> pumpDetailPage(
  WidgetTester tester,
  RecordedChapter chapter, {
  List<Override> overrides = const [],
  FakeAudioPlayer? audio,
}) async {
  await pumpStoriesPage(
    tester,
    Builder(
      builder: (context) => ElevatedButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => RecordedChapterDetailPage(chapter: chapter),
          ),
        ),
        child: const Text('open'),
      ),
    ),
    // The real one builds an AudioPlayer, which talks to the platform.
    overrides: [
      recordingAudioPlayerProvider.overrideWithValue(
        audio ?? FakeAudioPlayer(),
      ),
      ...overrides,
    ],
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  group('RecordedChaptersPage', () {
    testStoryWidget('shows a loader while the recordings resolve', (
      tester,
    ) async {
      final completer = Completer<List<RecordedChapter>>();
      await pumpStoriesPage(
        tester,
        const RecordedChaptersPage(),
        overrides: [
          recordedChaptersProvider.overrideWith(
            () => FakeRecordedChapters(completer.future),
          ),
        ],
      );
      await tester.pump();

      expect(find.byType(LoadingIndicator), findsOneWidget);

      completer.complete(const []);
      await tester.pumpAndSettle();
    });

    testStoryWidget('explains the empty state when nothing was recorded', (
      tester,
    ) async {
      await pumpStoriesPage(
        tester,
        const RecordedChaptersPage(),
        overrides: [
          recordedChaptersProvider.overrideWith(
            () => FakeRecordedChapters(Future.value(const [])),
          ),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text('Nothing recorded yet'), findsOneWidget);
      expect(find.byType(RecordedChapterTile), findsNothing);
    });

    testStoryWidget('offers a retry when the recordings could not be read', (
      tester,
    ) async {
      await pumpStoriesPage(
        tester,
        const RecordedChaptersPage(),
        overrides: [
          recordedChaptersProvider.overrideWith(
            () => FakeRecordedChapters(Future.error(StateError('disk'))),
          ),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text('Could not load your recordings'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Retry'), findsOneWidget);
    });

    testStoryWidget('lists each recording with its length', (tester) async {
      await pumpStoriesPage(
        tester,
        const RecordedChaptersPage(),
        overrides: [
          recordedChaptersProvider.overrideWith(
            () => FakeRecordedChapters(
              Future.value([
                fakeRecordedChapter(title: 'Night Shift'),
                fakeRecordedChapter(id: 'rec-2', title: 'Second Take'),
              ]),
            ),
          ),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.byType(RecordedChapterTile), findsNWidgets(2));
      expect(find.text('Night Shift'), findsOneWidget);
      expect(find.text('1:05 min'), findsNWidgets(2));
    });

    testStoryWidget(
      'falls back to a placeholder title for an unnamed recording',
      (tester) async {
        await pumpStoriesPage(
          tester,
          const RecordedChaptersPage(),
          overrides: [
            recordedChaptersProvider.overrideWith(
              () => FakeRecordedChapters(
                Future.value([fakeRecordedChapter(title: '  ')]),
              ),
            ),
          ],
        );
        await tester.pumpAndSettle();

        expect(find.text('Untitled recording'), findsOneWidget);
      },
    );
  });

  group('RecordedChapterDetailPage', () {
    testStoryWidget('reviews the recording details', (tester) async {
      await pumpDetailPage(
        tester,
        fakeRecordedChapter(
          title: 'Night Shift',
          description: 'A late recording',
        ),
      );

      expect(find.text('Recorded'), findsOneWidget);
      expect(find.text('Length'), findsOneWidget);
      expect(find.text('1:05 min'), findsOneWidget);
      expect(find.text('rec-1.wav'), findsOneWidget);
      expect(find.text('A late recording'), findsOneWidget);
    });

    testStoryWidget('renders the transcript as timestamped lines', (
      tester,
    ) async {
      await pumpDetailPage(
        tester,
        fakeRecordedChapter(
          transcript:
              '[re:Resonate App - AOSSIE]\n'
              '[ve:v1.0.0]\n'
              '[00:02.50]Welcome back\n'
              '[00:42.00]And that is the end\n',
        ),
      );

      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('0:02'), findsOneWidget);
      expect(find.text('And that is the end'), findsOneWidget);
      expect(find.text('0:42'), findsOneWidget);
      // The LRC header lines are not transcript content.
      expect(find.textContaining('Resonate App - AOSSIE'), findsNothing);
    });

    testStoryWidget('says so when transcription produced nothing', (
      tester,
    ) async {
      await pumpDetailPage(tester, fakeRecordedChapter(transcript: ''));

      expect(
        find.text('No transcript was generated for this recording.'),
        findsOneWidget,
      );
    });

    testStoryWidget('plays and pauses the recording', (tester) async {
      final audio = FakeAudioPlayer();
      await pumpDetailPage(tester, fakeRecordedChapter(), audio: audio);

      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.play_arrow_rounded));
      await tester.pumpAndSettle();

      expect(audio.sourcePath, '/recordings/rec-1.wav');
      expect(audio.calls, ['load', 'resume']);
      expect(find.byIcon(Icons.pause_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.pause_rounded));
      await tester.pumpAndSettle();

      expect(audio.calls.last, 'pause');
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
    });

    testStoryWidget('the scrubber follows the playhead', (tester) async {
      final audio = FakeAudioPlayer();
      await pumpDetailPage(tester, fakeRecordedChapter(), audio: audio);
      await tester.tap(find.byIcon(Icons.play_arrow_rounded));
      await tester.pumpAndSettle();

      audio.emitPosition(const Duration(seconds: 30));
      await tester.pumpAndSettle();

      expect(find.text('0:30'), findsOneWidget);
      expect(tester.widget<Slider>(find.byType(Slider)).value, 30000);
    });

    testStoryWidget('tapping a transcript line seeks to it', (tester) async {
      final audio = FakeAudioPlayer();
      await pumpDetailPage(
        tester,
        fakeRecordedChapter(transcript: '[00:42.00]And that is the end\n'),
        audio: audio,
      );
      await tester.tap(find.byIcon(Icons.play_arrow_rounded));
      await tester.pumpAndSettle();

      await tester.tap(find.text('And that is the end'));
      await tester.pumpAndSettle();

      expect(audio.calls.last, 'seek');
    });

    testStoryWidget('playing is refused while a live session is up', (
      tester,
    ) async {
      final audio = FakeAudioPlayer();
      await pumpDetailPage(
        tester,
        fakeRecordedChapter(),
        audio: audio,
        overrides: [
          liveKitControllerProvider.overrideWith(
            ConnectedLiveKitController.new,
          ),
        ],
      );

      await tester.tap(find.byIcon(Icons.play_arrow_rounded));
      await tester.pumpAndSettle();

      expect(audio.calls, isEmpty);
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
    });

    testStoryWidget('leaving the screen stops the audio', (tester) async {
      final audio = FakeAudioPlayer();
      await pumpDetailPage(tester, fakeRecordedChapter(), audio: audio);
      await tester.tap(find.byIcon(Icons.play_arrow_rounded));
      await tester.pumpAndSettle();

      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));

      expect(find.byType(RecordedChapterDetailPage), findsNothing);
      expect(audio.calls, contains('stop'));
    });

    testStoryWidget('deletes the recording after the confirmation', (
      tester,
    ) async {
      final deleted = <String>[];
      await pumpDetailPage(
        tester,
        fakeRecordedChapter(id: 'rec-9'),
        overrides: [
          recordedChaptersProvider.overrideWith(
            () => _RecordingDeletes(deleted),
          ),
        ],
      );

      await tester.tap(find.byIcon(Icons.delete_outline_rounded));
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Delete recording'),
        ),
      );
      await tester.pumpAndSettle();

      expect(deleted, ['rec-9']);
      // Back on the page underneath; the list is what reflects the result.
      expect(find.byType(RecordedChapterDetailPage), findsNothing);
    });

    testStoryWidget('keeps the recording when the confirmation is cancelled', (
      tester,
    ) async {
      final deleted = <String>[];
      await pumpDetailPage(
        tester,
        fakeRecordedChapter(id: 'rec-9'),
        overrides: [
          recordedChaptersProvider.overrideWith(
            () => _RecordingDeletes(deleted),
          ),
        ],
      );

      await tester.tap(find.byIcon(Icons.delete_outline_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(deleted, isEmpty);
      expect(find.byType(RecordedChapterDetailPage), findsOneWidget);
    });
  });
}

class _RecordingDeletes extends RecordedChapters {
  _RecordingDeletes(this.deleted);

  final List<String> deleted;

  @override
  Future<List<RecordedChapter>> build() async => [fakeRecordedChapter()];

  @override
  Future<void> delete(String id) async => deleted.add(id);
}
