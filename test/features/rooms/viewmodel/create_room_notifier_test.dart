import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/rooms/viewmodel/create_room_notifier.dart';
import 'package:resonate/features/rooms/viewmodel/upcoming_rooms_notifier.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

MockExecution _execution(String json) {
  final exec = MockExecution();
  when(exec.responseStatusCode).thenReturn(200);
  when(exec.responseBody).thenReturn(json);
  return exec;
}

void main() {
  late MockTablesDB tables;
  late MockRealtime realtime;
  late MockFunctions functions;
  late MockFirebaseMessaging messaging;

  setUp(() {
    stubFlutterSecureStorageChannel();
    tables = MockTablesDB();
    realtime = MockRealtime();
    functions = MockFunctions();
    messaging = MockFirebaseMessaging();
  });

  group('CreateRoomNotifier', () {
    test('createLiveRoom returns room with myDocId on success', () async {
      when(functions.createExecution(
        functionId: createRoomServiceId,
        body: anyNamed('body'),
      )).thenAnswer((_) async => _execution(
            '{"livekit_room":{"name":"r-new"},'
            '"access_token":"tok","livekit_socket_url":"wss://example.com"}',
          ));
      when(tables.listRows(
        databaseId: masterDatabaseId,
        tableId: participantsTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => RowList(total: 0, rows: []));
      when(tables.createRow(
        databaseId: masterDatabaseId,
        tableId: participantsTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => buildRow(
            id: 'doc-mine',
            tableId: participantsTableId,
            databaseId: masterDatabaseId,
            data: const {},
          ));

      final container = await installTestRootContainer(
        authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
        tables: tables,
        realtime: realtime,
        functions: functions,
        messaging: messaging,
      );

      final room = await container
          .read(createRoomProvider.notifier)
          .createLiveRoom(
            name: 'My Room',
            description: 'desc',
            tags: const ['t1'],
          );

      expect(room, isNotNull);
      expect(room!.id, 'r-new');
      expect(room.myDocId, 'doc-mine');
      expect(room.isUserAdmin, isTrue);
      expect(container.read(createRoomProvider), isFalse);
    });

    test(
      'createScheduledRoom triggers an upcoming-rooms refresh via invalidation',
      () async {
        when(messaging.getToken()).thenAnswer((_) async => 'fcm-token');
        when(tables.createRow(
          databaseId: upcomingRoomsDatabaseId,
          tableId: upcomingRoomsTableId,
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        )).thenAnswer((_) async => buildRow(
              id: 'u-new',
              tableId: upcomingRoomsTableId,
              databaseId: upcomingRoomsDatabaseId,
              data: const {},
            ));
        // upcomingRoomsProvider.build() reads this table — count invocations
        // to confirm a refresh happened.
        var listRowsCount = 0;
        when(tables.listRows(
          databaseId: upcomingRoomsDatabaseId,
          tableId: upcomingRoomsTableId,
        )).thenAnswer((_) async {
          listRowsCount++;
          return RowList(total: 0, rows: []);
        });

        final container = await installTestRootContainer(
          authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
          tables: tables,
          realtime: realtime,
          functions: functions,
          messaging: messaging,
          getStorageBox: FakeGetStorage(),
        );
        await container.read(upcomingRoomsProvider.future);
        final initialCount = listRowsCount;

        final ok = await container
            .read(createRoomProvider.notifier)
            .createScheduledRoom(
              name: 'Later',
              description: 'desc',
              tags: const ['t1'],
              scheduledDateTime: '2026-12-31T10:00:00Z',
            );

        expect(ok, isTrue);
        // Invalidation triggers a re-fetch on the next read.
        await container.read(upcomingRoomsProvider.future);
        expect(listRowsCount, greaterThan(initialCount));
      },
    );

    test('isValidTag accepts alphanumeric and rejects symbols', () {
      expect('flutter'.isValidTag, isTrue);
      expect('flutter_dev'.isValidTag, isTrue);
      expect('flutter dev'.isValidTag, isFalse);
      expect(''.isValidTag, isFalse);
      expect(('a' * 31).isValidTag, isFalse);
    });
  });
}
