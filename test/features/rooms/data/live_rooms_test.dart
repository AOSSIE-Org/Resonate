import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/rooms/data/live_rooms.dart';
import 'package:resonate/features/rooms/data/services/room_launcher.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

Row _roomRow({
  String id = 'r1',
  String name = 'Room',
  String description = '',
  int totalParticipants = 1,
  List<String> tags = const [],
  String adminUid = 'me',
  List<String> reportedUsers = const [],
}) =>
    buildRow(
      id: id,
      tableId: roomsTableId,
      databaseId: masterDatabaseId,
      data: {
        'name': name,
        'description': description,
        'totalParticipants': totalParticipants,
        'tags': tags,
        'adminUid': adminUid,
        'reportedUsers': reportedUsers,
      },
    );

void main() {
  late MockTablesDB tables;
  late MockRealtime realtime;
  late MockFunctions functions;
  late StreamController<RealtimeMessage> roomEvents;

  setUp(() {
    stubFlutterSecureStorageChannel();
    tables = MockTablesDB();
    realtime = MockRealtime();
    functions = MockFunctions();
    roomEvents = stubRealtimeChannel(realtime);
    // Default: no participants for any room (avoids per-test boilerplate).
    when(tables.listRows(
      databaseId: masterDatabaseId,
      tableId: participantsTableId,
      queries: anyNamed('queries'),
    )).thenAnswer((_) async => RowList(total: 0, rows: []));
    when(tables.deleteRow(
      databaseId: anyNamed('databaseId'),
      tableId: anyNamed('tableId'),
      rowId: anyNamed('rowId'),
    )).thenAnswer((_) async => '');
  });

  // The live-rooms cache now lives in the data layer as a plain list (search is
  // per-view UI state handled by the browser, not the cache).
  group('LiveRooms (data-layer cache)', () {
    test('build loads rooms from the repository', () async {
      when(tables.listRows(
        databaseId: masterDatabaseId,
        tableId: roomsTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => RowList(
            total: 2,
            rows: [_roomRow(id: 'r1'), _roomRow(id: 'r2')],
          ));

      final container = await installTestRootContainer(
        authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
        tables: tables,
        realtime: realtime,
        functions: functions,
      );

      final rooms = await container.read(liveRoomsProvider.future);
      expect(rooms, hasLength(2));
    });

    test('refresh re-invokes repository load', () async {
      var callCount = 0;
      when(tables.listRows(
        databaseId: masterDatabaseId,
        tableId: roomsTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async {
        callCount++;
        return RowList(total: 0, rows: []);
      });

      final container = await installTestRootContainer(
        authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
        tables: tables,
        realtime: realtime,
        functions: functions,
      );
      await container.read(liveRoomsProvider.future);
      expect(callCount, 1);

      await container.read(liveRoomsProvider.notifier).refresh();
      expect(callCount, 2);
    });
  });

  // Without these the list only ever changed from this device: a room opened or
  // closed on someone else's phone never arrived.
  group('LiveRooms follows the rooms table', () {
    const roomsChannel =
        'databases.$masterDatabaseId.tables.$roomsTableId.rows';

    Future<ProviderContainer> openWith(List<Row> rows) async {
      when(tables.listRows(
        databaseId: masterDatabaseId,
        tableId: roomsTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => RowList(total: rows.length, rows: rows));
      // A room arriving is fetched by id, the way getRoomById does.
      when(tables.getRow(
        databaseId: masterDatabaseId,
        tableId: roomsTableId,
        rowId: anyNamed('rowId'),
      )).thenAnswer(
        (invocation) async =>
            _roomRow(id: invocation.namedArguments[#rowId] as String),
      );
      final container = await installTestRootContainer(
        authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
        tables: tables,
        realtime: realtime,
        functions: functions,
      );
      await container.read(liveRoomsProvider.future);
      return container;
    }

    // Realtime payloads are the row flattened: fields beside the $ keys.
    Future<void> emit(String action, Row row) async {
      roomEvents.add(RealtimeMessage(
        events: ['$roomsChannel.${row.$id}.$action'],
        payload: {...row.toMap()..remove('data'), ...row.data},
        channels: const [roomsChannel],
        timestamp: '',
      ));
      for (var i = 0; i < 5; i++) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    List<String> idsIn(ProviderContainer container) =>
        [for (final r in container.read(liveRoomsProvider).value!) r.id];

    test('a room opened elsewhere arrives', () async {
      final container = await openWith([_roomRow(id: 'r1')]);

      await emit('create', _roomRow(id: 'r2', name: 'New'));

      expect(idsIn(container), containsAll(['r1', 'r2']));
    });

    test('it arrives even when reported as an update', () async {
      final container = await openWith([_roomRow(id: 'r1')]);

      await emit('update', _roomRow(id: 'r2', name: 'New'));

      expect(idsIn(container), containsAll(['r1', 'r2']));
    });

    test('a room deleted elsewhere goes away', () async {
      final container = await openWith([_roomRow(id: 'r1'), _roomRow(id: 'r2')]);

      await emit('delete', _roomRow(id: 'r2'));

      expect(idsIn(container), ['r1']);
    });

    test('an update to a listed room patches it in place', () async {
      final container = await openWith([_roomRow(id: 'r1', totalParticipants: 1)]);

      await emit('update', _roomRow(id: 'r1', totalParticipants: 7));

      final rooms = container.read(liveRoomsProvider).value!;
      expect(rooms, hasLength(1));
      expect(rooms.single.totalParticipants, 7);
    });

    test('a room I reported never joins the list', () async {
      final container = await openWith([_roomRow(id: 'r1')]);

      await emit(
        'create',
        _roomRow(id: 'r2', reportedUsers: const ['me']),
      );

      expect(idsIn(container), ['r1']);
    });
  });

  // The room page pops before its teardown finishes, so the list has to be
  // corrected in the cache or it shows the room the user just left.
  group('LiveRooms optimistic removal', () {
    Future<ProviderContainer> containerWith(List<Row> rows) async {
      when(tables.listRows(
        databaseId: masterDatabaseId,
        tableId: roomsTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => RowList(total: rows.length, rows: rows));
      final container = await installTestRootContainer(
        authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
        tables: tables,
        realtime: realtime,
        functions: functions,
      );
      await container.read(liveRoomsProvider.future);
      return container;
    }

    List<String> idsIn(ProviderContainer container) => [
      for (final room in container.read(liveRoomsProvider).value!) room.id,
    ];

    test('removeLocally drops just that room', () async {
      final container = await containerWith([
        _roomRow(id: 'r1'),
        _roomRow(id: 'r2'),
      ]);

      container.read(liveRoomsProvider.notifier).removeLocally('r1');

      expect(idsIn(container), ['r2']);
    });

    test('the host leaving drops the room before it awaits anything', () async {
      final container = await containerWith([
        _roomRow(id: 'r1'),
        _roomRow(id: 'r2'),
      ]);

      // Deliberately not awaited: the page pops on the next frame, so the list
      // has to be right synchronously, not once the teardown finishes.
      final pending = container
          .read(roomLauncherProvider)
          .leave(fakeAppwriteRoom(id: 'r1', isUserAdmin: true));

      expect(idsIn(container), ['r2']);
      await pending;
      // The host leaving is what ends the room.
      verify(tables.deleteRow(
        databaseId: masterDatabaseId,
        tableId: roomsTableId,
        rowId: 'r1',
      )).called(1);
    });

    // A room outlives anyone but its host, so it stays listed; the refresh at
    // the end of leave picks up the new participant count.
    test('a listener leaving keeps the room in the list', () async {
      final container = await containerWith([
        _roomRow(id: 'r1', totalParticipants: 3),
        _roomRow(id: 'r2'),
      ]);

      await container
          .read(roomLauncherProvider)
          .leave(fakeAppwriteRoom(id: 'r1', isUserAdmin: false));

      expect(idsIn(container), ['r1', 'r2']);
      verifyNever(tables.deleteRow(
        databaseId: masterDatabaseId,
        tableId: roomsTableId,
        rowId: 'r1',
      ));
    });
  });

  group('RoomLauncher.createAndEnterLiveRoom', () {
    test('the new room joins the list without a refetch', () async {
      var roomListLoads = 0;
      when(tables.listRows(
        databaseId: masterDatabaseId,
        tableId: roomsTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async {
        roomListLoads++;
        return RowList(total: 0, rows: []);
      });
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
      when(tables.getRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
      )).thenAnswer((_) async => _roomRow(id: 'new-room'));
      when(tables.updateRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => _roomRow(id: 'new-room'));
      when(tables.incrementRowColumn(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        column: anyNamed('column'),
        value: anyNamed('value'),
      )).thenAnswer((_) async => _roomRow(id: 'new-room'));
      when(functions.createExecution(
        functionId: createRoomServiceId,
        body: anyNamed('body'),
      )).thenAnswer((_) async => _execution({
            'livekit_room': {'name': 'new-room'},
            'access_token': 'tok',
            'livekit_socket_url': 'wss://example.com',
          }));

      final container = await installTestRootContainer(
        authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
        tables: tables,
        realtime: realtime,
        functions: functions,
      );
      expect(await container.read(liveRoomsProvider.future), isEmpty);

      final created = await container
          .read(roomLauncherProvider)
          .createAndEnterLiveRoom(
            name: 'Standup',
            description: 'daily',
            tags: const ['work'],
          );

      // Minimising the sheet drops the host back here, and nothing else
      // reloads the list, so the room has to be in it already.
      final rooms = container.read(liveRoomsProvider).value;
      expect(rooms?.map((r) => r.id), contains(created.id));
      expect(rooms?.first.name, 'Standup');
      expect(roomListLoads, 1, reason: 'a refetch would race local edits');
    });
  });

  group('RoomLauncher.enterRoom', () {
    test('returns room with myDocId populated', () async {
      when(tables.deleteRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
      )).thenAnswer((_) async => '');
      when(tables.createRow(
        databaseId: masterDatabaseId,
        tableId: participantsTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenAnswer((inv) async => buildRow(
            id: 'doc-mine',
            tableId: participantsTableId,
            databaseId: masterDatabaseId,
            data: const {},
          ));
      when(tables.getRow(
        databaseId: masterDatabaseId,
        tableId: roomsTableId,
        rowId: 'r1',
      )).thenAnswer((_) async => _roomRow(id: 'r1', totalParticipants: 1));
      when(tables.updateRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => _roomRow());
      when(tables.incrementRowColumn(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        column: anyNamed('column'),
        value: anyNamed('value'),
      )).thenAnswer((_) async => _roomRow(totalParticipants: 2));
      when(tables.decrementRowColumn(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        column: anyNamed('column'),
        value: anyNamed('value'),
      )).thenAnswer((_) async => _roomRow(totalParticipants: 0));
      when(functions.createExecution(
        functionId: joinRoomServiceId,
        body: anyNamed('body'),
      )).thenAnswer((_) async => _execution({
            'access_token': 'tok',
            'livekit_socket_url': 'wss://example.com',
          }));

      final container = await installTestRootContainer(
        authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
        tables: tables,
        realtime: realtime,
        functions: functions,
      );

      final joined = await container
          .read(roomLauncherProvider)
          .enterRoom(fakeAppwriteRoom(id: 'r1', isUserAdmin: false));

      expect(joined.myDocId, 'doc-mine');
    });

    test('rethrows when the cloud function fails', () async {
      when(functions.createExecution(
        functionId: joinRoomServiceId,
        body: anyNamed('body'),
      )).thenThrow(Exception('appwrite down'));

      final container = await installTestRootContainer(
        authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
        tables: tables,
        realtime: realtime,
        functions: functions,
      );

      expect(
        () => container
            .read(roomLauncherProvider)
            .enterRoom(fakeAppwriteRoom(id: 'r1')),
        throwsA(isA<Exception>()),
      );
    });
  });
}

MockExecution _execution(Map<String, dynamic> body) {
  final json = '{'
      '"livekit_room":{"name":"r1"},'
      '"access_token":"${body['access_token']}",'
      '"livekit_socket_url":"${body['livekit_socket_url']}"'
      '}';
  final exec = MockExecution();
  when(exec.responseStatusCode).thenReturn(200);
  when(exec.responseBody).thenReturn(json);
  return exec;
}
