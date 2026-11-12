import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/stories/data/repositories/stories_repository.dart';
import 'package:resonate/features/stories/model/chapter.dart';
import 'package:resonate/features/stories/view/pages/create_chapter_page.dart';

import 'package:resonate/core/services/media_picker_service.dart';
import '../fake_file_picker.dart';
import '../fake_stories_repository.dart';
import 'stories_test_helpers.dart';

class _ChapterBuildingRepository extends FakeStoriesRepository {
  ({
    String title,
    String description,
    String coverImgPath,
    String audioFilePath,
    String lyricsFilePath,
  })?
  builtWith;

  @override
  Future<Chapter> buildChapterFromFiles({
    required String title,
    required String description,
    required String coverImgPath,
    required String audioFilePath,
    required String lyricsFilePath,
  }) async {
    builtWith = (
      title: title,
      description: description,
      coverImgPath: coverImgPath,
      audioFilePath: audioFilePath,
      lyricsFilePath: lyricsFilePath,
    );
    return Chapter(
      chapterId: 'c1',
      title: title,
      coverImageUrl: coverImgPath,
      description: description,
      lyrics: '',
      audioFileUrl: audioFilePath,
      playDuration: 1000,
      tintColor: const Color(0xffcbc6c6),
    );
  }
}

void main() {
  late FakeFilePicker picker;
  late _ChapterBuildingRepository repo;
  late List<Chapter> created;

  setUp(() {
    picker = FakeFilePicker();
    repo = _ChapterBuildingRepository();
    created = [];
  });

  Future<void> pumpCreateChapter(WidgetTester tester) async {
    await pumpStoriesPage(
      tester,
      CreateChapterPage(onChapterCreated: created.add),
      overrides: [
        storiesRepositoryProvider.overrideWithValue(repo),
        mediaPickerServiceProvider.overrideWithValue(picker),
      ],
    );
    await tester.pumpAndSettle();
  }

  Finder titleField() => find.widgetWithText(TextField, 'Chapter Title *');
  Finder aboutField() => find.widgetWithText(TextField, 'About *');
  Finder audioRow() => find.text('Upload Audio File');
  Finder lyricsRow() => find.text('Upload Lyrics File');

  Future<void> tapCreate(WidgetTester tester) async {
    await tester.ensureVisible(
      find.widgetWithText(ElevatedButton, 'Create Chapter'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Create Chapter'));
    await tester.pumpAndSettle();
  }

  Future<void> pickAudio(WidgetTester tester, String path) async {
    picker.queue(path);
    await tester.tap(audioRow());
    await tester.pumpAndSettle();
  }

  group('the form', () {
    testStoryWidget('asks for a title, about, cover, audio and lyrics', (
      tester,
    ) async {
      await pumpCreateChapter(tester);

      expect(find.text('Create a Chapter'), findsOneWidget);
      expect(titleField(), findsOneWidget);
      expect(aboutField(), findsOneWidget);
      expect(audioRow(), findsOneWidget);
      expect(lyricsRow(), findsOneWidget);
    });
  });

  group('picking an audio file', () {
    testStoryWidget('names the file once chosen', (tester) async {
      await pumpCreateChapter(tester);

      await pickAudio(tester, '/tmp/song.mp3');

      expect(find.text('Audio file Selected: song.mp3'), findsOneWidget);
      expect(audioRow(), findsNothing);
    });

    testStoryWidget('asks the picker only for audio extensions', (
      tester,
    ) async {
      await pumpCreateChapter(tester);

      await pickAudio(tester, '/tmp/song.mp3');

      expect(picker.lastType, FileType.custom);
      expect(picker.lastAllowedExtensions, contains('mp3'));
      expect(picker.lastAllowedExtensions, contains('wav'));
    });

    // The picker's extension filter is advisory on some platforms, so the
    // page re-checks what came back.
    testStoryWidget('refuses a file that is not audio', (tester) async {
      await pumpCreateChapter(tester);

      await pickAudio(tester, '/tmp/notes.pdf');

      expect(audioRow(), findsOneWidget, reason: 'still unset');
    });

    testStoryWidget('cancelling the picker changes nothing', (tester) async {
      await pumpCreateChapter(tester);

      await tester.tap(audioRow());
      await tester.pumpAndSettle();

      expect(audioRow(), findsOneWidget);
    });
  });

  group('picking a lyrics file', () {
    testStoryWidget('names the file once chosen', (tester) async {
      await pumpCreateChapter(tester);

      picker.queue('/tmp/words.lrc');
      await tester.tap(lyricsRow());
      await tester.pumpAndSettle();

      expect(find.text('Lyrics File Selected: words.lrc'), findsOneWidget);
    });

    testStoryWidget('accepts a plain text file too', (tester) async {
      await pumpCreateChapter(tester);

      picker.queue('/tmp/words.txt');
      await tester.tap(lyricsRow());
      await tester.pumpAndSettle();

      expect(find.text('Lyrics File Selected: words.txt'), findsOneWidget);
    });

    testStoryWidget('refuses anything else', (tester) async {
      await pumpCreateChapter(tester);

      picker.queue('/tmp/song.mp3');
      await tester.tap(lyricsRow());
      await tester.pumpAndSettle();

      expect(lyricsRow(), findsOneWidget, reason: 'still unset');
    });
  });

  group('creating the chapter', () {
    Future<void> fillRequired(WidgetTester tester) async {
      await tester.enterText(titleField(), 'Chapter One');
      await tester.enterText(aboutField(), 'How it begins');
      await pickAudio(tester, '/tmp/song.mp3');
    }

    testStoryWidget('hands the chapter back and closes the page', (
      tester,
    ) async {
      await pumpCreateChapter(tester);
      await fillRequired(tester);

      await tapCreate(tester);

      expect(repo.builtWith?.title, 'Chapter One');
      expect(repo.builtWith?.description, 'How it begins');
      expect(repo.builtWith?.audioFilePath, '/tmp/song.mp3');
      expect(created.single.title, 'Chapter One');
    });

    // The cover is optional; a chapter without one gets the shared placeholder.
    testStoryWidget('falls back to the placeholder cover', (tester) async {
      await pumpCreateChapter(tester);
      await fillRequired(tester);

      await tapCreate(tester);

      expect(repo.builtWith?.coverImgPath, contains('http'));
    });

    testStoryWidget('passes an empty lyrics path when none was picked', (
      tester,
    ) async {
      await pumpCreateChapter(tester);
      await fillRequired(tester);

      await tapCreate(tester);

      expect(repo.builtWith?.lyricsFilePath, isEmpty);
    });

    testStoryWidget('passes the lyrics file when one was picked', (
      tester,
    ) async {
      await pumpCreateChapter(tester);
      await fillRequired(tester);
      picker.queue('/tmp/words.lrc');
      await tester.tap(lyricsRow());
      await tester.pumpAndSettle();

      await tapCreate(tester);

      expect(repo.builtWith?.lyricsFilePath, '/tmp/words.lrc');
    });

    testStoryWidget('a missing title builds nothing', (tester) async {
      await pumpCreateChapter(tester);
      await tester.enterText(aboutField(), 'How it begins');
      await pickAudio(tester, '/tmp/song.mp3');

      await tapCreate(tester);

      expect(repo.builtWith, isNull);
      expect(created, isEmpty);
    });

    testStoryWidget('a missing description builds nothing', (tester) async {
      await pumpCreateChapter(tester);
      await tester.enterText(titleField(), 'Chapter One');
      await pickAudio(tester, '/tmp/song.mp3');

      await tapCreate(tester);

      expect(repo.builtWith, isNull);
    });

    // A chapter is an audio chapter; there is nothing to publish without it.
    testStoryWidget('a missing audio file builds nothing', (tester) async {
      await pumpCreateChapter(tester);
      await tester.enterText(titleField(), 'Chapter One');
      await tester.enterText(aboutField(), 'How it begins');

      await tapCreate(tester);

      expect(repo.builtWith, isNull);
      expect(created, isEmpty);
    });
  });
}
