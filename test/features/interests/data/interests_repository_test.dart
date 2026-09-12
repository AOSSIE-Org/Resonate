import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/interests/data/repositories/interests_repository.dart';
import 'package:resonate/features/interests/model/interest.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

Row userRow({required String id, Object? interests, Object? rating}) =>
    buildRow(
      id: id,
      tableId: usersTableID,
      databaseId: userDatabaseID,
      data: {
        'name': 'Person $id',
        'username': id,
        'profileImageUrl': 'https://example.com/$id.jpg',
        'interests': interests,
        'ratingTotal': rating ?? 8.0,
        'ratingCount': 2,
      },
    );

void main() {
  late MockTablesDB tables;
  late InterestsRepository repo;

  setUp(() {
    tables = MockTablesDB();
    repo = InterestsRepository(tables: tables);
  });

  group('loadInterests', () {
    test('maps the stored wire values and selects only what it needs', () async {
      when(
        tables.getRow(
          databaseId: userDatabaseID,
          tableId: usersTableID,
          rowId: 'u1',
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => userRow(id: 'u1', interests: ['music', 'ai']),
      );

      expect(await repo.loadInterests('u1'), [Interest.music, Interest.ai]);

      final queries =
          verify(
                tables.getRow(
                  databaseId: userDatabaseID,
                  tableId: usersTableID,
                  rowId: 'u1',
                  queries: captureAnyNamed('queries'),
                ),
              ).captured.single
              as List<String>;
      expect(queries, [
        Query.select([r'$id', 'interests']),
      ]);
    });

    test('reads an unwritten column as no interests', () async {
      when(
        tables.getRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => userRow(id: 'u1'));

      expect(await repo.loadInterests('u1'), isEmpty);
    });
  });

  test('setInterests writes the wire values to the user row', () async {
    when(
      tables.updateRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      ),
    ).thenAnswer((_) async => userRow(id: 'u1'));

    await repo.setInterests(
      uid: 'u1',
      interests: [Interest.fitness, Interest.anime],
    );

    final data =
        verify(
              tables.updateRow(
                databaseId: userDatabaseID,
                tableId: usersTableID,
                rowId: 'u1',
                data: captureAnyNamed('data'),
              ),
            ).captured.single
            as Map;
    expect(data, {
      'interests': ['fitness', 'anime'],
    });
  });

  group('usersWithInterests', () {
    test('does not hit the network for an empty selection', () async {
      expect(await repo.usersWithInterests(const {}), isEmpty);

      verifyNever(
        tables.listRows(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          queries: anyNamed('queries'),
        ),
      );
    });

    test('matches any of the selected interests and skips the caller', () async {
      when(
        tables.listRows(
          databaseId: userDatabaseID,
          tableId: usersTableID,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 1,
          rows: [
            userRow(id: 'u2', interests: ['music', 'gaming']),
          ],
        ),
      );

      final users = await repo.usersWithInterests(
        {Interest.music, Interest.ai},
        excludeUid: 'me',
      );

      expect(users, hasLength(1));
      expect(users.single.uid, 'u2');
      expect(users.single.userName, 'u2');
      expect(users.single.interests, ['music', 'gaming']);
      // ratingTotal / ratingCount
      expect(users.single.userRating, 4.0);

      final queries =
          verify(
                tables.listRows(
                  databaseId: userDatabaseID,
                  tableId: usersTableID,
                  queries: captureAnyNamed('queries'),
                ),
              ).captured.single
              as List<String>;
      expect(queries, [
        Query.contains('interests', ['music', 'ai']),
        Query.notEqual(r'$id', 'me'),
        Query.limit(InterestsRepository.matchPageSize),
      ]);
    });

    test('omits the exclusion when there is no signed-in uid', () async {
      when(
        tables.listRows(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => RowList(total: 0, rows: []));

      await repo.usersWithInterests({Interest.music}, limit: 3);

      final queries =
          verify(
                tables.listRows(
                  databaseId: anyNamed('databaseId'),
                  tableId: anyNamed('tableId'),
                  queries: captureAnyNamed('queries'),
                ),
              ).captured.single
              as List<String>;
      expect(queries, [
        Query.contains('interests', ['music']),
        Query.limit(3),
      ]);
    });
  });
}
