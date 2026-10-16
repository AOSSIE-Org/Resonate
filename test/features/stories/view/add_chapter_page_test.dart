import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/stories/data/repositories/stories_repository.dart';
import 'package:resonate/features/stories/model/chapter.dart';
import 'package:resonate/features/stories/view/pages/add_chapter_page.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../fake_file_picker.dart';
import '../fake_stories_repository.dart';
import 'stories_test_helpers.dart';

class _AddChaptersRepository extends FakeStoriesRepository {
  ({List<Chapter> chapters, String storyId})? added;
  Object? addThrows;

  @override
  Future<Chapter> buildChapterFromFiles({
    required String title,
    required String description,
    required String coverImgPath,
    required String audioFilePath,
    required String lyricsFilePath,
  }) async => Chapter(
    chapterId: 'new-1',
    title: title,
    coverImageUrl: coverImgPath,
    description: description,
    lyrics: '',
    audioFileUrl: audioFilePath,
    playDuration: 90000,
    tintColor: const Color(0xffcbc6c6),
  );

  @override
  Future<void> addChaptersToStory(
    List<Chapter> chapters,
    String storyId,
  ) async {
    if (addThrows != null) throw addThrows!;
    added = (chapters: chapters, storyId: storyId);
  }
}

Chapter existingChapter({
  String id = 'c1',
  String title = 'Chapter One',
  String description = 'How it begins',
  int playDuration = 65000,
}) => Chapter(
  chapterId: id,
  title: title,
  coverImageUrl: 'https://example.com/cover.jpg',
  description: description,
  lyrics: '',
  audioFileUrl: 'https://example.com/audio.mp3',
  playDuration: playDuration,
  tintColor: const Color(0xffcbc6c6),
);

void main() {
  late FakeFilePicker picker;
  late _AddChaptersRepository repo;

  setUp(() {
    picker = FakeFilePicker();
    FilePicker.platform = picker;
    repo = _AddChaptersRepository();
  });

  // A successful submit pops twice — past this page AND the story page that
  // opened it — so the test needs both routes beneath it or Navigator asserts.
  final navKey = GlobalKey<NavigatorState>();

  Future<void> pumpAddChapter(
    WidgetTester tester, {
    List<Chapter> current = const [],
  }) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [storiesRepositoryProvider.overrideWithValue(repo)],
        child: MaterialApp(
          navigatorKey: navKey,
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
              return const Scaffold(body: Text('explore'));
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    navKey.currentState!.push(
      MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: Text('story page')),
      ),
    );
    await tester.pumpAndSettle();
    navKey.currentState!.push(
      MaterialPageRoute<void>(
        builder: (_) => AddChapterPage(
          storyName: 'My Story',
          storyId: 's1',
          currentChapters: current,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  // Walks the push-to-CreateChapterPage flow the add button opens.
  Future<void> addOneChapter(
    WidgetTester tester, {
    String title = 'Added',
  }) async {
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Chapter Title *'),
      title,
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'About *'),
      'Something new',
    );
    picker.queue('/tmp/song.mp3');
    await tester.tap(find.text('Upload Audio File'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Create Chapter'));
    await tester.pumpAndSettle();
  }

  Finder submitButton() => find.widgetWithText(ElevatedButton, 'New Chapters');

  group('the page', () {
    testStoryWidget('names the story it is adding to', (tester) async {
      await pumpAddChapter(tester);

      expect(find.text('Add New Chapters to My Story'), findsOneWidget);
    });

    testStoryWidget('lists the chapters the story already has', (tester) async {
      await pumpAddChapter(
        tester,
        current: [
          existingChapter(id: 'c1', title: 'Chapter One'),
          existingChapter(id: 'c2', title: 'Chapter Two'),
        ],
      );

      expect(find.text('Chapter One'), findsOneWidget);
      expect(find.text('Chapter Two'), findsOneWidget);
    });

    testStoryWidget('shows each chapter its play duration', (tester) async {
      await pumpAddChapter(
        tester,
        current: [existingChapter(playDuration: 65000)],
      );

      expect(find.text('1:05'), findsOneWidget);
    });

    // The card keeps the subtitle to one short line.
    testStoryWidget('truncates a long description', (tester) async {
      await pumpAddChapter(
        tester,
        current: [
          existingChapter(
            description: 'A description that runs well past thirty characters',
          ),
        ],
      );

      expect(find.textContaining('...'), findsOneWidget);
    });
  });

  group('adding a chapter', () {
    testStoryWidget('puts it in the new-chapters list', (tester) async {
      await pumpAddChapter(tester);

      await addOneChapter(tester, title: 'Chapter Three');

      expect(find.text('Chapter Three'), findsOneWidget);
    });
  });

  group('submitting', () {
    // Nothing was added, so there is nothing to send.
    testStoryWidget('with no new chapters does nothing', (tester) async {
      await pumpAddChapter(tester, current: [existingChapter()]);

      await tester.tap(submitButton());
      await tester.pumpAndSettle();

      expect(repo.added, isNull);
    });

    testStoryWidget('sends the new chapters against the story id', (
      tester,
    ) async {
      await pumpAddChapter(tester);
      await addOneChapter(tester, title: 'Chapter Three');

      await tester.tap(submitButton());
      await tester.pumpAndSettle();

      expect(repo.added?.storyId, 's1');
      expect(repo.added?.chapters.single.title, 'Chapter Three');
      // Back past the story page it was opened from.
      expect(find.text('explore'), findsOneWidget);
    });

    // The author should get to retry rather than lose the chapter they built.
    testStoryWidget('a failure leaves the page up', (tester) async {
      repo.addThrows = Exception('upload failed');
      await pumpAddChapter(tester);
      await addOneChapter(tester, title: 'Chapter Three');

      await tester.tap(submitButton());
      await tester.pumpAndSettle();

      expect(find.text('Add New Chapters to My Story'), findsOneWidget);
      expect(find.text('Chapter Three'), findsOneWidget);
    });
  });
}
