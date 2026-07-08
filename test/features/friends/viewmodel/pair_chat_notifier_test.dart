import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' show RowList;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/friends/viewmodel/pair_chat_notifier.dart';
import 'package:resonate/features/rooms/viewmodel/livekit_notifier.dart';
import 'package:resonate/models/resonate_user.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

void main() {
  late MockTablesDB tables;
  late MockRealtime realtime;
  late MockFunctions functions;
  late StreamController<RealtimeMessage> activePairEvents;
  late StreamController<RealtimeMessage> pairRequestEvents;

  const activePairsChannel =
      'databases.$masterDatabaseId.tables.$activePairsTableId.rows';
  const pairRequestsChannel =
      'databases.$masterDatabaseId.tables.$pairRequestTableId.rows';

  MockExecution joinExecution() {
    final exec = MockExecution();
    when(exec.responseStatusCode).thenReturn(200);
    when(exec.responseBody).thenReturn(
      '{"access_token":"token-1","livekit_socket_url":"ws://livekit:7880"}',
    );
    return exec;
  }

  setUp(() {
    tables = MockTablesDB();
    realtime = MockRealtime();
    functions = MockFunctions();
    activePairEvents = StreamController<RealtimeMessage>.broadcast();
    pairRequestEvents = StreamController<RealtimeMessage>.broadcast();

    when(tables.createRow(
      databaseId: anyNamed('databaseId'),
      tableId: anyNamed('tableId'),
      rowId: anyNamed('rowId'),
      data: anyNamed('data'),
    )).thenAnswer((invocation) async => buildRow(
          id: 'request-doc-1',
          data: invocation.namedArguments[#data] as Map<String, dynamic>,
        ));
    when(functions.createExecution(
      functionId: anyNamed('functionId'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => joinExecution());
    when(realtime.subscribe(any)).thenAnswer((invocation) {
      final channels =
          List<String>.from(invocation.positionalArguments[0] as List);
      return RealtimeSubscription(
        close: () async {},
        channels: channels,
        controller: channels.first == activePairsChannel
            ? activePairEvents
            : pairRequestEvents,
      );
    });
  });

  tearDown(() async {
    await activePairEvents.close();
    await pairRequestEvents.close();
  });

  Future<dynamic> buildContainer() => installTestRootContainer(
        authState: AuthState.authenticated(
          fakeAuthUser(uid: 'me', userName: 'MeUser'),
        ),
        tables: tables,
        realtime: realtime,
        functions: functions,
      );

  RealtimeMessage pairCreatedEvent({
    String docId = 'pair-doc-1',
    String uid1 = 'me',
    String uid2 = 'partner-1',
    String? userName1 = 'MeUser',
    String? userName2 = 'PartnerUser',
  }) =>
      RealtimeMessage(
        events: ['$activePairsChannel.$docId.create'],
        payload: {
          '\$id': docId,
          'uid1': uid1,
          'uid2': uid2,
          'userName1': userName1,
          'userName2': userName2,
        },
        channels: [activePairsChannel],
        timestamp: DateTime.now().toIso8601String(),
      );

  group('PairChatNotifier', () {
    test('quickMatch creates a random request and stores its doc id',
        () async {
      final container = await buildContainer();

      await container.read(pairChatProvider.notifier).quickMatch();

      expect(container.read(pairChatProvider).requestDocId, 'request-doc-1');
      final data = verify(tables.createRow(
        databaseId: masterDatabaseId,
        tableId: pairRequestTableId,
        rowId: anyNamed('rowId'),
        data: captureAnyNamed('data'),
      )).captured.single as Map<String, dynamic>;
      expect(data['isRandom'], isTrue);
      expect(data['isAnonymous'], isTrue);
      expect(data['uid'], 'me');
      expect(data.containsKey('userName'), isFalse);
    });

    test('quickMatch includes the username when not anonymous', () async {
      final container = await buildContainer();
      container.read(pairChatProvider.notifier).setAnonymous(false);

      await container.read(pairChatProvider.notifier).quickMatch();

      final data = verify(tables.createRow(
        databaseId: masterDatabaseId,
        tableId: pairRequestTableId,
        rowId: anyNamed('rowId'),
        data: captureAnyNamed('data'),
      )).captured.single as Map<String, dynamic>;
      expect(data['userName'], 'MeUser');
    });

    test('choosePartner creates a non-random request with profile data',
        () async {
      final container = await buildContainer();

      await container.read(pairChatProvider.notifier).choosePartner();

      expect(container.read(pairChatProvider).isAnonymous, isFalse);
      final data = verify(tables.createRow(
        databaseId: masterDatabaseId,
        tableId: pairRequestTableId,
        rowId: anyNamed('rowId'),
        data: captureAnyNamed('data'),
      )).captured.single as Map<String, dynamic>;
      expect(data['isRandom'], isFalse);
      expect(data['userName'], 'MeUser');
      expect(data['userRating'], 5.0);
    });

    test('a matching active pair joins LiveKit and stores partner info',
        () async {
      when(tables.getRow(
        databaseId: userDatabaseID,
        tableId: usersTableID,
        rowId: 'partner-1',
      )).thenAnswer((_) async => buildRow(
            id: 'partner-1',
            data: {'profileImageUrl': 'https://example.com/p.jpg'},
          ));
      final container = await buildContainer();
      await container.read(pairChatProvider.notifier).quickMatch();

      activePairEvents.add(pairCreatedEvent());
      await pumpEventQueue();

      final state = container.read(pairChatProvider);
      expect(state.activePairDocId, 'pair-doc-1');
      expect(state.pairUsername, 'PartnerUser');
      expect(state.pairProfileImageUrl, 'https://example.com/p.jpg');
      expect(container.read(liveKitProvider).isConnected, isTrue);
    });

    test('an active pair for other users is ignored', () async {
      final container = await buildContainer();
      await container.read(pairChatProvider.notifier).quickMatch();

      activePairEvents.add(
        pairCreatedEvent(uid1: 'someone', uid2: 'else'),
      );
      await pumpEventQueue();

      expect(container.read(pairChatProvider).activePairDocId, isNull);
      expect(container.read(liveKitProvider).isConnected, isFalse);
    });

    test('a partner profile fetch failure still joins the chat', () async {
      when(tables.getRow(
        databaseId: userDatabaseID,
        tableId: usersTableID,
        rowId: 'partner-1',
      )).thenThrow(AppwriteException('row_not_found', 404));
      final container = await buildContainer();
      await container.read(pairChatProvider.notifier).quickMatch();

      activePairEvents.add(pairCreatedEvent());
      await pumpEventQueue();

      final state = container.read(pairChatProvider);
      expect(state.activePairDocId, 'pair-doc-1');
      expect(state.pairProfileImageUrl, isNull);
      expect(container.read(liveKitProvider).isConnected, isTrue);
    });

    test('remote deletion of the active pair ends the chat', () async {
      when(tables.getRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
      )).thenAnswer((_) async => buildRow(id: 'partner-1', data: {}));
      when(tables.deleteRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
      )).thenAnswer((_) async {});
      final container = await buildContainer();
      await container.read(pairChatProvider.notifier).quickMatch();
      activePairEvents.add(pairCreatedEvent());
      await pumpEventQueue();

      activePairEvents.add(RealtimeMessage(
        events: ['$activePairsChannel.pair-doc-1.delete'],
        payload: {
          '\$id': 'pair-doc-1',
          'uid1': 'me',
          'uid2': 'partner-1',
        },
        channels: [activePairsChannel],
        timestamp: DateTime.now().toIso8601String(),
      ));
      await pumpEventQueue();

      final state = container.read(pairChatProvider);
      expect(state.ended, isTrue);
      expect(container.read(liveKitProvider).isConnected, isFalse);
    });

    test('loadUsers populates the online list and skips malformed rows',
        () async {
      when(tables.listRows(
        databaseId: masterDatabaseId,
        tableId: pairRequestTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => RowList(total: 2, rows: [
            buildRow(id: 'req-1', data: {
              'uid': 'other-1',
              'userName': 'OtherUser',
              'name': 'Other Person',
              'profileImageUrl': 'https://example.com/o.jpg',
              'userRating': 4.5,
            }),
            buildRow(id: 'req-2', data: {
              'uid': 7, // malformed: uid must be a string
            }),
          ]));
      final container = await buildContainer();

      await container.read(pairChatProvider.notifier).loadUsers();

      final state = container.read(pairChatProvider);
      expect(state.isUserListLoading, isFalse);
      expect(state.onlineUsers, hasLength(1));
      expect(state.onlineUsers.first.userName, 'OtherUser');
      expect(state.onlineUsers.first.docId, 'req-1');
    });

    test('new pair requests stream into the online list, skipping our own',
        () async {
      final container = await buildContainer();
      await container.read(pairChatProvider.notifier).choosePartner();

      RealtimeMessage requestEvent(String uid, {bool anonymous = false}) =>
          RealtimeMessage(
            events: ['$pairRequestsChannel.req-$uid.create'],
            payload: {
              'uid': uid,
              'isAnonymous': anonymous,
              'userName': 'User-$uid',
              'name': 'Name $uid',
              'profileImageUrl': 'https://example.com/$uid.jpg',
              'userRating': 3.0,
            },
            channels: [pairRequestsChannel],
            timestamp: DateTime.now().toIso8601String(),
          );

      pairRequestEvents.add(requestEvent('other-1'));
      pairRequestEvents.add(requestEvent('me')); // our own request
      pairRequestEvents.add(requestEvent('anon-1', anonymous: true));
      await pumpEventQueue();

      var state = container.read(pairChatProvider);
      expect(state.onlineUsers.map((u) => u.uid), ['other-1']);

      pairRequestEvents.add(RealtimeMessage(
        events: ['$pairRequestsChannel.req-other-1.delete'],
        payload: {'uid': 'other-1'},
        channels: [pairRequestsChannel],
        timestamp: DateTime.now().toIso8601String(),
      ));
      await pumpEventQueue();

      state = container.read(pairChatProvider);
      expect(state.onlineUsers, isEmpty);
    });

    test('pairWithSelectedUser creates the active pair row', () async {
      final container = await buildContainer();
      await container.read(pairChatProvider.notifier).choosePartner();
      clearInteractions(tables);
      when(tables.createRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenAnswer((invocation) async => buildRow(
            id: 'pair-doc-1',
            data: invocation.namedArguments[#data] as Map<String, dynamic>,
          ));

      await container.read(pairChatProvider.notifier).pairWithSelectedUser(
            const ResonateUser(
              uid: 'partner-1',
              userName: 'PartnerUser',
              docId: 'req-partner',
            ),
          );

      final data = verify(tables.createRow(
        databaseId: masterDatabaseId,
        tableId: activePairsTableId,
        rowId: anyNamed('rowId'),
        data: captureAnyNamed('data'),
      )).captured.single as Map<String, dynamic>;
      expect(data['uid1'], 'me');
      expect(data['uid2'], 'partner-1');
      expect(data['userName2'], 'PartnerUser');
    });

    test('cancelRequest deletes the pending request', () async {
      when(tables.deleteRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
      )).thenAnswer((_) async {});
      final container = await buildContainer();
      await container.read(pairChatProvider.notifier).quickMatch();

      await container.read(pairChatProvider.notifier).cancelRequest();

      expect(container.read(pairChatProvider).requestDocId, isNull);
      verify(tables.deleteRow(
        databaseId: masterDatabaseId,
        tableId: pairRequestTableId,
        rowId: 'request-doc-1',
      )).called(1);
    });

    test('endChat tolerates the pair row already being deleted', () async {
      when(tables.getRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
      )).thenAnswer((_) async => buildRow(id: 'partner-1', data: {}));
      when(tables.deleteRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
      )).thenThrow(AppwriteException('not found', 404, 'document_not_found'));
      final container = await buildContainer();
      await container.read(pairChatProvider.notifier).quickMatch();
      activePairEvents.add(pairCreatedEvent());
      await pumpEventQueue();

      await container.read(pairChatProvider.notifier).endChat();

      expect(container.read(pairChatProvider).ended, isTrue);
    });

    test('submitRating updates the user rating row', () async {
      when(tables.updateRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenAnswer((invocation) async => buildRow(
            id: 'me',
            data: invocation.namedArguments[#data] as Map<String, dynamic>,
          ));
      final container = await buildContainer();
      container.read(pairChatProvider.notifier).setPairRating(4.0);

      await container.read(pairChatProvider.notifier).submitRating();

      final data = verify(tables.updateRow(
        databaseId: userDatabaseID,
        tableId: usersTableID,
        rowId: 'me',
        data: captureAnyNamed('data'),
      )).captured.single as Map<String, dynamic>;
      // fakeAuthUser defaults: ratingTotal 5, ratingCount 1.
      expect(data['ratingTotal'], 9.0);
      expect(data['ratingCount'], 2);
    });
  });
}
