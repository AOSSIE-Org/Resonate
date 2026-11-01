import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/rooms/data/repositories/rooms_repository.dart';
import 'package:resonate/features/rooms/model/room_failure.dart';
import 'package:resonate/core/services/room_join_service.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.dart';
import 'rooms_repository_test.mocks.dart';

@GenerateMocks([TablesDB, Realtime, Functions])
Row roomRow({
  String id = 'room-1',
  String name = 'Sample Room',
  String description = 'A nice room',
  String adminUid = 'admin-uid',
  int totalParticipants = 3,
  List<String> tags = const ['tag1', 'tag2'],
  List<String> reportedUsers = const [],
}) {
  return Row(
    $id: id,
    $sequence: 0,
    $tableId: roomsTableId,
    $databaseId: databaseId,
    $createdAt: DateTime.now().toIso8601String(),
    $updatedAt: DateTime.now().toIso8601String(),
    $permissions: const [],
    data: {
      'name': name,
      'description': description,
      'totalParticipants': totalParticipants,
      'tags': tags,
      'adminUid': adminUid,
      'reportedUsers': reportedUsers,
    },
  );
}

Row userRow({
  String id = 'user-1',
  String name = 'A User',
  String email = 'u@test.com',
  String profileImageUrl = 'https://example.com/u.jpg',
}) {
  return Row(
    $id: id,
    $sequence: 0,
    $tableId: usersTableID,
    $databaseId: databaseId,
    $createdAt: DateTime.now().toIso8601String(),
    $updatedAt: DateTime.now().toIso8601String(),
    $permissions: const [],
    data: {
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
    },
  );
}

Row participantRow({
  String id = 'p-1',
  String uid = 'user-1',
  String roomId = 'room-1',
  bool isAdmin = false,
  bool isMicOn = false,
  bool isModerator = false,
  bool isSpeaker = false,
}) {
  return Row(
    $id: id,
    $sequence: 0,
    $tableId: participantsTableId,
    $databaseId: databaseId,
    $createdAt: DateTime.now().toIso8601String(),
    $updatedAt: DateTime.now().toIso8601String(),
    $permissions: const [],
    data: {
      'roomId': roomId,
      'uid': uid,
      'isAdmin': isAdmin,
      'isMicOn': isMicOn,
      'isModerator': isModerator,
      'isSpeaker': isSpeaker,
    },
  );
}

