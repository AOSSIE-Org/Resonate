import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/stories/data/repositories/recorded_chapters_repository.dart';
import 'package:resonate/features/stories/data/services/recorded_chapter_store.dart';
import 'package:resonate/features/stories/model/recorded_chapter.dart';

import '../recording_fixtures.dart';

void main() {
  late Directory recordings;
  late RecordedChapterStore store;
  late RecordedChaptersRepository repository;

  setUp(() {
    recordings = Directory.systemTemp.createTempSync('resonate_recordings');
    store = RecordedChapterStore(directory: () async => recordings);
    repository = RecordedChaptersRepository(store: store);
  });

  tearDown(() {
    if (recordings.existsSync()) recordings.deleteSync(recursive: true);
  });

  File recording(String id, {String extension = '.wav', int seconds = 1}) =>
      File('${recordings.path}/$id$extension')
        ..writeAsBytesSync(wavBytes(seconds: seconds));

  Future<RecordedChapter?> save(
    String id, {
    String title = 'Recording',
    String description = 'desc',
    String transcript = '',
    DateTime? recordedAt,
  }) => repository.save(
    id: id,
    title: title,
    description: description,
    transcript: transcript,
    recordedAt: recordedAt,
  );

  group('RecordedChaptersRepository', () {
    test(
      'save reads the duration off the recording and lists it back',
      () async {
        recording('c1', seconds: 2);

        final saved = await repository.save(
          id: 'c1',
          title: 'Night Shift',
          description: 'about the chapter',
          transcript: '[00:01.00]hello',
        );

        expect(saved, isNotNull);
        expect(saved!.durationMs, 2000);
        expect(saved.audioFilePath, endsWith('c1.wav'));
        expect(saved.recordedAt.isUtc, isTrue);
        expect((await repository.fetchAll()).single.title, 'Night Shift');
      },
    );

    test('save returns null when the session produced no audio', () async {
      expect(await save('c1'), isNull);
      expect(await repository.fetchAll(), isEmpty);
    });

    test('save replaces an earlier entry for the same chapter', () async {
      recording('c1');
      await save('c1', title: 'first');
      await save('c1', title: 'second');

      final listed = await repository.fetchAll();
      expect(listed, hasLength(1));
      expect(listed.single.title, 'second');
    });

    test('fetchAll returns the newest recording first', () async {
      recording('old');
      recording('new');
      await save('old', recordedAt: DateTime.utc(2026, 1, 1));
      await save('new', recordedAt: DateTime.utc(2026, 6, 1));

      expect((await repository.fetchAll()).map((c) => c.id), ['new', 'old']);
    });

    test(
      'fetchAll drops entries whose audio is gone and rewrites the index',
      () async {
        recording('kept');
        recording('gone');
        await save('kept');
        await save('gone');
        File('${recordings.path}/gone.wav').deleteSync();

        expect((await repository.fetchAll()).map((c) => c.id), ['kept']);
        expect((await store.readIndex()).map((c) => c.id), ['kept']);
      },
    );

    test(
      'fetchAll follows an mp4 entry to the wav transcription produced',
      () async {
        // The contents only have to be parseable; what is under test is which
        // file the entry points at once both exist.
        recording('c1', extension: '.mp4');
        await save('c1');
        expect(
          (await repository.fetchAll()).single.audioFilePath,
          endsWith('.mp4'),
        );

        recording('c1');
        expect(
          (await repository.fetchAll()).single.audioFilePath,
          endsWith('.wav'),
        );
        expect(
          (await store.readIndex()).single.audioFilePath,
          endsWith('.wav'),
        );
      },
    );

    test(
      'updateDetails rewrites the title, description and transcript',
      () async {
        recording('c1');
        await save('c1', title: 'working title', transcript: 'raw');

        await repository.updateDetails(
          id: 'c1',
          title: 'Night Shift',
          description: 'edited',
          transcript: '[00:00.00]edited line',
        );

        final chapter = (await repository.fetchAll()).single;
        expect(chapter.title, 'Night Shift');
        expect(chapter.description, 'edited');
        expect(chapter.transcript, '[00:00.00]edited line');
        expect(chapter.durationMs, 1000);
      },
    );

    test('updateDetails leaves an unknown chapter alone', () async {
      recording('c1');
      await save('c1', title: 'kept');

      await repository.updateDetails(
        id: 'other',
        title: 'x',
        description: 'x',
        transcript: 'x',
      );

      expect((await repository.fetchAll()).single.title, 'kept');
    });

    test('delete removes both recordings and the index entry', () async {
      recording('c1');
      recording('c1', extension: '.mp4');
      await save('c1');

      await repository.delete('c1');

      expect(File('${recordings.path}/c1.wav').existsSync(), isFalse);
      expect(File('${recordings.path}/c1.mp4').existsSync(), isFalse);
      expect(await repository.fetchAll(), isEmpty);
    });

    test('delete leaves the other recordings in place', () async {
      recording('c1');
      recording('c2');
      await save('c1');
      await save('c2');

      await repository.delete('c1');

      expect((await repository.fetchAll()).map((c) => c.id), ['c2']);
      expect(File('${recordings.path}/c2.wav').existsSync(), isTrue);
    });
  });

  group('RecordedChapterStore', () {
    test('a half-written index reads as empty instead of throwing', () async {
      File(
        '${recordings.path}/${RecordedChapterStore.indexFileName}',
      ).writeAsStringSync('[{"id": "c1"');

      expect(await store.readIndex(), isEmpty);
    });

    test('an index that is not a list reads as empty', () async {
      File(
        '${recordings.path}/${RecordedChapterStore.indexFileName}',
      ).writeAsStringSync('{"chapters": []}');

      expect(await store.readIndex(), isEmpty);
    });

    test('writing creates the recordings folder when it is missing', () async {
      recordings.deleteSync(recursive: true);

      await store.writeIndex(const []);

      expect(recordings.existsSync(), isTrue);
      expect(await store.readIndex(), isEmpty);
    });
  });
}
