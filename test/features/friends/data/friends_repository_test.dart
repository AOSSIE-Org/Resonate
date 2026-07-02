import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_user.dart';
import 'package:resonate/features/friends/data/repositories/friends_repository.dart';
import 'package:resonate/features/friends/model/friends_model.dart';
import 'package:resonate/features/friends/model/friends_state.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/friend_request_status.dart';

import 'friends_repository_test.mocks.dart';

@GenerateMocks([TablesDB, Realtime, RealtimeSubscription, FirebaseMessaging])
// Builds a friends-row json payload as stored under user.data['friends'].
Map<String, dynamic> friendJson({
  String docId = 'friend-doc-1',
  String senderId = 'sender-1',
  String recieverId = 'reciever-1',
  String status = 'accepted',
}) => {
  '\$id': docId,
  'senderId': senderId,
  'recieverId': recieverId,
  'senderProfileImgUrl': 'https://example.com/s.jpg',
  'recieverProfileImgUrl': 'https://example.com/r.jpg',
  'senderUsername': 'sender',
  'recieverUsername': 'reciever',
  'senderName': 'Sender',
  'recieverName': 'Reciever',
  'requestStatus': status,
  'requestSentByUserId': senderId,
  'senderRating': 4.0,
  'recieverRating': 3.5,
};

// A user row whose data carries the joined friends list.
Row userRow({
  String id = 'me',
  List<Map<String, dynamic>> friends = const [],
}) => Row(
  $id: id,
  $sequence: 0,
  $tableId: usersTableID,
  $databaseId: userDatabaseID,
  $createdAt: DateTime.now().toIso8601String(),
  $updatedAt: DateTime.now().toIso8601String(),
  $permissions: const [],
  data: {'friends': friends},
);

Row friendRow({String id = 'friend-doc-1'}) => Row(
  $id: id,
  $sequence: 0,
  $tableId: friendsTableID,
  $databaseId: userDatabaseID,
  $createdAt: DateTime.now().toIso8601String(),
  $updatedAt: DateTime.now().toIso8601String(),
  $permissions: const [],
  data: friendJson(docId: id),
);

AuthUser sender({
  String uid = 'sender-1',
  double ratingTotal = 8,
  int ratingCount = 2,
}) => AuthUser(
  uid: uid,
  email: 'sender@test.com',
  displayName: 'Sender',
  userName: 'sender',
  profileImageUrl: 'https://example.com/s.jpg',
  isEmailVerified: true,
  isProfileComplete: true,
  ratingTotal: ratingTotal,
  ratingCount: ratingCount,
);

