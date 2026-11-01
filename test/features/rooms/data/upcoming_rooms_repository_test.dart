import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/rooms/data/repositories/upcoming_rooms_repository.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.dart';
import 'upcoming_rooms_repository_test.mocks.dart';

@GenerateMocks([TablesDB, FirebaseMessaging])
// Builds an upcoming room row with the fields the repo reads.
Row upcomingRoomRow({
  String id = 'up-1',
  String name = 'Morning Talk',
  bool isTime = false,
  String scheduledDateTime = '2026-08-01T10:00:00.000Z',
  String description = 'A scheduled discussion',
  String creatorUid = 'creator-uid',
  List<String>? tags = const ['tag1', 'tag2'],
}) {
  return buildRow(
    id: id,
    tableId: upcomingRoomsTableId,
    databaseId: upcomingRoomsDatabaseId,
    data: {
      'name': name,
      'isTime': isTime,
      'scheduledDateTime': scheduledDateTime,
      'description': description,
      'creatorUid': creatorUid,
      'tags': tags,
    },
  );
}

// Builds a subscriber row with the fields the repo reads.
Row subscriberRow({
  String id = 'sub-1',
  String userID = 'other-user',
  String upcomingRoomId = 'up-1',
  String userProfileUrl = 'https://example.com/a.jpg',
}) {
  return buildRow(
    id: id,
    tableId: subscribedUserTableId,
    databaseId: upcomingRoomsDatabaseId,
    data: {
      'userID': userID,
      'upcomingRoomId': upcomingRoomId,
      'userProfileUrl': userProfileUrl,
    },
  );
}

