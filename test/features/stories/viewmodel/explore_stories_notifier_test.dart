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

  // Search was folded into ExploreStories (mentor's request), so this one VM
  // owns both the recommended list and the search results.
  group('ExploreStories', () {
    test('recommended loads stories from the repository', () async {
      when(tables.listRows(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async =>
          RowList(total: 2, rows: [_storyRow(id: 's1'), _storyRow(id: 's2')]));

      final container = await install();
      // build() kicks off the load; refresh awaits it deterministically.
      await container.read(exploreStoriesProvider.notifier).refresh();

      final recommended = container.read(exploreStoriesProvider).recommended;
      expect(recommended.value, hasLength(2));
      expect(recommended.value!.first.storyId, 's1');
    });

    test('search populates the search results with stories and users',
        () async {
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
      await container.read(exploreStoriesProvider.notifier).search('adv');

      final results = container.read(exploreStoriesProvider).searchResults;
      expect(results.stories, hasLength(1));
      expect(results.users, hasLength(1));
      expect(results.users.first.userName, 'alice');
    });

    test('clearSearch resets the search results', () async {
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
      await container.read(exploreStoriesProvider.notifier).search('adv');
      expect(
        container.read(exploreStoriesProvider).searchResults.stories,
        isNotEmpty,
      );

      container.read(exploreStoriesProvider.notifier).clearSearch();
      final results = container.read(exploreStoriesProvider).searchResults;
      expect(results.stories, isEmpty);
      expect(results.users, isEmpty);
    });
  });
}
