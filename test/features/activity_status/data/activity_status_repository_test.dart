import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/activity_status/data/repositories/activity_status_repository.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/activity_status.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

Row userRow({required String id, String? status}) => buildRow(
  id: id,
  tableId: usersTableID,
  databaseId: userDatabaseID,
  data: {'status': status},
);

void main() {
  late MockTablesDB tables;
  late MockRealtime realtime;
  late ActivityStatusRepository repo;

  setUp(() {
    tables = MockTablesDB();
    realtime = MockRealtime();
    repo = ActivityStatusRepository(tables: tables, realtime: realtime);
  });

  group('loadStatus', () {
    test('maps the stored wire value onto the enum', () async {
      when(
        tables.getRow(
          databaseId: userDatabaseID,
          tableId: usersTableID,
          rowId: 'u1',
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => userRow(id: 'u1', status: 'dnd'));

      expect(await repo.loadStatus('u1'), ActivityStatus.dnd);

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
        Query.select([r'$id', 'status']),
      ]);
    });

    test('returns null when the attribute is absent', () async {
      when(
        tables.getRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => userRow(id: 'u1'));

      expect(await repo.loadStatus('u1'), isNull);
    });

    test('returns null for a value this build does not know', () async {
      when(
        tables.getRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => userRow(id: 'u1', status: 'astral-projecting'));

      expect(await repo.loadStatus('u1'), isNull);
    });
  });

  group('loadStatuses', () {
    test('returns an empty map without querying for no uids', () async {
      expect(await repo.loadStatuses({}), isEmpty);
      verifyNever(
        tables.listRows(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          queries: anyNamed('queries'),
        ),
      );
    });

    test('keys statuses by uid and drops rows with no status', () async {
      when(
        tables.listRows(
          databaseId: userDatabaseID,
          tableId: usersTableID,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 3,
          rows: [
            userRow(id: 'u1', status: 'online'),
            userRow(id: 'u2', status: 'inroom'),
            userRow(id: 'u3'),
          ],
        ),
      );

      final statuses = await repo.loadStatuses({'u1', 'u2', 'u3'});

      expect(statuses, {
        'u1': ActivityStatus.online,
        'u2': ActivityStatus.inRoom,
      });

      final queries =
          verify(
                tables.listRows(
                  databaseId: userDatabaseID,
                  tableId: usersTableID,
                  queries: captureAnyNamed('queries'),
                ),
              ).captured.single
              as List<String>;
      expect(queries.length, 3);
      expect(queries[1], Query.select([r'$id', 'status']));
      expect(queries[2], Query.limit(3));
    });

    test('chunks requests at 100 uids', () async {
      final uids = {for (var i = 0; i < 250; i++) 'u$i'};
      when(
        tables.listRows(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => RowList(total: 0, rows: []));

      await repo.loadStatuses(uids);

      final captured = verify(
        tables.listRows(
          databaseId: userDatabaseID,
          tableId: usersTableID,
          queries: captureAnyNamed('queries'),
        ),
      ).captured;
      expect(captured, hasLength(3));
      expect(captured[0][2], Query.limit(100));
      expect(captured[1][2], Query.limit(100));
      expect(captured[2][2], Query.limit(50));
    });
  });

  group('setStatus', () {
    test('writes only the status attribute', () async {
      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => userRow(id: 'me', status: 'dnd'));

      await repo.setStatus(uid: 'me', status: ActivityStatus.dnd);

      verify(
        tables.updateRow(
          databaseId: userDatabaseID,
          tableId: usersTableID,
          rowId: 'me',
          data: {'status': 'dnd'},
        ),
      ).called(1);
    });
  });

  group('activityStatusStream', () {
    late MockRealtimeSubscription sub;
    late StreamController<RealtimeMessage> controller;
    late String channel;
    late int closeCalls;

    setUp(() {
      sub = MockRealtimeSubscription();
      controller = StreamController<RealtimeMessage>.broadcast();
      channel = 'databases.$userDatabaseID.tables.$usersTableID.rows';
      closeCalls = 0;
      when(realtime.subscribe([channel])).thenReturn(sub);
      when(sub.stream).thenAnswer((_) => controller.stream);
      when(sub.close).thenReturn(() async {
        closeCalls++;
      });
    });

    tearDown(() => controller.close());

    RealtimeMessage event({
      required String uid,
      String action = 'update',
      Map<String, dynamic>? payload,
    }) => RealtimeMessage(
      events: [
        // Both channel forms, collections first — the shape the server
        // actually sends and the reason realtimeAction exists.
        'databases.$userDatabaseID.collections.$usersTableID.documents.$uid.$action',
        '$channel.$uid.$action',
      ],
      payload: payload ?? {r'$id': uid, 'status': 'dnd'},
      channels: [channel],
      timestamp: DateTime.now().toIso8601String(),
    );

    test('emits uid and status for an update', () async {
      final seen = <({String uid, ActivityStatus status})>[];
      final streamSub = repo.activityStatusStream().listen(seen.add);

      controller.add(event(uid: 'u1'));
      await pumpEventQueue();

      expect(seen, hasLength(1));
      expect(seen.single.uid, 'u1');
      expect(seen.single.status, ActivityStatus.dnd);

      await streamSub.cancel();
    });

    test('ignores creates and deletes', () async {
      final seen = <({String uid, ActivityStatus status})>[];
      final streamSub = repo.activityStatusStream().listen(seen.add);

      controller.add(event(uid: 'u1', action: 'create'));
      controller.add(event(uid: 'u2', action: 'delete'));
      await pumpEventQueue();

      expect(seen, isEmpty);
      await streamSub.cancel();
    });

    test('skips events with no parseable status', () async {
      final seen = <({String uid, ActivityStatus status})>[];
      final streamSub = repo.activityStatusStream().listen(seen.add);

      controller.add(
        event(uid: 'u1', payload: {r'$id': 'u1', 'status': 'nonsense'}),
      );
      controller.add(event(uid: 'u2', payload: {r'$id': 'u2'}));
      controller.add(event(uid: 'u3', payload: {'status': 'online'}));
      await pumpEventQueue();

      expect(seen, isEmpty);
      await streamSub.cancel();
    });

    test('cancelling the stream closes the realtime subscription', () async {
      final streamSub = repo.activityStatusStream().listen((_) {});
      await streamSub.cancel();
      expect(closeCalls, 1);
    });
  });
}
