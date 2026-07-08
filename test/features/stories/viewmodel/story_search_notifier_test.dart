import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/stories/viewmodel/story_search_notifier.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

Row _storyRow({String id = 's1'}) => buildRow(
      id: id,
      tableId: storyTableId,
      databaseId: storyDatabaseId,
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
      },
    );

Row _userRow({String id = 'u1'}) => buildRow(
      id: id,
      tableId: usersTableID,
      databaseId: userDatabaseID,
      data: {
        'name': 'Alice',
        'username': 'alice',
        'profileImageUrl': 'https://example.com/u.jpg',
        'ratingCount': 1,
        'ratingTotal': 4,
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

  test('search populates stories and users', () async {
    when(tables.listRows(
      databaseId: storyDatabaseId,
      tableId: storyTableId,
      queries: anyNamed('queries'),
    )).thenAnswer((_) async => RowList(total: 1, rows: [_storyRow()]));
    when(tables.listRows(
      databaseId: userDatabaseID,
      tableId: usersTableID,
      queries: anyNamed('queries'),
    )).thenAnswer((_) async => RowList(total: 1, rows: [_userRow()]));

    final container = await install();
    container.listen(storySearchProvider, (_, _) {});

    await container.read(storySearchProvider.notifier).search('adv');

    final state = container.read(storySearchProvider);
    expect(state.stories, hasLength(1));
    expect(state.users, hasLength(1));
    expect(state.users.first.userName, 'alice');
  });

  test('clear resets the search state', () async {
    when(tables.listRows(
      databaseId: storyDatabaseId,
      tableId: storyTableId,
      queries: anyNamed('queries'),
    )).thenAnswer((_) async => RowList(total: 1, rows: [_storyRow()]));
    when(tables.listRows(
      databaseId: userDatabaseID,
      tableId: usersTableID,
      queries: anyNamed('queries'),
    )).thenAnswer((_) async => RowList(total: 0, rows: []));

    final container = await install();
    container.listen(storySearchProvider, (_, _) {});

    await container.read(storySearchProvider.notifier).search('adv');
    expect(container.read(storySearchProvider).stories, isNotEmpty);

    container.read(storySearchProvider.notifier).clear();
    expect(container.read(storySearchProvider).stories, isEmpty);
    expect(container.read(storySearchProvider).users, isEmpty);
  });
}