void main() {
  late MockTablesDB tables;
  late MockRealtime realtime;
  late MockFunctions functions;
  late RoomsRepository repo;

  setUp(() {
    tables = MockTablesDB();
    realtime = MockRealtime();
    functions = MockFunctions();
    repo = RoomsRepository(
      tables: tables,
      realtime: realtime,
      functions: functions,
      roomJoin: RoomJoinService(functions: functions),
    );
  });

  group('loadRooms', () {
    test('returns rooms and filters out reported users', () async {
      when(
        tables.listRows(
          databaseId: databaseId,
          tableId: roomsTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 2,
          rows: [
            roomRow(id: 'r1', name: 'Visible'),
            roomRow(
              id: 'r2',
              name: 'Reported',
              reportedUsers: const ['admin-uid'],
            ),
          ],
        ),
      );
      when(
        tables.listRows(
          databaseId: databaseId,
          tableId: participantsTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => RowList(total: 0, rows: []));

      final rooms = await repo.loadRooms('admin-uid');

      expect(rooms, hasLength(1));
      expect(rooms.first.id, 'r1');
      expect(rooms.first.isUserAdmin, isTrue);
    });

    test('resolves participants and avatars in one query each, however many '
        'rooms there are', () async {
      when(
        tables.listRows(
          databaseId: databaseId,
          tableId: roomsTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 3,
          rows: [roomRow(id: 'r1'), roomRow(id: 'r2'), roomRow(id: 'r3')],
        ),
      );
      when(
        tables.listRows(
          databaseId: databaseId,
          tableId: participantsTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 2,
          rows: [
            participantRow(id: 'p1', uid: 'user-1', roomId: 'r1'),
            participantRow(id: 'p2', uid: 'user-2', roomId: 'r3'),
          ],
        ),
      );
      when(
        tables.listRows(
          databaseId: databaseId,
          tableId: usersTableID,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 2,
          rows: [userRow(id: 'user-1'), userRow(id: 'user-2')],
        ),
      );

      final rooms = await repo.loadRooms('admin-uid');

      expect(rooms, hasLength(3));
      verify(
        tables.listRows(
          databaseId: databaseId,
          tableId: participantsTableId,
          queries: anyNamed('queries'),
        ),
      ).called(1);
      verify(
        tables.listRows(
          databaseId: databaseId,
          tableId: usersTableID,
          queries: anyNamed('queries'),
        ),
      ).called(1);
      // The per-participant user read is what this replaced.
      verifyNever(
        tables.getRow(
          databaseId: databaseId,
          tableId: usersTableID,
          rowId: anyNamed('rowId'),
        ),
      );
      // Avatars still land on the room their participant belongs to.
      expect(rooms[0].memberAvatarUrls, hasLength(1));
      expect(rooms[1].memberAvatarUrls, isEmpty);
      expect(rooms[2].memberAvatarUrls, hasLength(1));
    });

    test('asks the participants query for every room id at once', () async {
      when(
        tables.listRows(
          databaseId: databaseId,
          tableId: roomsTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async =>
            RowList(total: 2, rows: [roomRow(id: 'r1'), roomRow(id: 'r2')]),
      );
      when(
        tables.listRows(
          databaseId: databaseId,
          tableId: participantsTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => RowList(total: 0, rows: []));

      await repo.loadRooms('admin-uid');

      final queries =
          verify(
                tables.listRows(
                  databaseId: databaseId,
                  tableId: participantsTableId,
                  queries: captureAnyNamed('queries'),
                ),
              ).captured.single
              as List<String>;
      expect(queries, contains(Query.equal('roomId', ['r1', 'r2'])));
      expect(queries, contains(Query.select(['roomId', 'uid'])));
    });
  });

  group('getRoomById', () {
    test('returns null on 404', () async {
      when(
        tables.getRow(
          databaseId: databaseId,
          tableId: roomsTableId,
          rowId: 'missing',
        ),
      ).thenThrow(AppwriteException('not found', 404));

      final result = await repo.getRoomById('missing', 'u1');
      expect(result, isNull);
    });

    test('builds AppwriteRoom on success', () async {
      when(
        tables.getRow(
          databaseId: databaseId,
          tableId: roomsTableId,
          rowId: 'r1',
        ),
      ).thenAnswer((_) async => roomRow(id: 'r1', adminUid: 'someone-else'));
      when(
        tables.listRows(
          databaseId: databaseId,
          tableId: participantsTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => RowList(total: 0, rows: []));

      final room = await repo.getRoomById('r1', 'u1');

      expect(room, isNotNull);
      expect(room!.id, 'r1');
      expect(room.isUserAdmin, isFalse);
    });
  });

  group('loadParticipants', () {
    test('joins participant + user data', () async {
      when(
        tables.listRows(
          databaseId: databaseId,
          tableId: participantsTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 1,
          rows: [participantRow(uid: 'user-1', isAdmin: true)],
        ),
      );
      when(
        tables.listRows(
          databaseId: databaseId,
          tableId: usersTableID,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 1,
          rows: [userRow(id: 'user-1', name: 'Alice')],
        ),
      );

      final participants = await repo.loadParticipants('room-1');

      expect(participants, hasLength(1));
      expect(participants.first.name, 'Alice');
      expect(participants.first.isAdmin, isTrue);
    });

    test('reads every participant\'s user row in one query', () async {
      when(
        tables.listRows(
          databaseId: databaseId,
          tableId: participantsTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 3,
          rows: [
            participantRow(id: 'p1', uid: 'user-1'),
            participantRow(id: 'p2', uid: 'user-2'),
            participantRow(id: 'p3', uid: 'user-3'),
          ],
        ),
      );
      when(
        tables.listRows(
          databaseId: databaseId,
          tableId: usersTableID,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 3,
          rows: [
            userRow(id: 'user-1', name: 'Alice'),
            userRow(id: 'user-2', name: 'Bob'),
            userRow(id: 'user-3', name: 'Cass'),
          ],
        ),
      );

      final participants = await repo.loadParticipants('room-1');

      expect(participants.map((p) => p.name), ['Alice', 'Bob', 'Cass']);
      verify(
        tables.listRows(
          databaseId: databaseId,
          tableId: usersTableID,
          queries: anyNamed('queries'),
        ),
      ).called(1);
      verifyNever(
        tables.getRow(
          databaseId: databaseId,
          tableId: usersTableID,
          rowId: anyNamed('rowId'),
        ),
      );
    });
  });

  group('leaveRoom', () {
    test('decrements totalParticipants atomically when others remain', () async {
      when(
        tables.listRows(
          databaseId: databaseId,
          tableId: participantsTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 1,
          rows: [participantRow(id: 'p-99', uid: 'user-leaving')],
        ),
      );
      when(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenAnswer((_) async => '');
      when(
        tables.decrementRowColumn(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          column: anyNamed('column'),
          value: anyNamed('value'),
        ),
      ).thenAnswer((_) async => roomRow(totalParticipants: 2));

      final ok = await repo.leaveRoom(roomId: 'room-1', userId: 'user-leaving');

      expect(ok, isTrue);
      verify(
        tables.decrementRowColumn(
          databaseId: databaseId,
          tableId: roomsTableId,
          rowId: 'room-1',
          column: 'totalParticipants',
          value: 1.0,
        ),
      ).called(1);
      // The room is no longer read first just to work out the new count.
      verifyNever(
        tables.getRow(
          databaseId: databaseId,
          tableId: roomsTableId,
          rowId: anyNamed('rowId'),
          queries: anyNamed('queries'),
        ),
      );
      verifyNever(
        tables.updateRow(
          databaseId: databaseId,
          tableId: roomsTableId,
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      );
    });

    test('deletes the room when last participant leaves', () async {
      when(
        tables.listRows(
          databaseId: databaseId,
          tableId: participantsTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 1,
          rows: [participantRow(id: 'p-only', uid: 'last-user')],
        ),
      );
      when(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenAnswer((_) async => '');
      // The decrement reports the count it landed on.
      when(
        tables.decrementRowColumn(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          column: anyNamed('column'),
          value: anyNamed('value'),
        ),
      ).thenAnswer((_) async => roomRow(totalParticipants: 0));

      final ok = await repo.leaveRoom(roomId: 'room-1', userId: 'last-user');

      expect(ok, isTrue);
      verify(
        tables.deleteRow(
          databaseId: databaseId,
          tableId: roomsTableId,
          rowId: 'room-1',
        ),
      ).called(1);
    });

    test('with no participant row to remove, still tears down an empty room',
        () async {
      when(
        tables.listRows(
          databaseId: databaseId,
          tableId: participantsTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => RowList(total: 0, rows: []));
      when(
        tables.getRow(
          databaseId: databaseId,
          tableId: roomsTableId,
          rowId: 'room-1',
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => roomRow(totalParticipants: 0));
      when(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenAnswer((_) async => '');

      final ok = await repo.leaveRoom(roomId: 'room-1', userId: 'ghost');

      expect(ok, isTrue);
      // Nothing to decrement, so this path reads the count instead.
      verifyNever(
        tables.decrementRowColumn(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          column: anyNamed('column'),
          value: anyNamed('value'),
        ),
      );
      verify(
        tables.deleteRow(
          databaseId: databaseId,
          tableId: roomsTableId,
          rowId: 'room-1',
        ),
      ).called(1);
    });
  });

  group('kickParticipant', () {
    test('deletes the participant row', () async {
      when(
        tables.deleteRow(
          databaseId: databaseId,
          tableId: participantsTableId,
          rowId: 'p-7',
        ),
      ).thenAnswer((_) async => '');

      await repo.kickParticipant('p-7');

      verify(
        tables.deleteRow(
          databaseId: databaseId,
          tableId: participantsTableId,
          rowId: 'p-7',
        ),
      ).called(1);
    });
  });

  group('deleteRoom', () {
    setUp(() {
      // deleteRoom reads the admin token before anything else.
      stubFlutterSecureStorageChannel();
      when(
        tables.listRows(
          databaseId: databaseId,
          tableId: participantsTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 3,
          rows: [
            participantRow(id: 'p-1', uid: 'listener-1'),
            participantRow(id: 'p-host', uid: 'admin-uid', isAdmin: true),
            participantRow(id: 'p-2', uid: 'listener-2'),
          ],
        ),
      );
      when(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenAnswer((_) async {});
    });

    test('removes the host row before anyone else, then the room', () async {
      await repo.deleteRoom(roomId: 'room-1');

      // Participants read "the room ended" rather than "you were removed" from
      // seeing the host go, so the host must not be deleted alongside them.
      verifyInOrder([
        tables.deleteRow(
          databaseId: databaseId,
          tableId: participantsTableId,
          rowId: 'p-host',
        ),
        tables.deleteRow(
          databaseId: databaseId,
          tableId: participantsTableId,
          rowId: 'p-1',
        ),
        tables.deleteRow(
          databaseId: databaseId,
          tableId: participantsTableId,
          rowId: 'p-2',
        ),
        tables.deleteRow(
          databaseId: databaseId,
          tableId: roomsTableId,
          rowId: 'room-1',
        ),
      ]);
    });

    test('still deletes every participant when there is no host row', () async {
      when(
        tables.listRows(
          databaseId: databaseId,
          tableId: participantsTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 1,
          rows: [participantRow(id: 'p-1', uid: 'listener-1')],
        ),
      );

      await repo.deleteRoom(roomId: 'room-1');

      verify(
        tables.deleteRow(
          databaseId: databaseId,
          tableId: participantsTableId,
          rowId: 'p-1',
        ),
      ).called(1);
    });
  });

  group('error mapping', () {
    test('getRoomById maps 401 to permissionDenied', () async {
      when(
        tables.getRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenThrow(AppwriteException('unauthorized', 401));

      expect(
        repo.getRoomById('r1', 'u1'),
        throwsA(isA<RoomFailurePermissionDenied>()),
      );
    });
  });
}
