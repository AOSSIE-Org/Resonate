import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/stories/viewmodel/explore_stories_notifier.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

Row _storyRow({String id = 's1', String creatorId = 'creator-1'}) => buildRow(
      id: id,
      tableId: storyTableId,
      databaseId: storyDatabaseId,
      data: {
        'title': 'Story $id',
        'description': 'desc',
        'category': 'drama',
        'creatorId': creatorId,
        'creatorName': 'Creator',
        'creatorImgUrl': 'https://example.com/a.jpg',
        'coverImgUrl': 'https://example.com/c.jpg',
        'likes': 0,
        'playDuration': 1000,
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

  test('build returns recommended stories from the repository', () async {
    when(tables.listRows(
      databaseId: storyDatabaseId,
      tableId: storyTableId,
      queries: anyNamed('queries'),
    )).thenAnswer((_) async =>
        RowList(total: 2, rows: [_storyRow(id: 's1'), _storyRow(id: 's2')]));

    final container = await install();
    final stories = await container.read(exploreStoriesProvider.future);

    expect(stories, hasLength(2));
    expect(stories.first.storyId, 's1');
  });

  test('refresh re-invokes the repository load', () async {
    var count = 0;
    when(tables.listRows(
      databaseId: storyDatabaseId,
      tableId: storyTableId,
      queries: anyNamed('queries'),
    )).thenAnswer((_) async {
      count++;
      return RowList(total: 0, rows: []);
    });

    final container = await install();
    await container.read(exploreStoriesProvider.future);
    expect(count, 1);

    await container.read(exploreStoriesProvider.notifier).refresh();
    expect(count, 2);
  });
}
