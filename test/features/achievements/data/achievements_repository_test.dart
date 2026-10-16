import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/achievements/data/repositories/achievements_repository.dart';
import 'package:resonate/features/achievements/model/achievement_badge.dart';
import 'package:resonate/features/achievements/model/badge_category.dart';
import 'package:resonate/features/achievements/model/user_stats.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

// Wraps an Execution mock the way Functions.execute expects to read it.
MockExecution _execution(Object body, {int status = 200}) {
  final exec = MockExecution();
  when(exec.responseStatusCode).thenReturn(status);
  when(exec.responseBody).thenReturn(body is String ? body : json.encode(body));
  return exec;
}

RowList _rowList(List<Row> rows) => RowList(total: rows.length, rows: rows);

void main() {
  late MockTablesDB tables;
  late MockFunctions functions;
  late AchievementsRepository repo;

  setUp(() {
    tables = MockTablesDB();
    functions = MockFunctions();
    repo = AchievementsRepository(tables: tables, functions: functions);
  });

  Row badgeRow({
    String? badgeId = 'host-1',
    String? category = 'hosting',
    String? metric = 'roomsHosted',
    Object? threshold = 5,
    int tier = 2,
  }) => buildRow(
    id: badgeId ?? 'row',
    tableId: achievementThresholdsTableID,
    databaseId: databaseId,
    data: {
      'badgeId': badgeId,
      'category': category,
      'metric': metric,
      'threshold': threshold,
      'tier': tier,
    },
  );

  group('loadStats', () {
    test('parses the row into UserStats', () async {
      when(
        tables.getRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenAnswer(
        (_) async => buildRow(
          id: 'uid-1',
          tableId: userStatsTableID,
          databaseId: databaseId,
          data: {
            'roomsHosted': 3,
            'roomsModerated': 1,
            'interactions': 42,
            'activeDays': 7,
            'currentStreak': 2,
            'longestStreak': 5,
            'badges': ['host-1'],
            'displayedBadges': ['host-1'],
            'avatarBadge': 'host-1',
          },
        ),
      );

      final stats = await repo.loadStats('uid-1');

      expect(stats.roomsHosted, 3);
      expect(stats.interactions, 42);
      expect(stats.longestStreak, 5);
      expect(stats.badges, ['host-1']);
      expect(stats.avatarBadge, 'host-1');
      verify(
        tables.getRow(
          databaseId: databaseId,
          tableId: userStatsTableID,
          rowId: 'uid-1',
        ),
      ).called(1);
    });

    // A user with no stats row yet is the normal first-run case, not an error.
    test('falls back to empty stats when the row is missing', () async {
      when(
        tables.getRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenThrow(AppwriteException('not found', 404));

      expect(await repo.loadStats('ghost'), UserStats.empty);
    });
  });

  group('loadCatalogue', () {
    test('parses the rows it is given', () async {
      when(
        tables.listRows(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => _rowList([badgeRow()]));

      final badges = await repo.loadCatalogue();

      expect(badges, hasLength(1));
      expect(badges.single.id, 'host-1');
      expect(badges.single.category, BadgeCategory.hosting);
      expect(badges.single.metric, BadgeMetric.roomsHosted);
      expect(badges.single.threshold, 5);
      expect(badges.single.tier, 2);
    });

    // fromMap returns null for these; .nonNulls must drop them rather than throw.
    test('drops malformed rows', () async {
      when(
        tables.listRows(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => _rowList([
          badgeRow(),
          badgeRow(badgeId: null),
          badgeRow(badgeId: 'bad-category', category: 'nonsense'),
          badgeRow(badgeId: 'bad-metric', metric: 'nonsense'),
          badgeRow(badgeId: 'bad-threshold', threshold: 'ten'),
        ]),
      );

      final badges = await repo.loadCatalogue();

      expect(badges.map((b) => b.id), ['host-1']);
    });

    test(
      'falls back to the bundled catalogue when the table is empty',
      () async {
        when(
          tables.listRows(
            databaseId: anyNamed('databaseId'),
            tableId: anyNamed('tableId'),
            queries: anyNamed('queries'),
          ),
        ).thenAnswer((_) async => _rowList([]));

        expect(await repo.loadCatalogue(), kDefaultBadges);
      },
    );

    test('falls back to the bundled catalogue when the lookup fails', () async {
      when(
        tables.listRows(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          queries: anyNamed('queries'),
        ),
      ).thenThrow(AppwriteException('offline'));

      expect(await repo.loadCatalogue(), kDefaultBadges);
    });
  });

  group('recordActivity', () {
    test('sends the activity action and parses the result', () async {
      when(
        functions.createExecution(
          functionId: anyNamed('functionId'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => _execution({
          'stats': {
            'roomsHosted': 2,
            'badges': ['host-1'],
          },
          'newBadges': ['host-1'],
        }),
      );

      final result = await repo.recordActivity(interactions: 3);

      expect(result.stats.roomsHosted, 2);
      expect(result.newBadges, ['host-1']);

      final sent =
          verify(
                functions.createExecution(
                  functionId: recordActivityFunctionID,
                  body: captureAnyNamed('body'),
                ),
              ).captured.single
              as String;
      expect(json.decode(sent), {'action': 'activity', 'interactions': 3});
    });

    // `interactions` is only meaningful when positive — the function treats
    // its absence as "just mark the day active".
    test('omits interactions when none are reported', () async {
      when(
        functions.createExecution(
          functionId: anyNamed('functionId'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => _execution({'stats': <String, dynamic>{}}));

      await repo.recordActivity();

      final sent =
          verify(
                functions.createExecution(
                  functionId: anyNamed('functionId'),
                  body: captureAnyNamed('body'),
                ),
              ).captured.single
              as String;
      expect(json.decode(sent), {'action': 'activity'});
    });
  });

  test('recordRoomCredit sends the room id', () async {
    when(
      functions.createExecution(
        functionId: anyNamed('functionId'),
        body: anyNamed('body'),
      ),
    ).thenAnswer((_) async => _execution({'stats': <String, dynamic>{}}));

    await repo.recordRoomCredit('room-9');

    final sent =
        verify(
              functions.createExecution(
                functionId: recordActivityFunctionID,
                body: captureAnyNamed('body'),
              ),
            ).captured.single
            as String;
    expect(json.decode(sent), {'action': 'roomCredit', 'roomId': 'room-9'});
  });

  test('setShowcase sends the displayed badges and avatar badge', () async {
    when(
      functions.createExecution(
        functionId: anyNamed('functionId'),
        body: anyNamed('body'),
      ),
    ).thenAnswer((_) async => _execution({'stats': <String, dynamic>{}}));

    await repo.setShowcase(
      displayedBadges: ['host-1', 'mod-1'],
      avatarBadge: null,
    );

    final sent =
        verify(
              functions.createExecution(
                functionId: recordActivityFunctionID,
                body: captureAnyNamed('body'),
              ),
            ).captured.single
            as String;
    expect(json.decode(sent), {
      'action': 'display',
      'displayedBadges': ['host-1', 'mod-1'],
      'avatarBadge': null,
    });
  });

  group('malformed function responses', () {
    test('a missing stats block yields empty stats', () async {
      when(
        functions.createExecution(
          functionId: anyNamed('functionId'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => _execution({
          'newBadges': ['host-1'],
        }),
      );

      final result = await repo.recordActivity();

      expect(result.stats, UserStats.empty);
      expect(result.newBadges, ['host-1']);
    });

    test('a non-map stats block yields empty stats', () async {
      when(
        functions.createExecution(
          functionId: anyNamed('functionId'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => _execution({'stats': 'nope'}));

      expect((await repo.recordActivity()).stats, UserStats.empty);
    });

    test('a missing newBadges list yields no new badges', () async {
      when(
        functions.createExecution(
          functionId: anyNamed('functionId'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => _execution({
          'stats': {'roomsHosted': 1},
        }),
      );

      final result = await repo.recordActivity();

      expect(result.stats.roomsHosted, 1);
      expect(result.newBadges, isEmpty);
    });

    // Non-string entries would otherwise crash the showcase UI downstream.
    test('non-string newBadges entries are dropped', () async {
      when(
        functions.createExecution(
          functionId: anyNamed('functionId'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => _execution({
          'stats': <String, dynamic>{},
          'newBadges': ['host-1', 7, null],
        }),
      );

      expect((await repo.recordActivity()).newBadges, ['host-1']);
    });

    test('a non-200 response surfaces as a thrown exception', () async {
      when(
        functions.createExecution(
          functionId: anyNamed('functionId'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => _execution('boom', status: 500));

      expect(repo.recordActivity(), throwsA(isA<Exception>()));
    });
  });
}
