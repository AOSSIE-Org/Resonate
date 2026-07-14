import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/rooms/data/upcoming_rooms.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

Row _upcomingRow({
  String id = 'u1',
  String name = 'Upcoming',
  bool isTime = false,
  String description = '',
  String creatorUid = 'me',
  List<String> tags = const [],
}) =>
    buildRow(
      id: id,
      tableId: upcomingRoomsTableId,
      databaseId: upcomingRoomsDatabaseId,
      data: {
        'name': name,
        'isTime': isTime,
        'scheduledDateTime': DateTime.now().toUtc().toIso8601String(),
        'description': description,
        'creatorUid': creatorUid,
        'tags': tags,
      },
    );

void main() {
  late MockTablesDB tables;
  late MockFirebaseMessaging messaging;

  setUp(() {
    tables = MockTablesDB();
    messaging = MockFirebaseMessaging();
    when(messaging.getToken()).thenAnswer((_) async => 'fcm-token');
    // Default: no subscribers for any upcoming room.
    when(tables.listRows(
      databaseId: upcomingRoomsDatabaseId,
      tableId: subscribedUserTableId,
      queries: anyNamed('queries'),
    )).thenAnswer((_) async => RowList(total: 0, rows: []));
  });

  Future<dynamic> installWith({
    required List<Row> upcomingRows,
    FakeGetStorage? storage,
  }) {
    when(tables.listRows(
      databaseId: upcomingRoomsDatabaseId,
      tableId: upcomingRoomsTableId,
    )).thenAnswer((_) async => RowList(total: upcomingRows.length, rows: upcomingRows));

    return installTestRootContainer(
      authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
      tables: tables,
      messaging: messaging,
      getStorageBox: storage ?? FakeGetStorage(),
    );
  }

  group('UpcomingRoomsNotifier', () {
    test('build loads and hydrates upcoming rooms from the repo', () async {
      final container = await installWith(
        upcomingRows: [
          _upcomingRow(id: 'u1', name: 'Morning sync'),
          _upcomingRow(id: 'u2', name: 'Demo'),
        ],
      );

      final rooms = await container.read(upcomingRoomsProvider.future);

      expect(rooms, hasLength(2));
      expect(rooms.map((r) => r.id), ['u1', 'u2']);
    });

    test('subscribe calls repo.addSubscriber and refreshes', () async {
      final container = await installWith(
        upcomingRows: [_upcomingRow(id: 'u1')],
      );
      await container.read(upcomingRoomsProvider.future);
      clearInteractions(tables);

      when(tables.createRow(
        databaseId: upcomingRoomsDatabaseId,
        tableId: subscribedUserTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => buildRow(
            id: 's-new',
            tableId: subscribedUserTableId,
            databaseId: upcomingRoomsDatabaseId,
            data: const {},
          ));
      when(tables.listRows(
        databaseId: upcomingRoomsDatabaseId,
        tableId: upcomingRoomsTableId,
      )).thenAnswer((_) async => RowList(total: 0, rows: []));

      await container.read(upcomingRoomsProvider.notifier).subscribe('u1');

      verify(tables.createRow(
        databaseId: upcomingRoomsDatabaseId,
        tableId: subscribedUserTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).called(1);
    });

    test('unsubscribe calls repo.removeSubscriber and refreshes', () async {
      final container = await installWith(
        upcomingRows: [_upcomingRow(id: 'u1')],
      );
      await container.read(upcomingRoomsProvider.future);
      clearInteractions(tables);

      // The repo's removeSubscriber first lists rows to find the subscription.
      when(tables.listRows(
        databaseId: upcomingRoomsDatabaseId,
        tableId: subscribedUserTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => RowList(
            total: 1,
            rows: [
              buildRow(
                id: 'sub-doc-1',
                tableId: subscribedUserTableId,
                databaseId: upcomingRoomsDatabaseId,
                data: const {'userID': 'me', 'upcomingRoomId': 'u1'},
              ),
            ],
          ));
      when(tables.listRows(
        databaseId: upcomingRoomsDatabaseId,
        tableId: upcomingRoomsTableId,
      )).thenAnswer((_) async => RowList(total: 0, rows: []));
      when(tables.deleteRow(
        databaseId: upcomingRoomsDatabaseId,
        tableId: subscribedUserTableId,
        rowId: 'sub-doc-1',
      )).thenAnswer((_) async => '');

      await container.read(upcomingRoomsProvider.notifier).unsubscribe('u1');

      verify(tables.deleteRow(
        databaseId: upcomingRoomsDatabaseId,
        tableId: subscribedUserTableId,
        rowId: 'sub-doc-1',
      )).called(1);
    });

    test('deleteUpcoming deletes the row + its subscribers', () async {
      final container = await installWith(
        upcomingRows: [_upcomingRow(id: 'u1')],
      );
      await container.read(upcomingRoomsProvider.future);
      clearInteractions(tables);

      when(tables.deleteRow(
        databaseId: upcomingRoomsDatabaseId,
        tableId: upcomingRoomsTableId,
        rowId: 'u1',
      )).thenAnswer((_) async => '');
      when(tables.listRows(
        databaseId: upcomingRoomsDatabaseId,
        tableId: subscribedUserTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => RowList(total: 0, rows: []));
      when(tables.listRows(
        databaseId: upcomingRoomsDatabaseId,
        tableId: upcomingRoomsTableId,
      )).thenAnswer((_) async => RowList(total: 0, rows: []));

      await container
          .read(upcomingRoomsProvider.notifier)
          .deleteUpcoming('u1');

      verify(tables.deleteRow(
        databaseId: upcomingRoomsDatabaseId,
        tableId: upcomingRoomsTableId,
        rowId: 'u1',
      )).called(1);
    });

    test('hideLocally persists to storage and filters out from state', () async {
      final storage = FakeGetStorage();
      final container = await installWith(
        upcomingRows: [_upcomingRow(id: 'u1'), _upcomingRow(id: 'u2')],
        storage: storage,
      );
      await container.read(upcomingRoomsProvider.future);

      await container.read(upcomingRoomsProvider.notifier).hideLocally('u1');

      final visible = container.read(upcomingRoomsProvider).value!;
      expect(visible.map((r) => r.id), ['u2']);
      expect(storage.read<List>('removed_upcoming_rooms'), ['u1']);
    });
  });
}
