import 'dart:io' as io;

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appwrite/models.dart' as models show File;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/stories/data/repositories/stories_repository.dart';
import 'package:resonate/features/stories/model/stories_failure.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/story_category.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

void main() {
  late MockTablesDB tables;
  late MockStorage storage;
  late MockFunctions functions;
  late StoriesRepository repo;

  setUp(() {
    tables = MockTablesDB();
    storage = MockStorage();
    functions = MockFunctions();
    repo = StoriesRepository(
      tables: tables,
      storage: storage,
      functions: functions,
    );
  });

  Row chapterRow({String id = 'c1', int playDuration = 250}) => buildRow(
    id: id,
    tableId: chapterTableId,
    databaseId: databaseId,
    data: {
      'title': 'A Chapter',
      'description': 'desc',
      'lyrics': '',
      'coverImgUrl': 'https://example.com/cc.jpg',
      'audioFileUrl': 'https://example.com/audio.mp3',
      'playDuration': playDuration,
      'tintColor': 'cbc6c6',
    },
  );

  void throwOn(String tableId, [int code = 500]) {
    when(
      tables.listRows(
        databaseId: databaseId,
        tableId: tableId,
        queries: anyNamed('queries'),
      ),
    ).thenThrow(AppwriteException('boom', code));
  }

  void emptyList(String tableId) {
    when(
      tables.listRows(
        databaseId: databaseId,
        tableId: tableId,
        queries: anyNamed('queries'),
      ),
    ).thenAnswer((_) async => RowList(total: 0, rows: const []));
  }

  group('failing reads degrade to an empty list', () {
    test('fetchStoriesByCategory', () async {
      throwOn(storyTableId);

      expect(
        await repo.fetchStoriesByCategory(StoryCategory.drama, 'me'),
        isEmpty,
      );
    });

    test('fetchCreatedStories', () async {
      throwOn(storyTableId);

      expect(await repo.fetchCreatedStories('me', viewerUid: 'me'), isEmpty);
    });

    test('fetchLikedStories', () async {
      throwOn(likeTableId);

      expect(await repo.fetchLikedStories('me'), isEmpty);
    });

    // A story search that works while people search is down is better than
    // one combined error.
    test('a failing user search still returns the stories', () async {
      when(
        tables.listRows(
          databaseId: databaseId,
          tableId: storyTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 1,
          rows: [
            buildRow(
              id: 's1',
              tableId: storyTableId,
              databaseId: databaseId,
              data: {
                'title': 'Adventure',
                'description': 'desc',
                'category': 'drama',
                'creatorId': 'creator-1',
                'creatorName': 'Creator',
                'creatorImgUrl': 'https://example.com/a.jpg',
                'coverImgUrl': 'https://example.com/c.jpg',
                'likes': 0,
                'playDuration': 1000,
                'tintColor': 'cbc6c6',
                'tags': const <String>[],
              },
            ),
          ],
        ),
      );
      throwOn(usersTableID);

      final state = await repo.search('adv', 'me');

      expect(state.stories, hasLength(1));
      expect(state.users, isEmpty);
    });
  });

  // The detail page assembles four independent reads; one failing must not
  // blank the other three.
  group('loadStoryDetail keeps the parts that did load', () {
    test('a failing chapter read leaves the likes intact', () async {
      throwOn(chapterTableId);
      emptyList(likeTableId);
      emptyList(liveChaptersTableId);
      when(
        tables.getRow(
          databaseId: databaseId,
          tableId: storyTableId,
          rowId: 's1',
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => buildRow(
          id: 's1',
          tableId: storyTableId,
          databaseId: databaseId,
          data: const {'likes': 7},
        ),
      );

      final detail = await repo.loadStoryDetail('s1', 'me');

      expect(detail.chapters, isEmpty);
      expect(detail.likesCount, 7);
    });

    test('a failing likes count falls back to zero', () async {
      when(
        tables.listRows(
          databaseId: databaseId,
          tableId: chapterTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => RowList(total: 1, rows: [chapterRow()]));
      emptyList(likeTableId);
      emptyList(liveChaptersTableId);
      when(
        tables.getRow(
          databaseId: databaseId,
          tableId: storyTableId,
          rowId: 's1',
          queries: anyNamed('queries'),
        ),
      ).thenThrow(AppwriteException('gone', 404));

      final detail = await repo.loadStoryDetail('s1', 'me');

      expect(detail.chapters, hasLength(1));
      expect(detail.likesCount, 0);
    });
  });

  // Likes are a write the user is watching, so unlike the reads these do
  // surface as a failure.
  group('like and unlike surface their failures', () {
    test('likeStory throws StoriesFailure.unknown', () async {
      when(
        tables.createRow(
          databaseId: anyNamed('databaseId'),
          tableId: likeTableId,
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenThrow(AppwriteException('no write access', 401));

      expect(
        repo.likeStory(fakeStory(storyId: 's1'), 'me'),
        throwsA(isA<StoriesFailureUnknown>()),
      );
    });

    test('unlikeStory throws StoriesFailure.unknown', () async {
      when(
        tables.listRows(
          databaseId: databaseId,
          tableId: likeTableId,
          queries: anyNamed('queries'),
        ),
      ).thenThrow(AppwriteException('no read access', 401));

      expect(
        repo.unlikeStory(fakeStory(storyId: 's1'), 'me'),
        throwsA(isA<StoriesFailureUnknown>()),
      );
    });
  });

  group('pushChaptersToStory', () {
    void stubUpload() {
      when(
        storage.createFile(
          bucketId: anyNamed('bucketId'),
          fileId: anyNamed('fileId'),
          file: anyNamed('file'),
        ),
      ).thenAnswer(
        (_) async => models.File(
          $id: 'f1',
          bucketId: storyBucketId,
          $createdAt: DateTime(2024).toIso8601String(),
          $updatedAt: DateTime(2024).toIso8601String(),
          $permissions: const ['any'],
          name: 'x',
          signature: 'sig',
          mimeType: 'application/octet-stream',
          sizeOriginal: 10,
          sizeActual: 10,
          folder: '',
          key: '',
          encryption: false,
          compression: '',
          chunksTotal: 1,
          chunksUploaded: 1,
        ),
      );
    }

    test('uploads a local cover and audio, then writes the row', () async {
      stubUpload();
      when(
        tables.createRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => chapterRow());

      await repo.pushChaptersToStory([
        fakeChapter(
          chapterId: 'c1',
          coverImageUrl: '/tmp/cover.png',
          audioFileUrl: '/tmp/audio.m4a',
        ),
      ], 's1');

      verify(
        storage.createFile(
          bucketId: storyBucketId,
          fileId: 'c1',
          file: anyNamed('file'),
        ),
      ).called(1);
      verify(
        storage.createFile(
          bucketId: storyBucketId,
          fileId: 'audioForc1',
          file: anyNamed('file'),
        ),
      ).called(1);

      final data =
          verify(
                tables.createRow(
                  databaseId: databaseId,
                  tableId: chapterTableId,
                  rowId: 'c1',
                  data: captureAnyNamed('data'),
                ),
              ).captured.single
              as Map;
      expect(data['storyId'], 's1');
      expect(data['coverImgUrl'], contains('/files/c1/view'));
    });

    // Over the limit the Appwrite SDK would switch to a chunked upload, which
    // the backend rejects with a misleading "empty file". Refuse it here, with
    // the real numbers, before anything is sent.
    test('a file over the upload limit is refused before it is sent', () async {
      stubUpload();
      final directory = io.Directory.systemTemp.createTempSync('upload_limit');
      addTearDown(() => directory.deleteSync(recursive: true));
      final oversized = io.File('${directory.path}/cover.png')
        ..writeAsBytesSync(List<int>.filled(maxUploadBytes + 1, 0));

      await expectLater(
        repo.pushChaptersToStory([
          fakeChapter(chapterId: 'c1', coverImageUrl: oversized.path),
        ], 's1'),
        throwsA(
          isA<StoriesFailureTooLarge>()
              .having((f) => f.what, 'what', 'chapter cover')
              .having((f) => f.bytes, 'bytes', maxUploadBytes + 1)
              .having((f) => f.maxBytes, 'maxBytes', maxUploadBytes),
        ),
      );

      verifyNever(
        storage.createFile(
          bucketId: anyNamed('bucketId'),
          fileId: anyNamed('fileId'),
          file: anyNamed('file'),
        ),
      );
    });

    test('a file inside the limit is sent as normal', () async {
      stubUpload();
      when(
        tables.createRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => chapterRow());
      final directory = io.Directory.systemTemp.createTempSync('upload_ok');
      addTearDown(() => directory.deleteSync(recursive: true));
      final sized = io.File('${directory.path}/cover.png')
        ..writeAsBytesSync(List<int>.filled(1024, 0));

      await repo.pushChaptersToStory([
        fakeChapter(chapterId: 'c1', coverImageUrl: sized.path, audioFileUrl: '/tmp/audio.m4a'),
      ], 's1');

      verify(
        storage.createFile(
          bucketId: storyBucketId,
          fileId: 'c1',
          file: anyNamed('file'),
        ),
      ).called(1);
    });

    // Re-uploading the same file is how a retried publish behaves; the
    // existing object is the one we want.
    test('an already-uploaded file is reused rather than failing', () async {
      when(
        storage.createFile(
          bucketId: anyNamed('bucketId'),
          fileId: anyNamed('fileId'),
          file: anyNamed('file'),
        ),
      ).thenThrow(AppwriteException('exists', 409));
      when(
        tables.createRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => chapterRow());

      await repo.pushChaptersToStory([
        fakeChapter(chapterId: 'c1', coverImageUrl: '/tmp/cover.png', audioFileUrl: '/tmp/audio.m4a'),
      ], 's1');

      verify(
        tables.createRow(
          databaseId: databaseId,
          tableId: chapterTableId,
          rowId: 'c1',
          data: anyNamed('data'),
        ),
      ).called(1);
    });

    test('an upload that fails for any other reason is a failure', () async {
      when(
        storage.createFile(
          bucketId: anyNamed('bucketId'),
          fileId: anyNamed('fileId'),
          file: anyNamed('file'),
        ),
      ).thenThrow(AppwriteException('too large', 413));

      expect(
        repo.pushChaptersToStory([
          fakeChapter(chapterId: 'c1', coverImageUrl: '/tmp/cover.png', audioFileUrl: '/tmp/audio.m4a'),
        ], 's1'),
        throwsA(isA<StoriesFailureUpload>()),
      );
    });

    // A retried publish re-pushes chapters that already landed.
    test('a chapter row that already exists is updated instead', () async {
      stubUpload();
      when(
        tables.createRow(
          databaseId: anyNamed('databaseId'),
          tableId: chapterTableId,
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenThrow(AppwriteException('exists', 409));
      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => chapterRow());

      await repo.pushChaptersToStory([fakeChapter(chapterId: 'c1', audioFileUrl: '/tmp/audio.m4a')], 's1');

      verify(
        tables.updateRow(
          databaseId: databaseId,
          tableId: chapterTableId,
          rowId: 'c1',
          data: anyNamed('data'),
        ),
      ).called(1);
    });

    test('any other row write error is rethrown', () async {
      stubUpload();
      when(
        tables.createRow(
          databaseId: anyNamed('databaseId'),
          tableId: chapterTableId,
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenThrow(AppwriteException('bad schema', 400));

      expect(
        repo.pushChaptersToStory([fakeChapter(chapterId: 'c1', audioFileUrl: '/tmp/audio.m4a')], 's1'),
        throwsA(isA<AppwriteException>()),
      );
    });
  });

  // The chapters are already saved by this point; a stale total is better
  // than reporting the whole add as failed.
  test('addChaptersToStory tolerates a failed duration update', () async {
    when(
      tables.listRows(
        databaseId: databaseId,
        tableId: chapterTableId,
        queries: anyNamed('queries'),
      ),
    ).thenAnswer((_) async => RowList(total: 1, rows: [chapterRow()]));
    when(
      tables.updateRow(
        databaseId: anyNamed('databaseId'),
        tableId: storyTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      ),
    ).thenThrow(AppwriteException('locked', 500));

    await expectLater(repo.addChaptersToStory(const [], 's1'), completes);
  });

  // Deletion runs cleanup first and the row last. Every cleanup step is
  // allowed to fail, or a half-deleted story could never be removed.
  group('deleteStory survives a failing cleanup step', () {
    void stubCleanDeletes() {
      when(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenAnswer((_) async {});
      emptyList(chapterTableId);
      emptyList(likeTableId);
      when(
        storage.deleteFile(
          bucketId: anyNamed('bucketId'),
          fileId: anyNamed('fileId'),
        ),
      ).thenAnswer((_) async {});
    }

    void expectStoryRowDeleted() {
      verify(
        tables.deleteRow(
          databaseId: databaseId,
          tableId: storyTableId,
          rowId: 's1',
        ),
      ).called(1);
    }

    test('a missing cover image', () async {
      stubCleanDeletes();
      when(
        storage.deleteFile(
          bucketId: anyNamed('bucketId'),
          fileId: anyNamed('fileId'),
        ),
      ).thenThrow(AppwriteException('no such file', 404));

      await repo.deleteStory(fakeStory(storyId: 's1'));

      expectStoryRowDeleted();
    });

    test('an unreadable chapter list', () async {
      stubCleanDeletes();
      throwOn(chapterTableId);

      await repo.deleteStory(fakeStory(storyId: 's1'));

      expectStoryRowDeleted();
    });

    test('an unreadable like list', () async {
      stubCleanDeletes();
      throwOn(likeTableId);

      await repo.deleteStory(fakeStory(storyId: 's1'));

      expectStoryRowDeleted();
    });

    test('its like rows are removed along with it', () async {
      stubCleanDeletes();
      when(
        tables.listRows(
          databaseId: databaseId,
          tableId: likeTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 2,
          rows: [
            buildRow(id: 'like-1', tableId: likeTableId, data: const {}),
            buildRow(id: 'like-2', tableId: likeTableId, data: const {}),
          ],
        ),
      );

      await repo.deleteStory(fakeStory(storyId: 's1'));

      verify(
        tables.deleteRow(
          databaseId: databaseId,
          tableId: likeTableId,
          rowId: 'like-1',
        ),
      ).called(1);
      verify(
        tables.deleteRow(
          databaseId: databaseId,
          tableId: likeTableId,
          rowId: 'like-2',
        ),
      ).called(1);
    });
  });

  group('deleteChapter survives a failing step', () {
    test('a missing cover or audio file still removes the row', () async {
      when(
        storage.deleteFile(
          bucketId: anyNamed('bucketId'),
          fileId: anyNamed('fileId'),
        ),
      ).thenThrow(AppwriteException('no such file', 404));
      when(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenAnswer((_) async {});

      await repo.deleteChapter(fakeChapter(chapterId: 'c1'));

      verify(
        tables.deleteRow(
          databaseId: databaseId,
          tableId: chapterTableId,
          rowId: 'c1',
        ),
      ).called(1);
    });

    // Nothing upstream reacts to this, so it must not throw either.
    test('a failing row delete is swallowed', () async {
      when(
        storage.deleteFile(
          bucketId: anyNamed('bucketId'),
          fileId: anyNamed('fileId'),
        ),
      ).thenAnswer((_) async {});
      when(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenThrow(AppwriteException('locked', 500));

      await expectLater(
        repo.deleteChapter(fakeChapter(chapterId: 'c1')),
        completes,
      );
    });
  });
}
