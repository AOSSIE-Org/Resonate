import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' show Row, RowList;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/friends/data/pair_chat_session.dart';
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
      'databases.$databaseId.tables.$activePairsTableId.rows';

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

    when(
      tables.createRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      ),
    ).thenAnswer(
      (invocation) async => buildRow(
        id: 'request-doc-1',
        data: invocation.namedArguments[#data] as Map<String, dynamic>,
      ),
    );
    when(
      tables.updateRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      ),
    ).thenAnswer((_) async => buildRow(id: 'request-doc-1', data: const {}));
    when(
      tables.deleteRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
      ),
    ).thenAnswer((_) async {});
    when(
      functions.createExecution(
        functionId: anyNamed('functionId'),
        body: anyNamed('body'),
      ),
    ).thenAnswer((_) async => joinExecution());
    when(realtime.subscribe(any)).thenAnswer((invocation) {
      final channels = List<String>.from(
        invocation.positionalArguments[0] as List,
      );
      return RealtimeSubscription(
        close: () async {},
        unsubscribe: () async {},
        update: ({List<Object>? channels, List<String>? queries}) async {},
        queries: const [],
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

  void stubUserList(List<Row> rows) {
    when(
      tables.listRows(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        queries: anyNamed('queries'),
      ),
    ).thenAnswer((_) async => RowList(total: rows.length, rows: rows));
  }

  test('setLanguage records the chosen language', () async {
    final container = await buildContainer();

    container.read(pairChatProvider.notifier).setLanguage('hi');

    expect(container.read(pairChatProvider).languageIso, 'hi');
  });

  group('the online user list', () {
    // The pairing screen must stop spinning even when the list cannot load.
    test('a failed load clears the loading flag', () async {
      when(
        tables.listRows(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          queries: anyNamed('queries'),
        ),
      ).thenThrow(AppwriteException('offline'));
      final container = await buildContainer();

      await container.read(pairChatProvider.notifier).loadUsers();

      expect(container.read(pairChatProvider).isUserListLoading, isFalse);
    });

    test('an empty list is not an error', () async {
      stubUserList([]);
      final container = await buildContainer();

      await container.read(pairChatProvider.notifier).loadUsers();

      expect(container.read(pairChatProvider).isUserListLoading, isFalse);
      expect(container.read(pairChatProvider).onlineUsers, isEmpty);
    });
  });

  group('convertToRandom', () {
    // Giving up on a specific partner turns the pending request into a
    // random one rather than starting over.
    test('rewrites the pending request', () async {
      stubUserList([]);
      final container = await buildContainer();
      await container.read(pairChatProvider.notifier).choosePartner();

      await container.read(pairChatProvider.notifier).convertToRandom();

      verify(
        tables.updateRow(
          databaseId: databaseId,
          tableId: pairRequestTableId,
          rowId: 'request-doc-1',
          data: anyNamed('data'),
        ),
      ).called(1);
    });
  });

  group('best-effort teardown', () {
    test('a failed cancel does not throw', () async {
      final container = await buildContainer();
      await container.read(pairChatProvider.notifier).quickMatch();
      when(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenThrow(AppwriteException('already gone'));

      await expectLater(
        container.read(pairChatProvider.notifier).cancelRequest(),
        completes,
      );
    });

    test('ending a chat that was already torn down does not throw', () async {
      final container = await buildContainer();
      when(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenThrow(AppwriteException('already gone'));

      await expectLater(
        container.read(pairChatProvider.notifier).endChat(),
        completes,
      );
    });
  });

  group('the mic', () {
    test('flips locally even when LiveKit refuses', () async {
      final container = await buildContainer();
      expect(container.read(pairChatProvider).isMicOn, isFalse);

      await container.read(pairChatProvider.notifier).toggleMic();

      expect(container.read(pairChatProvider).isMicOn, isTrue);
    });

    test('toggles back', () async {
      final container = await buildContainer();
      await container.read(pairChatProvider.notifier).toggleMic();

      await container.read(pairChatProvider.notifier).toggleMic();

      expect(container.read(pairChatProvider).isMicOn, isFalse);
    });
  });

  group('a malformed pairing event', () {
    // Without a partner uid there is nobody to connect to, so the session
    // must bail rather than join a half-built room.
    test('with no partner uid does not join', () async {
      final container = await buildContainer();
      await container.read(pairChatProvider.notifier).quickMatch();

      activePairEvents.add(
        RealtimeMessage(
          events: ['$activePairsChannel.pair-doc-1.create'],
          payload: {
            '\$id': 'pair-doc-1',
            'users': ['me'],
          },
          channels: const [activePairsChannel],
          timestamp: '',
        ),
      );
      for (var i = 0; i < 6; i++) {
        await Future<void>.delayed(Duration.zero);
      }

      expect(container.read(pairChatProvider).activePairDocId, isNull);
      expect(container.read(pairChatProvider).pairUsername, isNull);
      verifyNever(
        functions.createExecution(
          functionId: joinRoomServiceId,
          body: anyNamed('body'),
        ),
      );
    });
  });
}
