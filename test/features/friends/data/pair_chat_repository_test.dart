import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/friends/data/pair_chat_repository.dart';
import 'package:resonate/features/friends/model/friends_state.dart';
import 'package:resonate/core/services/api_service.dart';
import 'package:resonate/utils/constants.dart';

import 'pair_chat_repository_test.mocks.dart';

@GenerateMocks([TablesDB, Realtime, Functions, RealtimeSubscription, Execution])
// Builds a Row with pair-request/user shaped data.
Row pairRow({
  String id = 'req-1',
  String tableId = pairRequestTableId,
  String databaseId = masterDatabaseId,
  Map<String, dynamic>? data,
}) {
  return Row(
    $id: id,
    $sequence: 0,
    $tableId: tableId,
    $databaseId: databaseId,
    $createdAt: DateTime.now().toIso8601String(),
    $updatedAt: DateTime.now().toIso8601String(),
    $permissions: const [],
    data: data ?? const {},
  );
}

// Builds a valid online-user row (parses into ResonateUser).
Row onlineUserRow({
  String id = 'req-1',
  String uid = 'user-1',
  String userName = 'testuser',
  String name = 'Test User',
  String profileImageUrl = 'https://example.com/u.jpg',
}) {
  return pairRow(
    id: id,
    data: {
      'uid': uid,
      'userName': userName,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'userRating': 4,
    },
  );
}

// Wraps an Execution mock that returns a 200 + json body.
MockExecution _execution(String body) {
  final exec = MockExecution();
  when(exec.responseStatusCode).thenReturn(200);
  when(exec.responseBody).thenReturn(body);
  return exec;
}