void main() {
  late MockTablesDB tables;
  late MockRealtime realtime;
  late MockRealtimeSubscription subscription;
  late MockFirebaseMessaging messaging;
  late StreamController<RealtimeMessage> events;
  late FriendsRepository repo;

  setUp(() {
    tables = MockTablesDB();
    realtime = MockRealtime();
    subscription = MockRealtimeSubscription();
    messaging = MockFirebaseMessaging();
    events = StreamController<RealtimeMessage>.broadcast();
    repo = FriendsRepository(
      tables: tables,
      realtime: realtime,
      messaging: messaging,
    );
  });

  tearDown(() => events.close());

  group('loadFriends', () {
    test('partitions accepted into friends and pending into requests',
        () async {
      when(
        tables.getRow(
          databaseId: userDatabaseID,
          tableId: usersTableID,
          rowId: 'me',
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => userRow(
          friends: [
            friendJson(docId: 'a', status: 'accepted'),
            friendJson(docId: 'p', status: 'sent'),
          ],
        ),
      );

      final result = await repo.loadFriends('me');

      expect(result.friends, hasLength(1));
      expect(result.friends.first.docId, 'a');
      expect(result.requests, hasLength(1));
      expect(result.requests.first.docId, 'p');
    });

    test('skips malformed rows via try/catch', () async {
      when(
        tables.getRow(
          databaseId: userDatabaseID,
          tableId: usersTableID,
          rowId: 'me',
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => userRow(
          friends: [
            friendJson(docId: 'ok', status: 'accepted'),
            // Missing required fields -> fromJson throws -> skipped.
            {'\$id': 'broken'},
          ],
        ),
      );

      final result = await repo.loadFriends('me');

      expect(result.friends, hasLength(1));
      expect(result.friends.first.docId, 'ok');
      expect(result.requests, isEmpty);
    });

    test('selects Query.select(["*","friends.*"])', () async {
      when(
        tables.getRow(
          databaseId: userDatabaseID,
          tableId: usersTableID,
          rowId: 'me',
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => userRow());

      await repo.loadFriends('me');

      final captured = verify(
        tables.getRow(
          databaseId: userDatabaseID,
          tableId: usersTableID,
          rowId: 'me',
          queries: captureAnyNamed('queries'),
        ),
      ).captured.single as List<String>;
      expect(captured, [
        Query.select(['*', 'friends.*']),
      ]);
    });
  });

  group('sendFriendRequest', () {
    test('sets senderFCMToken and averaged senderRating, creates row',
        () async {
      when(messaging.getToken()).thenAnswer((_) async => 'fcm-token');
      when(
        tables.createRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => friendRow());

      final model = await repo.sendFriendRequest(
        sender: sender(ratingTotal: 8, ratingCount: 2),
        recieverId: 'reciever-1',
        recieverProfileImageUrl: 'https://example.com/r.jpg',
        recieverUsername: 'reciever',
        recieverName: 'Reciever',
        recieverRating: 3.5,
      );

      expect(model.senderFCMToken, 'fcm-token');
      expect(model.senderRating, 4.0);
      expect(model.requestStatus, FriendRequestStatus.sent);
      expect(model.users, ['sender-1', 'reciever-1']);

      verify(
        tables.createRow(
          databaseId: userDatabaseID,
          tableId: friendsTableID,
          rowId: model.docId,
          data: anyNamed('data'),
        ),
      ).called(1);
    });

    test('uses 0 senderRating when ratingCount is 0', () async {
      when(messaging.getToken()).thenAnswer((_) async => 'fcm-token');
      when(
        tables.createRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => friendRow());

      final model = await repo.sendFriendRequest(
        sender: sender(ratingTotal: 5, ratingCount: 0),
        recieverId: 'reciever-1',
        recieverProfileImageUrl: 'https://example.com/r.jpg',
        recieverUsername: 'reciever',
        recieverName: 'Reciever',
        recieverRating: 3.5,
      );

      expect(model.senderRating, 0);
    });

    test('maps 404 from createRow to notFound', () async {
      when(messaging.getToken()).thenAnswer((_) async => 'fcm-token');
      when(
        tables.createRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenThrow(AppwriteException('missing', 404));

      expect(
        repo.sendFriendRequest(
          sender: sender(),
          recieverId: 'reciever-1',
          recieverProfileImageUrl: 'https://example.com/r.jpg',
          recieverUsername: 'reciever',
          recieverName: 'Reciever',
          recieverRating: 3.5,
        ),
        throwsA(isA<FriendsFailureNotFound>()),
      );
    });
  });

  group('acceptFriendRequest', () {
    test('copies with accepted status and recieverFCMToken, updates row',
        () async {
      when(messaging.getToken()).thenAnswer((_) async => 'rec-token');
      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => friendRow());

      final original = FriendsModel.fromJson(
        friendJson(docId: 'friend-doc-1', status: 'sent'),
      );
      final updated = await repo.acceptFriendRequest(original);

      expect(updated.requestStatus, FriendRequestStatus.accepted);
      expect(updated.recieverFCMToken, 'rec-token');
      expect(updated.users, ['sender-1', 'reciever-1']);

      verify(
        tables.updateRow(
          databaseId: userDatabaseID,
          tableId: friendsTableID,
          rowId: 'friend-doc-1',
          data: anyNamed('data'),
        ),
      ).called(1);
    });

    test('maps 401 from updateRow to permissionDenied', () async {
      when(messaging.getToken()).thenAnswer((_) async => 'rec-token');
      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenThrow(AppwriteException('unauthorized', 401));

      final original = FriendsModel.fromJson(
        friendJson(docId: 'friend-doc-1', status: 'sent'),
      );

      expect(
        repo.acceptFriendRequest(original),
        throwsA(isA<FriendsFailurePermissionDenied>()),
      );
    });
  });

  group('deleteFriendRow', () {
    test('deletes the row by docId', () async {
      when(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenAnswer((_) async => '');

      await repo.deleteFriendRow('friend-doc-1');

      verify(
        tables.deleteRow(
          databaseId: userDatabaseID,
          tableId: friendsTableID,
          rowId: 'friend-doc-1',
        ),
      ).called(1);
    });

    test('maps 403 from deleteRow to permissionDenied', () async {
      when(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenThrow(AppwriteException('forbidden', 403));

      expect(
        repo.deleteFriendRow('friend-doc-1'),
        throwsA(isA<FriendsFailurePermissionDenied>()),
      );
    });

    test('maps other codes from deleteRow to unknown', () async {
      when(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenThrow(AppwriteException('boom', 500));

      expect(
        repo.deleteFriendRow('friend-doc-1'),
        throwsA(isA<FriendsFailureUnknown>()),
      );
    });
  });

  group('friendsStream', () {
    setUp(() {
      when(realtime.subscribe(any)).thenReturn(subscription);
      when(subscription.stream).thenAnswer((_) => events.stream);
      when(subscription.close).thenReturn(() async {});
    });

    test('only emits events whose senderId or recieverId matches uid',
        () async {
      final received = <RealtimeMessage>[];
      final sub = repo.friendsStream('me').listen(received.add);

      final channel =
          'databases.$userDatabaseID.tables.$friendsTableID.rows';
      // Matches on senderId.
      events.add(RealtimeMessage(
        events: ['$channel.a.create'],
        payload: {'senderId': 'me', 'recieverId': 'other'},
        channels: [channel],
        timestamp: DateTime.now().toIso8601String(),
      ));
      // Matches on recieverId.
      events.add(RealtimeMessage(
        events: ['$channel.b.create'],
        payload: {'senderId': 'other', 'recieverId': 'me'},
        channels: [channel],
        timestamp: DateTime.now().toIso8601String(),
      ));
      // Unrelated user -> filtered out.
      events.add(RealtimeMessage(
        events: ['$channel.c.create'],
        payload: {'senderId': 'x', 'recieverId': 'y'},
        channels: [channel],
        timestamp: DateTime.now().toIso8601String(),
      ));
      // Empty payload -> filtered out.
      events.add(RealtimeMessage(
        events: ['$channel.d.create'],
        payload: const {},
        channels: [channel],
        timestamp: DateTime.now().toIso8601String(),
      ));
      await pumpEventQueue();

      expect(received, hasLength(2));
      await sub.cancel();
    });

    test('cancels subscription and closes on cancel', () async {
      var closed = false;
      when(subscription.close).thenReturn(() async {
        closed = true;
      });

      final sub = repo.friendsStream('me').listen((_) {});
      await pumpEventQueue();
      await sub.cancel();
      await pumpEventQueue();

      expect(closed, isTrue);
      verify(subscription.close).called(1);
    });
  });
}
