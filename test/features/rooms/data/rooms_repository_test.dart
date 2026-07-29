import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/rooms/data/repositories/rooms_repository.dart';
import 'package:resonate/features/rooms/model/room_failure.dart';
import 'package:resonate/core/services/room_join_service.dart';
import 'package:resonate/utils/constants.dart';

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
    $databaseId: masterDatabaseId,
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
    $databaseId: userDatabaseID,
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
    $databaseId: masterDatabaseId,
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
          databaseId: masterDatabaseId,
          tableId: roomsTableId,
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
          databaseId: masterDatabaseId,
          tableId: participantsTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => RowList(total: 0, rows: []));

      final rooms = await repo.loadRooms('admin-uid');

      expect(rooms, hasLength(1));
      expect(rooms.first.id, 'r1');
      expect(rooms.first.isUserAdmin, isTrue);
    });
  });

  group('getRoomById', () {
    test('returns null on 404', () async {
      when(
        tables.getRow(
          databaseId: masterDatabaseId,
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
          databaseId: masterDatabaseId,
          tableId: roomsTableId,
          rowId: 'r1',
        ),
      ).thenAnswer((_) async => roomRow(id: 'r1', adminUid: 'someone-else'));
      when(
        tables.listRows(
          databaseId: masterDatabaseId,
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
          databaseId: masterDatabaseId,
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
        tables.getRow(
          databaseId: userDatabaseID,
          tableId: usersTableID,
          rowId: 'user-1',
        ),
      ).thenAnswer((_) async => userRow(id: 'user-1', name: 'Alice'));

      final participants = await repo.loadParticipants('room-1');

      expect(participants, hasLength(1));
      expect(participants.first.name, 'Alice');
      expect(participants.first.isAdmin, isTrue);
    });
  });

  group('leaveRoom', () {
    test('decrements totalParticipants when others remain', () async {
      when(
        tables.getRow(
          databaseId: masterDatabaseId,
          tableId: roomsTableId,
          rowId: 'room-1',
        ),
      ).thenAnswer((_) async => roomRow(totalParticipants: 3));
      when(
        tables.listRows(
          databaseId: masterDatabaseId,
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
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => roomRow());

      final ok = await repo.leaveRoom(roomId: 'room-1', userId: 'user-leaving');

      expect(ok, isTrue);
      verify(
        tables.updateRow(
          databaseId: masterDatabaseId,
          tableId: roomsTableId,
          rowId: 'room-1',
          data: {'totalParticipants': 2},
        ),
      ).called(1);
    });

    test('deletes the room when last participant leaves', () async {
      when(
        tables.getRow(
          databaseId: masterDatabaseId,
          tableId: roomsTableId,
          rowId: 'room-1',
        ),
      ).thenAnswer((_) async => roomRow(totalParticipants: 1));
      when(
        tables.listRows(
          databaseId: masterDatabaseId,
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

      final ok = await repo.leaveRoom(roomId: 'room-1', userId: 'last-user');

      expect(ok, isTrue);
      verify(
        tables.deleteRow(
          databaseId: masterDatabaseId,
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
          databaseId: masterDatabaseId,
          tableId: participantsTableId,
          rowId: 'p-7',
        ),
      ).thenAnswer((_) async => '');

      await repo.kickParticipant('p-7');

      verify(
        tables.deleteRow(
          databaseId: masterDatabaseId,
          tableId: participantsTableId,
          rowId: 'p-7',
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