void main() {
  late MockTablesDB tables;
  late MockRealtime realtime;
  late MockFunctions functions;
  late MockRealtimeSubscription subscription;
  late StreamController<RealtimeMessage> events;
  late PairChatRepository repo;

  setUp(() {
    tables = MockTablesDB();
    realtime = MockRealtime();
    functions = MockFunctions();
    subscription = MockRealtimeSubscription();
    events = StreamController<RealtimeMessage>.broadcast();
    repo = PairChatRepository(
      tables: tables,
      realtime: realtime,
      apiService: ApiService(functions: functions),
    );
  });

  tearDown(() => events.close());

  group('createPairRequest', () {
    test('returns the created row id and forwards the data map', () async {
      final data = {'uid': 'me', 'isAnonymous': false};
      when(
        tables.createRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => pairRow(id: 'new-req'));

      final id = await repo.createPairRequest(data: data);

      expect(id, 'new-req');
      final captured = verify(
        tables.createRow(
          databaseId: masterDatabaseId,
          tableId: pairRequestTableId,
          rowId: anyNamed('rowId'),
          data: captureAnyNamed('data'),
        ),
      ).captured.single;
      expect(captured, data);
    });

    test('maps AppwriteException to FriendsFailure', () async {
      when(
        tables.createRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenThrow(AppwriteException('nope', 401));

      expect(
        repo.createPairRequest(data: const {}),
        throwsA(isA<FriendsFailurePermissionDenied>()),
      );
    });
  });

  group('convertRequestToRandom', () {
    test('updates the request row with isRandom true', () async {
      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => pairRow());

      await repo.convertRequestToRandom('req-9');

      verify(
        tables.updateRow(
          databaseId: masterDatabaseId,
          tableId: pairRequestTableId,
          rowId: 'req-9',
          data: {'isRandom': true},
        ),
      ).called(1);
    });

    test('maps AppwriteException to FriendsFailure', () async {
      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenThrow(AppwriteException('boom', 500));

      expect(
        repo.convertRequestToRandom('req-9'),
        throwsA(isA<FriendsFailureUnknown>()),
      );
    });
  });

  group('deletePairRequest', () {
    test('deletes the request row', () async {
      when(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenAnswer((_) async => '');

      await repo.deletePairRequest('req-3');

      verify(
        tables.deleteRow(
          databaseId: masterDatabaseId,
          tableId: pairRequestTableId,
          rowId: 'req-3',
        ),
      ).called(1);
    });

    test('maps AppwriteException to FriendsFailure', () async {
      when(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenThrow(AppwriteException('not found', 404));

      expect(
        repo.deletePairRequest('req-3'),
        throwsA(isA<FriendsFailureNotFound>()),
      );
    });
  });

  group('listOnlineUsers', () {
    test('queries exclude uid + anonymous, maps rows and injects docId', () async {
      when(
        tables.listRows(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 1,
          rows: [onlineUserRow(id: 'doc-1', uid: 'other', name: 'Bob')],
        ),
      );

      final users = await repo.listOnlineUsers(excludeUid: 'me');

      expect(users, hasLength(1));
      expect(users.first.name, 'Bob');
      expect(users.first.docId, 'doc-1');

      final captured = verify(
        tables.listRows(
          databaseId: masterDatabaseId,
          tableId: pairRequestTableId,
          queries: captureAnyNamed('queries'),
        ),
      ).captured.single as List<String>;
      expect(captured, contains(Query.notEqual('uid', 'me')));
      expect(captured, contains(Query.notEqual('isAnonymous', true)));
      expect(captured, contains(Query.limit(100)));
    });

    test('skips malformed rows without throwing', () async {
      when(
        tables.listRows(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 2,
          rows: [
            onlineUserRow(id: 'good', uid: 'u-good'),
            // name is an int → `as String?` cast in fromJson throws.
            pairRow(id: 'bad', data: const {'uid': 'u-bad', 'name': 42}),
          ],
        ),
      );

      final users = await repo.listOnlineUsers(excludeUid: 'me');

      expect(users, hasLength(1));
      expect(users.first.docId, 'good');
    });
  });

  group('createActivePair', () {
    test('writes the uid/userName/userDocId payload', () async {
      when(
        tables.createRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => pairRow(tableId: activePairsTableId));

      await repo.createActivePair(
        uid1: 'a',
        uid2: 'b',
        userName1: 'Alice',
        userName2: 'Bob',
        requestDocId1: 'r1',
        requestDocId2: 'r2',
      );

      final captured = verify(
        tables.createRow(
          databaseId: masterDatabaseId,
          tableId: activePairsTableId,
          rowId: anyNamed('rowId'),
          data: captureAnyNamed('data'),
        ),
      ).captured.single as Map<String, dynamic>;
      expect(captured, {
        'uid1': 'a',
        'uid2': 'b',
        'userName1': 'Alice',
        'userName2': 'Bob',
        'userDocId1': 'r1',
        'userDocId2': 'r2',
      });
    });

    test('maps AppwriteException to FriendsFailure', () async {
      when(
        tables.createRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenThrow(AppwriteException('forbidden', 403));

      expect(
        repo.createActivePair(uid1: 'a', uid2: 'b'),
        throwsA(isA<FriendsFailurePermissionDenied>()),
      );
    });
  });

  group('deleteActivePair', () {
    test('deletes the active-pair row', () async {
      when(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenAnswer((_) async => '');

      await repo.deleteActivePair('pair-1');

      verify(
        tables.deleteRow(
          databaseId: masterDatabaseId,
          tableId: activePairsTableId,
          rowId: 'pair-1',
        ),
      ).called(1);
    });

    test('swallows a 404 and returns normally', () async {
      when(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenThrow(AppwriteException('gone', 404));

      await expectLater(repo.deleteActivePair('pair-1'), completes);
    });

    test('swallows a document_not_found type and returns normally', () async {
      when(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenThrow(
        AppwriteException('gone', 500, 'document_not_found'),
      );

      await expectLater(repo.deleteActivePair('pair-1'), completes);
    });

    test('rethrows a mapped failure on other codes', () async {
      when(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenThrow(AppwriteException('denied', 401));

      expect(
        repo.deleteActivePair('pair-1'),
        throwsA(isA<FriendsFailurePermissionDenied>()),
      );
    });
  });

  group('getUserProfileImageUrl', () {
    test('returns the url on success', () async {
      when(
        tables.getRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenAnswer(
        (_) async => pairRow(
          id: 'user-1',
          tableId: usersTableID,
          databaseId: userDatabaseID,
          data: const {'profileImageUrl': 'https://example.com/pic.jpg'},
        ),
      );

      final url = await repo.getUserProfileImageUrl('user-1');

      expect(url, 'https://example.com/pic.jpg');
      verify(
        tables.getRow(
          databaseId: userDatabaseID,
          tableId: usersTableID,
          rowId: 'user-1',
        ),
      ).called(1);
    });

    test('returns null on any error', () async {
      when(
        tables.getRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenThrow(AppwriteException('missing', 404));

      final url = await repo.getUserProfileImageUrl('user-1');

      expect(url, isNull);
    });
  });

  group('updateUserRating', () {
    test('writes ratingTotal + ratingCount to the user row', () async {
      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer(
        (_) async => pairRow(
          id: 'user-1',
          tableId: usersTableID,
          databaseId: userDatabaseID,
        ),
      );

      await repo.updateUserRating(
        uid: 'user-1',
        ratingTotal: 12.5,
        ratingCount: 3,
      );

      verify(
        tables.updateRow(
          databaseId: userDatabaseID,
          tableId: usersTableID,
          rowId: 'user-1',
          data: {'ratingTotal': 12.5, 'ratingCount': 3},
        ),
      ).called(1);
    });

    test('maps AppwriteException to FriendsFailure', () async {
      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenThrow(AppwriteException('missing', 404));

      expect(
        repo.updateUserRating(uid: 'user-1', ratingTotal: 1, ratingCount: 1),
        throwsA(isA<FriendsFailureNotFound>()),
      );
    });
  });

  group('activePairsStream', () {
    test('forwards non-empty payloads and cancels cleanly', () async {
      when(realtime.subscribe(any)).thenReturn(subscription);
      when(subscription.stream).thenAnswer((_) => events.stream);
      when(subscription.close).thenReturn(() async {});

      final received = <RealtimeMessage>[];
      final sub = repo.activePairsStream().listen(received.add);

      final channel = PairChatRepository.activePairsChannel();
      events.add(
        RealtimeMessage(
          events: ['$channel.create'],
          payload: {'uid1': 'a', 'uid2': 'b'},
          channels: [channel],
          timestamp: DateTime.now().toIso8601String(),
        ),
      );
      events.add(
        RealtimeMessage(
          events: ['$channel.update'],
          payload: const {},
          channels: [channel],
          timestamp: DateTime.now().toIso8601String(),
        ),
      );
      await pumpEventQueue();

      expect(received, hasLength(1));
      expect(received.first.payload['uid1'], 'a');

      await sub.cancel();
      verify(subscription.close).called(1);
    });

    test('subscribes on the active-pairs channel', () {
      when(realtime.subscribe(any)).thenReturn(subscription);
      when(subscription.stream).thenAnswer((_) => events.stream);
      when(subscription.close).thenReturn(() async {});

      final sub = repo.activePairsStream().listen((_) {});

      verify(
        realtime.subscribe([PairChatRepository.activePairsChannel()]),
      ).called(1);
      sub.cancel();
    });
  });

  group('pairRequestsStream', () {
    test('forwards non-empty payloads and cancels cleanly', () async {
      when(realtime.subscribe(any)).thenReturn(subscription);
      when(subscription.stream).thenAnswer((_) => events.stream);
      when(subscription.close).thenReturn(() async {});

      final channel =
          'databases.$masterDatabaseId.tables.$pairRequestTableId.rows';
      final received = <RealtimeMessage>[];
      final sub = repo.pairRequestsStream().listen(received.add);

      events.add(
        RealtimeMessage(
          events: ['$channel.create'],
          payload: {'uid': 'me'},
          channels: [channel],
          timestamp: DateTime.now().toIso8601String(),
        ),
      );
      events.add(
        RealtimeMessage(
          events: ['$channel.delete'],
          payload: const {},
          channels: [channel],
          timestamp: DateTime.now().toIso8601String(),
        ),
      );
      await pumpEventQueue();

      expect(received, hasLength(1));
      expect(received.first.payload['uid'], 'me');

      await sub.cancel();
      verify(subscription.close).called(1);
      verify(realtime.subscribe([channel])).called(1);
    });
  });

  group('pairJoinInfo', () {
    test('returns LiveKit join params from the join function', () async {
      when(
        functions.createExecution(
          functionId: joinRoomServiceId,
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => _execution(
          '{"livekit_socket_url":"wss://example.com","access_token":"tok"}',
        ),
      );

      final join = await repo.pairJoinInfo(roomId: 'room-1', userId: 'me');

      expect(join.liveKitUri, 'wss://example.com');
      expect(join.roomToken, 'tok');
      verify(
        functions.createExecution(
          functionId: joinRoomServiceId,
          body: anyNamed('body'),
        ),
      ).called(1);
    });
  });
}
