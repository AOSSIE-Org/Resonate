import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/stories/viewmodel/story_detail_notifier.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

Row _chapterRow({String id = 'c1', int playDuration = 250}) => buildRow(
      id: id,
      tableId: chapterTableId,
      databaseId: storyDatabaseId,
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

Row _likeRow({String id = 'like-1'}) => buildRow(
      id: id,
      tableId: likeTableId,
      databaseId: storyDatabaseId,
      data: {'uId': 'me', 'storyId': 's1'},
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

  // Stubs for StoryDetailNotifier tests
  void stubLoad({required bool liked, required int likes}) {
    when(tables.listRows(
      databaseId: storyDatabaseId,
      tableId: chapterTableId,
      queries: anyNamed('queries'),
    )).thenAnswer((_) async => RowList(total: 1, rows: [_chapterRow()]));
    when(tables.listRows(
      databaseId: storyDatabaseId,
      tableId: likeTableId,
      queries: anyNamed('queries'),
    )).thenAnswer((_) async =>
        RowList(total: liked ? 1 : 0, rows: liked ? [_likeRow()] : []));
    when(tables.getRow(
      databaseId: storyDatabaseId,
      tableId: storyTableId,
      rowId: 's1',
      queries: anyNamed('queries'),
    )).thenAnswer((_) async => buildRow(
          id: 's1',
          tableId: storyTableId,
          databaseId: storyDatabaseId,
          data: {'likes': likes},
        ));
    when(tables.listRows(
      databaseId: storyDatabaseId,
      tableId: liveChaptersTableId,
      queries: anyNamed('queries'),
    )).thenAnswer((_) async => RowList(total: 0, rows: []));
  }

  test('build aggregates chapters, likes and like status', () async {
    stubLoad(liked: false, likes: 3);

    final container = await install();
    final key = storyDetailProvider('s1');
    container.listen(key, (_, _) {});

    final state = await container.read(key.future);

    expect(state.chapters, hasLength(1));
    expect(state.likesCount, 3);
    expect(state.isLikedByCurrentUser, isFalse);
  });

  test('toggleLike optimistically likes then reconciles with the server',
      () async {
    stubLoad(liked: false, likes: 3);

    final container = await install();
    final key = storyDetailProvider('s1');
    container.listen(key, (_, _) {});
    await container.read(key.future);

    when(tables.createRow(
      databaseId: storyDatabaseId,
      tableId: likeTableId,
      rowId: anyNamed('rowId'),
      data: anyNamed('data'),
    )).thenAnswer((_) async => _likeRow());
    when(tables.updateRow(
      databaseId: storyDatabaseId,
      tableId: storyTableId,
      rowId: 's1',
      data: anyNamed('data'),
    )).thenAnswer((_) async => buildRow(
          id: 's1',
          tableId: storyTableId,
          databaseId: storyDatabaseId,
          data: const {},
        ));
    when(tables.getRow(
      databaseId: storyDatabaseId,
      tableId: storyTableId,
      rowId: 's1',
      queries: anyNamed('queries'),
    )).thenAnswer((_) async => buildRow(
          id: 's1',
          tableId: storyTableId,
          databaseId: storyDatabaseId,
          data: {'likes': 4},
        ));
    when(tables.listRows(
      databaseId: storyDatabaseId,
      tableId: likeTableId,
      queries: anyNamed('queries'),
    )).thenAnswer((_) async => RowList(total: 1, rows: [_likeRow()]));

    await container
        .read(key.notifier)
        .toggleLike(fakeStory(storyId: 's1', likesCount: 3));

    final state = container.read(key).value!;
    expect(state.isLikedByCurrentUser, isTrue);
    expect(state.likesCount, 4);
  });

  test('deleteStory routes through the repository delete', () async {
    stubLoad(liked: false, likes: 0);

    final container = await install();
    final key = storyDetailProvider('s1');
    container.listen(key, (_, _) {});
    await container.read(key.future);

    when(tables.listRows(
      databaseId: storyDatabaseId,
      tableId: chapterTableId,
      queries: anyNamed('queries'),
    )).thenAnswer((_) async => RowList(total: 0, rows: []));
    when(storage.deleteFile(
      bucketId: storyBucketId,
      fileId: anyNamed('fileId'),
    )).thenAnswer((_) async => null);
    when(tables.deleteRow(
      databaseId: storyDatabaseId,
      tableId: storyTableId,
      rowId: 's1',
    )).thenAnswer((_) async => '');

    await container.read(key.notifier).deleteStory(fakeStory(storyId: 's1'));

    verify(tables.deleteRow(
      databaseId: storyDatabaseId,
      tableId: storyTableId,
      rowId: 's1',
    )).called(1);
  });
}
