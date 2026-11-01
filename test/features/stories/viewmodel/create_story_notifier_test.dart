import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'dart:io' as io;

import 'package:resonate/features/stories/data/repositories/recorded_chapters_repository.dart';
import 'package:resonate/features/stories/data/services/recorded_chapter_store.dart';
import 'package:resonate/features/stories/model/chapter.dart';
import 'package:resonate/features/stories/viewmodel/create_story_notifier.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/story_category.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';
import '../recording_fixtures.dart';

Row _chapterRow({String id = 'c1', int playDuration = 250}) => buildRow(
      id: id,
      tableId: chapterTableId,
      databaseId: databaseId,
      data: {
        'title': 'Chapter $id',
        'description': 'desc',
        'lyrics': '',
        'coverImgUrl': 'https://example.com/cc.jpg',
        'audioFileUrl': 'https://example.com/audio.mp3',
        'playDuration': playDuration,
        'tintColor': 'cbc6c6',
      },
    );

void main() {
  late MockTablesDB tables;
  late MockStorage storage;
  late MockFunctions functions;

  setUp(() {
    tables = MockTablesDB();
    storage = MockStorage();
    functions = MockFunctions();
  });

  Future<dynamic> install() => installTestRootContainer(
        authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
        tables: tables,
        storage: storage,
        functions: functions,
      );

  test('createStory writes the story row (URL cover, no chapters)', () async {
    when(tables.createRow(
      databaseId: databaseId,
      tableId: storyTableId,
      rowId: anyNamed('rowId'),
      data: anyNamed('data'),
    )).thenAnswer((_) async => buildRow(
          id: 's-new',
          tableId: storyTableId,
          databaseId: databaseId,
          data: const {},
        ));

    final container = await install();

    await container.read(createStoryProvider.notifier).createStory(
          title: 'My Story',
          description: 'desc',
          category: StoryCategory.drama,
          coverImgRef: 'https://example.com/cover.jpg',
          storyPlayDuration: 100,
          chapters: const <Chapter>[],
        );

    verify(tables.createRow(
      databaseId: databaseId,
      tableId: storyTableId,
      rowId: anyNamed('rowId'),
      data: anyNamed('data'),
    )).called(1);
  });

  test('addChaptersToStory updates the story duration from the DB', () async {
    when(tables.listRows(
      databaseId: databaseId,
      tableId: chapterTableId,
      queries: anyNamed('queries'),
    )).thenAnswer((_) async => RowList(
          total: 2,
          rows: [
            _chapterRow(id: 'c1', playDuration: 200),
            _chapterRow(id: 'c2', playDuration: 300),
          ],
        ));
    when(tables.updateRow(
      databaseId: databaseId,
      tableId: storyTableId,
      rowId: 's1',
      data: anyNamed('data'),
    )).thenAnswer((_) async => buildRow(
          id: 's1',
          tableId: storyTableId,
          databaseId: databaseId,
          data: const {},
        ));

    final container = await install();

    await container
        .read(createStoryProvider.notifier)
        .addChaptersToStory(const <Chapter>[], 's1');

    verify(tables.updateRow(
      databaseId: databaseId,
      tableId: storyTableId,
      rowId: 's1',
      data: {'playDuration': 500},
    )).called(1);
  });

  test('updateRecordedChapter carries the verified details into the archive',
      () async {
    final recordings =
        io.Directory.systemTemp.createTempSync('resonate_recordings');
    addTearDown(() {
      if (recordings.existsSync()) recordings.deleteSync(recursive: true);
    });
    io.File('${recordings.path}/room-1.wav')
        .writeAsBytesSync(wavBytes(seconds: 1));
    final store = RecordedChapterStore(directory: () async => recordings);

    final container = await installTestRootContainer(
      authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
      tables: tables,
      storage: storage,
      functions: functions,
      overrides: [recordedChapterStoreProvider.overrideWithValue(store)],
    );
    await container.read(recordedChaptersRepositoryProvider).save(
          id: 'room-1',
          title: 'working title',
          description: 'rough',
          transcript: 'raw',
        );

    await container.read(createStoryProvider.notifier).updateRecordedChapter(
          chapterId: 'room-1',
          title: 'Night Shift',
          description: 'verified',
          transcript: '[00:00.000]edited',
        );

    final archived = (await store.readIndex()).single;
    expect(archived.title, 'Night Shift');
    expect(archived.description, 'verified');
    expect(archived.transcript, '[00:00.000]edited');
  });
}
