import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/rooms/model/rooms_state.dart';
import 'package:resonate/features/rooms/viewmodel/rooms_notifier.dart';
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

  setUp(() {
    tables = MockTablesDB();
    realtime = MockRealtime();
    functions = MockFunctions();
    // Default: no participants for any room (avoids per-test boilerplate).
    when(tables.listRows(
      databaseId: masterDatabaseId,
      tableId: participantsTableId,
      queries: anyNamed('queries'),
    )).thenAnswer((_) async => RowList(total: 0, rows: []));
  });

  group('RoomsNotifier', () {
    test('build loads rooms from the repository', () async {
      when(tables.listRows(
        databaseId: masterDatabaseId,
        tableId: roomsTableId,
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

      final state = await container.read(roomsProvider.future);

      expect(state, isA<RoomsStateReady>());
      expect((state as RoomsStateReady).rooms, hasLength(2));
    });

    test('joinRoom returns room with myDocId populated', () async {
      when(tables.listRows(
        databaseId: masterDatabaseId,
        tableId: roomsTableId,
      )).thenAnswer((_) async => RowList(total: 0, rows: []));
      // joinRoom internally calls the cloud function + addParticipant.
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
      // The cloud-function call from ApiService.joinRoom.
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
      await container.read(roomsProvider.future);

      final joined = await container
          .read(roomsProvider.notifier)
          .joinRoom(fakeAppwriteRoom(id: 'r1', isUserAdmin: false));

      expect(joined.myDocId, 'doc-mine');
    });

    test('refresh re-invokes repository load', () async {
      var callCount = 0;
      when(tables.listRows(
        databaseId: masterDatabaseId,
        tableId: roomsTableId,
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
      await container.read(roomsProvider.future);
      expect(callCount, 1);

      await container.read(roomsProvider.notifier).refresh();
      expect(callCount, 2);
    });

    test('joinRoom rethrows when the cloud function fails', () async {
      when(tables.listRows(
        databaseId: masterDatabaseId,
        tableId: roomsTableId,
      )).thenAnswer((_) async => RowList(total: 0, rows: []));
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
      await container.read(roomsProvider.future);

      expect(
        () => container
            .read(roomsProvider.notifier)
            .joinRoom(fakeAppwriteRoom(id: 'r1')),
        throwsA(isA<Exception>()),
      );
    });

    test('searchLiveRooms filters loaded rooms by name', () async {
      when(tables.listRows(
        databaseId: masterDatabaseId,
        tableId: roomsTableId,
      )).thenAnswer((_) async => RowList(
            total: 2,
            rows: [
              _roomRow(id: 'r1', name: 'Flutter Devs'),
              _roomRow(id: 'r2', name: 'Backend Talk'),
            ],
          ));

      final container = await installTestRootContainer(
        authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
        tables: tables,
        realtime: realtime,
        functions: functions,
      );
      await container.read(roomsProvider.future);

      container.read(roomsProvider.notifier).searchLiveRooms('flutter');

      final ready = container.read(roomsProvider).value! as RoomsStateReady;
      expect(ready.isSearching, isTrue);
      expect(ready.filteredRooms, hasLength(1));
      expect(ready.filteredRooms.first.name, 'Flutter Devs');
    });

    test('clearLiveSearch resets filter state', () async {
      when(tables.listRows(
        databaseId: masterDatabaseId,
        tableId: roomsTableId,
      )).thenAnswer((_) async => RowList(total: 0, rows: []));

      final container = await installTestRootContainer(
        authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
        tables: tables,
        realtime: realtime,
        functions: functions,
      );
      await container.read(roomsProvider.future);

      container.read(roomsProvider.notifier).searchLiveRooms('hello');
      container.read(roomsProvider.notifier).clearLiveSearch();

      final ready = container.read(roomsProvider).value! as RoomsStateReady;
      expect(ready.isSearching, isFalse);
      expect(ready.searchBarIsEmpty, isTrue);
      expect(ready.filteredRooms, isEmpty);
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
