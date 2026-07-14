import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/friends/model/friends_model.dart';
import 'package:resonate/features/friends/data/friends.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/friend_request_status.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

Map<String, dynamic> _friendJson(FriendsModel model) => {
      ...model.toJson(),
      '\$id': model.docId,
    };

void main() {
  late MockTablesDB tables;
  late MockRealtime realtime;
  late MockFirebaseMessaging messaging;
  late StreamController<RealtimeMessage> realtimeEvents;

  final accepted = fakeFriendsModel(
    docId: 'doc-accepted',
    senderId: 'me',
    recieverId: 'friend-1',
    requestStatus: FriendRequestStatus.accepted,
  );
  final incoming = fakeFriendsModel(
    docId: 'doc-incoming',
    senderId: 'friend-2',
    recieverId: 'me',
    requestStatus: FriendRequestStatus.sent,
    recieverFCMToken: null,
  );
  final outgoing = fakeFriendsModel(
    docId: 'doc-outgoing',
    senderId: 'me',
    recieverId: 'friend-3',
    requestStatus: FriendRequestStatus.sent,
    recieverFCMToken: null,
  );

  void stubUserDoc(List<Map<String, dynamic>> friends) {
    when(tables.getRow(
      databaseId: userDatabaseID,
      tableId: usersTableID,
      rowId: 'me',
      queries: anyNamed('queries'),
    )).thenAnswer((_) async => buildRow(
          id: 'me',
          tableId: usersTableID,
          databaseId: userDatabaseID,
          data: {'friends': friends},
        ));
  }

  setUp(() {
    tables = MockTablesDB();
    realtime = MockRealtime();
    messaging = MockFirebaseMessaging();
    realtimeEvents = StreamController<RealtimeMessage>.broadcast();

    when(messaging.getToken()).thenAnswer((_) async => 'my-fcm-token');
    when(realtime.subscribe(any)).thenAnswer(
      (_) => RealtimeSubscription(
        close: () async {},
        channels: ['databases.$userDatabaseID.tables.$friendsTableID.rows'],
        controller: realtimeEvents,
      ),
    );
  });

  tearDown(() => realtimeEvents.close());

  Future<dynamic> buildContainer() => installTestRootContainer(
        authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
        tables: tables,
        realtime: realtime,
        messaging: messaging,
      );

  group('FriendsNotifier', () {
    test('build partitions accepted and pending into separate lists',
        () async {
      stubUserDoc([
        _friendJson(accepted),
        _friendJson(incoming),
        _friendJson(outgoing),
      ]);
      final container = await buildContainer();

      final state = await container.read(friendsProvider.future);

      expect(state.friends, hasLength(1));
      expect(state.friends.first.docId, 'doc-accepted');
      expect(state.friendRequests, hasLength(2));
      expect(state.friendRequests.map((r) => r.docId),
          containsAll(['doc-incoming', 'doc-outgoing']));
    });

    test('build skips malformed friend rows', () async {
      stubUserDoc([
        _friendJson(accepted),
        {'senderId': 'broken-row'},
      ]);
      final container = await buildContainer();

      final state = await container.read(friendsProvider.future);

      expect(state.friends, hasLength(1));
      expect(state.friendRequests, isEmpty);
    });

    test('sendFriendRequest creates a row and adds an outgoing request',
        () async {
      stubUserDoc([]);
      when(tables.createRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenAnswer((invocation) async => buildRow(
            id: invocation.namedArguments[#rowId] as String,
            data: invocation.namedArguments[#data] as Map<String, dynamic>,
          ));
      final container = await buildContainer();
      await container.read(friendsProvider.future);

      await container.read(friendsProvider.notifier).sendFriendRequest(
            recieverId: 'friend-9',
            recieverProfileImageUrl: 'https://example.com/f9.jpg',
            recieverUsername: 'friend9',
            recieverName: 'Friend Nine',
            recieverRating: 4.2,
          );

      final state = container.read(friendsProvider).value!;
      expect(state.friendRequests, hasLength(1));
      final request = state.friendRequests.first;
      expect(request.recieverName, 'Friend Nine');
      expect(request.senderFCMToken, 'my-fcm-token');
      expect(request.requestSentByUserId, 'me');
      expect(request.requestStatus, FriendRequestStatus.sent);
      verify(tables.createRow(
        databaseId: userDatabaseID,
        tableId: friendsTableID,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).called(1);
    });

    test('acceptFriendRequest moves the request into friends', () async {
      stubUserDoc([_friendJson(accepted), _friendJson(incoming)]);
      when(tables.updateRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenAnswer((invocation) async => buildRow(
            id: invocation.namedArguments[#rowId] as String,
            data: invocation.namedArguments[#data] as Map<String, dynamic>,
          ));
      final container = await buildContainer();
      await container.read(friendsProvider.future);

      await container
          .read(friendsProvider.notifier)
          .acceptFriendRequest(incoming);

      final state = container.read(friendsProvider).value!;
      expect(state.friends, hasLength(2));
      final acceptedNow =
          state.friends.firstWhere((f) => f.docId == 'doc-incoming');
      expect(acceptedNow.requestStatus, FriendRequestStatus.accepted);
      expect(acceptedNow.recieverFCMToken, 'my-fcm-token');
      expect(state.friendRequests, isEmpty);
    });

    test('declineFriendRequest deletes the row and removes the request only',
        () async {
      stubUserDoc([_friendJson(accepted), _friendJson(incoming)]);
      when(tables.deleteRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
      )).thenAnswer((_) async {});
      final container = await buildContainer();
      await container.read(friendsProvider.future);

      await container
          .read(friendsProvider.notifier)
          .declineFriendRequest(incoming);

      final state = container.read(friendsProvider).value!;
      expect(state.friends, hasLength(1));
      expect(state.friendRequests, isEmpty);
      verify(tables.deleteRow(
        databaseId: userDatabaseID,
        tableId: friendsTableID,
        rowId: 'doc-incoming',
      )).called(1);
    });

    test('removeFriend deletes the row and removes the friend', () async {
      stubUserDoc([_friendJson(accepted), _friendJson(incoming)]);
      when(tables.deleteRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
      )).thenAnswer((_) async {});
      final container = await buildContainer();
      await container.read(friendsProvider.future);

      await container.read(friendsProvider.notifier).removeFriend(accepted);

      final state = container.read(friendsProvider).value!;
      expect(state.friends, isEmpty);
      expect(state.friendRequests, hasLength(1));
    });

    test('realtime change involving us reloads the lists', () async {
      stubUserDoc([_friendJson(accepted)]);
      final container = await buildContainer();
      await container.read(friendsProvider.future);
      expect(container.read(friendsProvider).value!.friendRequests, isEmpty);

      // Next reload returns an extra incoming request.
      stubUserDoc([_friendJson(accepted), _friendJson(incoming)]);
      realtimeEvents.add(RealtimeMessage(
        events: [
          'databases.$userDatabaseID.tables.$friendsTableID.rows.doc-incoming.create',
        ],
        payload: _friendJson(incoming),
        channels: ['databases.$userDatabaseID.tables.$friendsTableID.rows'],
        timestamp: DateTime.now().toIso8601String(),
      ));
      await pumpEventQueue();

      final state = container.read(friendsProvider).value!;
      expect(state.friendRequests, hasLength(1));
    });

    test('realtime change for unrelated users is ignored', () async {
      stubUserDoc([_friendJson(accepted)]);
      final container = await buildContainer();
      await container.read(friendsProvider.future);
      clearInteractions(tables);

      realtimeEvents.add(RealtimeMessage(
        events: [
          'databases.$userDatabaseID.tables.$friendsTableID.rows.other.create',
        ],
        payload: {'senderId': 'someone', 'recieverId': 'else'},
        channels: ['databases.$userDatabaseID.tables.$friendsTableID.rows'],
        timestamp: DateTime.now().toIso8601String(),
      ));
      await pumpEventQueue();

      verifyNever(tables.getRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        queries: anyNamed('queries'),
      ));
    });
  });
}