void main() {
  late MockTablesDB tables;
  late MockFirebaseMessaging messaging;
  late UpcomingRoomsRepository repo;

  setUp(() {
    tables = MockTablesDB();
    messaging = MockFirebaseMessaging();
    repo = UpcomingRoomsRepository(tables: tables, messaging: messaging);
  });

  group('loadUpcoming', () {
    test('lists rows, filters hidden ids, and hydrates each', () async {
      when(
        tables.listRows(
          databaseId: upcomingRoomsDatabaseId,
          tableId: upcomingRoomsTableId,
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 2,
          rows: [
            upcomingRoomRow(id: 'visible', creatorUid: 'someone-else'),
            upcomingRoomRow(id: 'hidden'),
          ],
        ),
      );
      when(
        tables.listRows(
          databaseId: upcomingRoomsDatabaseId,
          tableId: subscribedUserTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => RowList(total: 0, rows: []));

      final rooms = await repo.loadUpcoming(
        userUid: 'me',
        hiddenRoomIds: {'hidden'},
      );

      expect(rooms, hasLength(1));
      expect(rooms.first.id, 'visible');
      verify(
        tables.listRows(
          databaseId: upcomingRoomsDatabaseId,
          tableId: upcomingRoomsTableId,
        ),
      ).called(1);
    });

    test('marks userIsCreator when creatorUid matches userUid', () async {
      when(
        tables.listRows(
          databaseId: upcomingRoomsDatabaseId,
          tableId: upcomingRoomsTableId,
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 1,
          rows: [upcomingRoomRow(id: 'up-1', creatorUid: 'me')],
        ),
      );
      // The creator is also a subscriber, but hasUserSubscribed stays false.
      when(
        tables.listRows(
          databaseId: upcomingRoomsDatabaseId,
          tableId: subscribedUserTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 1,
          rows: [subscriberRow(id: 's-me', userID: 'me')],
        ),
      );

      final rooms = await repo.loadUpcoming(
        userUid: 'me',
        hiddenRoomIds: const {},
      );

      expect(rooms, hasLength(1));
      final room = rooms.first;
      expect(room.userIsCreator, isTrue);
      expect(room.hasUserSubscribed, isFalse);
      expect(room.totalSubscriberCount, 1);
      expect(room.subscribersAvatarUrls, hasLength(1));
    });

    test(
      'hydrates avatars, subscriber count, and hasUserSubscribed for non-creator',
      () async {
        when(
          tables.listRows(
            databaseId: upcomingRoomsDatabaseId,
            tableId: upcomingRoomsTableId,
          ),
        ).thenAnswer(
          (_) async => RowList(
            total: 1,
            rows: [upcomingRoomRow(id: 'up-1', creatorUid: 'creator-uid')],
          ),
        );
        when(
          tables.listRows(
            databaseId: upcomingRoomsDatabaseId,
            tableId: subscribedUserTableId,
            queries: anyNamed('queries'),
          ),
        ).thenAnswer(
          (_) async => RowList(
            total: 2,
            rows: [
              subscriberRow(
                id: 's1',
                userID: 'other',
                userProfileUrl: 'https://example.com/1.jpg',
              ),
              subscriberRow(
                id: 's2',
                userID: 'me',
                userProfileUrl: 'https://example.com/2.jpg',
              ),
            ],
          ),
        );

        final rooms = await repo.loadUpcoming(
          userUid: 'me',
          hiddenRoomIds: const {},
        );

        final room = rooms.first;
        expect(room.userIsCreator, isFalse);
        expect(room.hasUserSubscribed, isTrue);
        expect(room.totalSubscriberCount, 2);
        expect(room.subscribersAvatarUrls, [
          'https://example.com/1.jpg',
          'https://example.com/2.jpg',
        ]);
      },
    );

    test('defaults tags to [] when data has null tags', () async {
      when(
        tables.listRows(
          databaseId: upcomingRoomsDatabaseId,
          tableId: upcomingRoomsTableId,
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 1,
          rows: [upcomingRoomRow(id: 'up-1', tags: null)],
        ),
      );
      when(
        tables.listRows(
          databaseId: upcomingRoomsDatabaseId,
          tableId: subscribedUserTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => RowList(total: 0, rows: []));

      final rooms = await repo.loadUpcoming(
        userUid: 'me',
        hiddenRoomIds: const {},
      );

      expect(rooms.first.tags, isEmpty);
    });

    test('returns fallback Unknown room when hydration throws', () async {
      when(
        tables.listRows(
          databaseId: upcomingRoomsDatabaseId,
          tableId: upcomingRoomsTableId,
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 1,
          rows: [upcomingRoomRow(id: 'up-1')],
        ),
      );
      // Subscriber lookup fails, so hydration falls into the catch block.
      when(
        tables.listRows(
          databaseId: upcomingRoomsDatabaseId,
          tableId: subscribedUserTableId,
          queries: anyNamed('queries'),
        ),
      ).thenThrow(AppwriteException('boom', 500));

      final rooms = await repo.loadUpcoming(
        userUid: 'me',
        hiddenRoomIds: const {},
      );

      expect(rooms, hasLength(1));
      final room = rooms.first;
      expect(room.id, '');
      expect(room.name, 'Unknown');
      expect(room.description, 'Error fetching upcomingRoom details');
      expect(room.totalSubscriberCount, 0);
      expect(room.tags, isEmpty);
      expect(room.subscribersAvatarUrls, isEmpty);
      expect(room.userIsCreator, isFalse);
      expect(room.hasUserSubscribed, isFalse);
    });
  });

  group('liveUpcomingRoomIds', () {
    test('returns the set of row ids', () async {
      when(
        tables.listRows(
          databaseId: upcomingRoomsDatabaseId,
          tableId: upcomingRoomsTableId,
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 2,
          rows: [
            upcomingRoomRow(id: 'a'),
            upcomingRoomRow(id: 'b'),
          ],
        ),
      );

      final ids = await repo.liveUpcomingRoomIds();

      expect(ids, {'a', 'b'});
    });
  });

  group('createUpcomingRoom', () {
    test('gets fcm token then creates the room row', () async {
      when(messaging.getToken()).thenAnswer((_) async => 'fcm-token');
      when(
        tables.createRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => upcomingRoomRow());

      await repo.createUpcomingRoom(
        name: 'New Room',
        description: 'desc',
        tags: const ['t1'],
        scheduledDateTime: '2026-08-01T10:00:00.000Z',
        creatorUid: 'creator-uid',
      );

      verify(messaging.getToken()).called(1);
      final captured = verify(
        tables.createRow(
          databaseId: upcomingRoomsDatabaseId,
          tableId: upcomingRoomsTableId,
          rowId: anyNamed('rowId'),
          data: captureAnyNamed('data'),
        ),
      ).captured.single as Map;
      expect(captured['name'], 'New Room');
      expect(captured['scheduledDateTime'], '2026-08-01T10:00:00.000Z');
      expect(captured['tags'], const ['t1']);
      expect(captured['description'], 'desc');
      expect(captured['creatorUid'], 'creator-uid');
      expect(captured['creator_fcm_tokens'], ['fcm-token']);
    });
  });

  group('addSubscriber', () {
    test('gets fcm token then creates a subscriber row', () async {
      when(messaging.getToken()).thenAnswer((_) async => 'fcm-token');
      when(
        tables.createRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => subscriberRow());

      await repo.addSubscriber(
        upcomingRoomId: 'up-1',
        userUid: 'me',
        profileImageUrl: 'https://example.com/me.jpg',
      );

      verify(messaging.getToken()).called(1);
      final captured = verify(
        tables.createRow(
          databaseId: upcomingRoomsDatabaseId,
          tableId: subscribedUserTableId,
          rowId: anyNamed('rowId'),
          data: captureAnyNamed('data'),
        ),
      ).captured.single as Map;
      expect(captured['userID'], 'me');
      expect(captured['upcomingRoomId'], 'up-1');
      expect(captured['registrationTokens'], ['fcm-token']);
      expect(captured['userProfileUrl'], 'https://example.com/me.jpg');
    });
  });

  group('removeSubscriber', () {
    test('is a no-op when no matching subscriber row exists', () async {
      when(
        tables.listRows(
          databaseId: upcomingRoomsDatabaseId,
          tableId: subscribedUserTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => RowList(total: 0, rows: []));

      await repo.removeSubscriber(upcomingRoomId: 'up-1', userUid: 'me');

      verifyNever(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      );
    });

    test('deletes the first matching subscriber row', () async {
      when(
        tables.listRows(
          databaseId: upcomingRoomsDatabaseId,
          tableId: subscribedUserTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 1,
          rows: [subscriberRow(id: 'match-1', userID: 'me')],
        ),
      );
      when(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenAnswer((_) async => '');

      await repo.removeSubscriber(upcomingRoomId: 'up-1', userUid: 'me');

      verify(
        tables.deleteRow(
          databaseId: upcomingRoomsDatabaseId,
          tableId: subscribedUserTableId,
          rowId: 'match-1',
        ),
      ).called(1);
    });
  });

  group('deleteUpcomingRoom', () {
    test('deletes the room row then every subscriber row', () async {
      when(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenAnswer((_) async => '');
      when(
        tables.listRows(
          databaseId: upcomingRoomsDatabaseId,
          tableId: subscribedUserTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 2,
          rows: [
            subscriberRow(id: 's1'),
            subscriberRow(id: 's2'),
          ],
        ),
      );

      await repo.deleteUpcomingRoom('up-1');

      verify(
        tables.deleteRow(
          databaseId: upcomingRoomsDatabaseId,
          tableId: upcomingRoomsTableId,
          rowId: 'up-1',
        ),
      ).called(1);
      verify(
        tables.deleteRow(
          databaseId: upcomingRoomsDatabaseId,
          tableId: subscribedUserTableId,
          rowId: 's1',
        ),
      ).called(1);
      verify(
        tables.deleteRow(
          databaseId: upcomingRoomsDatabaseId,
          tableId: subscribedUserTableId,
          rowId: 's2',
        ),
      ).called(1);
    });
  });
}
