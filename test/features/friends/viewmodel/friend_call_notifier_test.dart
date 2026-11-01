import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/friends/model/friend_call_model.dart';
import 'package:resonate/features/friends/model/friends_state.dart';
import 'package:resonate/features/friends/data/services/friend_call_coordinator.dart';
import 'package:resonate/features/rooms/data/services/livekit_controller.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/friend_call_status.dart';
import 'package:resonate/utils/enums/friend_request_status.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

void main() {
  late MockTablesDB tables;
  late MockRealtime realtime;
  late MockFunctions functions;
  late FakeCallKitService callKit;
  late StreamController<RealtimeMessage> realtimeEvents;

  // I am the sender of the friendship doc, calling reciever-1.
  final friend = fakeFriendsModel(
    senderId: 'me',
    recieverId: 'reciever-1',
    senderName: 'Me',
    recieverName: 'Friend',
    requestStatus: FriendRequestStatus.accepted,
    recieverFCMToken: 'their-token',
    docId: 'friendship-doc',
  );

  Map<String, dynamic> callJson(FriendCallModel call) => {
    ...call.toJson(),
    '\$id': call.docId,
  };

  MockExecution joinExecution() {
    final exec = MockExecution();
    when(exec.responseStatusCode).thenReturn(200);
    when(exec.responseBody).thenReturn(
      '{"access_token":"token-1","livekit_socket_url":"wss://host.docker.internal:7880"}',
    );
    return exec;
  }

  setUp(() {
    tables = MockTablesDB();
    realtime = MockRealtime();
    functions = MockFunctions();
    callKit = FakeCallKitService();
    realtimeEvents = StreamController<RealtimeMessage>.broadcast();

    when(
      tables.createRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      ),
    ).thenAnswer(
      (invocation) async => buildRow(
        id: invocation.namedArguments[#rowId] as String,
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
    ).thenAnswer(
      (invocation) async => buildRow(
        id: invocation.namedArguments[#rowId] as String,
        data: invocation.namedArguments[#data] as Map<String, dynamic>,
      ),
    );
    when(
      functions.createExecution(
        functionId: anyNamed('functionId'),
        body: anyNamed('body'),
      ),
    ).thenAnswer((_) async => joinExecution());
    when(realtime.subscribe(any)).thenAnswer(
      (invocation) => RealtimeSubscription(
        close: () async {},
        channels: List<String>.from(invocation.positionalArguments[0] as List),
        controller: realtimeEvents,
      ),
    );
  });

  tearDown(() => realtimeEvents.close());

  Future<dynamic> buildContainer() => installTestRootContainer(
    authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
    tables: tables,
    realtime: realtime,
    functions: functions,
    callKit: callKit,
  );

  group('FriendCallCoordinator', () {
    test(
      'startCall creates the call row, rings over FCM, and sets waiting',
      () async {
        final container = await buildContainer();

        await container
            .read(friendCallCoordinatorProvider.notifier)
            .startCall(friend);

        final state = container.read(friendCallCoordinatorProvider);
        expect(state.activeCall, isNotNull);
        expect(state.activeCall!.callStatus, FriendCallStatus.waiting);
        expect(state.activeCall!.callerUid, 'me');
        expect(state.activeCall!.recieverUid, 'reciever-1');
        expect(state.activeCall!.livekitRoomId, 'friendship-doc');
        verify(
          tables.createRow(
            databaseId: masterDatabaseId,
            tableId: friendCallsTableId,
            rowId: anyNamed('rowId'),
            data: anyNamed('data'),
          ),
        ).called(1);
        verify(
          functions.createExecution(
            functionId: startFriendCallFunctionID,
            body: anyNamed('body'),
          ),
        ).called(1);
      },
    );

    test('startCall throws when the friend has no FCM token', () async {
      final container = await buildContainer();
      final tokenless = fakeFriendsModel(
        senderId: 'me',
        recieverId: 'reciever-1',
        recieverFCMToken: null,
      );

      expect(
        () => container
            .read(friendCallCoordinatorProvider.notifier)
            .startCall(tokenless),
        throwsA(isA<FriendsFailureUnknown>()),
      );
    });

    test('realtime connected update joins LiveKit on the caller side', () async {
      final container = await buildContainer();
      final notifier = container.read(friendCallCoordinatorProvider.notifier);
      await notifier.startCall(friend);
      final call = container.read(friendCallCoordinatorProvider).activeCall!;

      realtimeEvents.add(
        RealtimeMessage(
          events: [
            'databases.$masterDatabaseId.tables.$friendCallsTableId.rows.${call.docId}.update',
          ],
          payload: callJson(
            call.copyWith(callStatus: FriendCallStatus.connected),
          ),
          channels: [
            'databases.$masterDatabaseId.tables.$friendCallsTableId.rows.${call.docId}',
          ],
          timestamp: DateTime.now().toIso8601String(),
        ),
      );
      await pumpEventQueue();

      expect(
        container.read(friendCallCoordinatorProvider).activeCall!.callStatus,
        FriendCallStatus.connected,
      );
      expect(container.read(liveKitControllerProvider).isConnected, isTrue);
    });

    test('realtime ended update tears the call down', () async {
      final container = await buildContainer();
      final notifier = container.read(friendCallCoordinatorProvider.notifier);
      await notifier.startCall(friend);
      final call = container.read(friendCallCoordinatorProvider).activeCall!;

      realtimeEvents.add(
        RealtimeMessage(
          events: [
            'databases.$masterDatabaseId.tables.$friendCallsTableId.rows.${call.docId}.update',
          ],
          payload: callJson(call.copyWith(callStatus: FriendCallStatus.ended)),
          channels: [
            'databases.$masterDatabaseId.tables.$friendCallsTableId.rows.${call.docId}',
          ],
          timestamp: DateTime.now().toIso8601String(),
        ),
      );
      await pumpEventQueue();

      expect(
        container.read(friendCallCoordinatorProvider).activeCall!.callStatus,
        FriendCallStatus.ended,
      );
      expect(callKit.endAllCallsCount, 1);
      expect(container.read(liveKitControllerProvider).isConnected, isFalse);
    });

    test('onAnswerCall marks the call connected and joins LiveKit', () async {
      final container = await buildContainer();
      final incoming = FriendCallModel(
        callerName: 'Friend',
        recieverName: 'Me',
        callerUsername: 'friend',
        recieverUsername: 'me',
        callerUid: 'caller-1',
        recieverUid: 'me',
        callerProfileImageUrl: 'https://example.com/c.jpg',
        recieverProfileImageUrl: 'https://example.com/m.jpg',
        livekitRoomId: 'friendship-doc',
        callStatus: FriendCallStatus.waiting,
        docId: 'call-doc',
      );
      when(
        tables.getRow(
          databaseId: masterDatabaseId,
          tableId: friendCallsTableId,
          rowId: 'call-doc',
        ),
      ).thenAnswer(
        (_) async => buildRow(id: 'call-doc', data: callJson(incoming)),
      );

      await container.read(friendCallCoordinatorProvider.notifier).onAnswerCall(
        {'call_id': 'call-doc'},
      );

      final state = container.read(friendCallCoordinatorProvider);
      expect(state.activeCall!.callStatus, FriendCallStatus.connected);
      expect(container.read(liveKitControllerProvider).isConnected, isTrue);
      verify(
        tables.updateRow(
          databaseId: masterDatabaseId,
          tableId: friendCallsTableId,
          rowId: 'call-doc',
          data: anyNamed('data'),
        ),
      ).called(1);
    });

    test('onAnswerCall does nothing when the call already ended', () async {
      final container = await buildContainer();
      final endedCall = FriendCallModel(
        callerName: 'Friend',
        recieverName: 'Me',
        callerUsername: 'friend',
        recieverUsername: 'me',
        callerUid: 'caller-1',
        recieverUid: 'me',
        callerProfileImageUrl: 'https://example.com/c.jpg',
        recieverProfileImageUrl: 'https://example.com/m.jpg',
        livekitRoomId: 'friendship-doc',
        callStatus: FriendCallStatus.ended,
        docId: 'call-doc',
      );
      when(
        tables.getRow(
          databaseId: masterDatabaseId,
          tableId: friendCallsTableId,
          rowId: 'call-doc',
        ),
      ).thenAnswer(
        (_) async => buildRow(id: 'call-doc', data: callJson(endedCall)),
      );

      await container.read(friendCallCoordinatorProvider.notifier).onAnswerCall(
        {'call_id': 'call-doc'},
      );

      expect(container.read(friendCallCoordinatorProvider).activeCall, isNull);
      verifyNever(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      );
    });

    test('onDeclinedCall marks the call declined', () async {
      final container = await buildContainer();
      final incoming = FriendCallModel(
        callerName: 'Friend',
        recieverName: 'Me',
        callerUsername: 'friend',
        recieverUsername: 'me',
        callerUid: 'caller-1',
        recieverUid: 'me',
        callerProfileImageUrl: 'https://example.com/c.jpg',
        recieverProfileImageUrl: 'https://example.com/m.jpg',
        livekitRoomId: 'friendship-doc',
        callStatus: FriendCallStatus.waiting,
        docId: 'call-doc',
      );
      when(
        tables.getRow(
          databaseId: masterDatabaseId,
          tableId: friendCallsTableId,
          rowId: 'call-doc',
        ),
      ).thenAnswer(
        (_) async => buildRow(id: 'call-doc', data: callJson(incoming)),
      );

      await container
          .read(friendCallCoordinatorProvider.notifier)
          .onDeclinedCall({'call_id': 'call-doc'});

      expect(
        container.read(friendCallCoordinatorProvider).activeCall!.callStatus,
        FriendCallStatus.declined,
      );
    });

    test('endCall updates the row and tears everything down', () async {
      final container = await buildContainer();
      final notifier = container.read(friendCallCoordinatorProvider.notifier);
      await notifier.startCall(friend);

      await notifier.endCall();

      final state = container.read(friendCallCoordinatorProvider);
      expect(state.activeCall!.callStatus, FriendCallStatus.ended);
      expect(callKit.endAllCallsCount, 1);
      expect(container.read(liveKitControllerProvider).isConnected, isFalse);
    });

    test('toggleMic and toggleLoudSpeaker flip their flags', () async {
      final container = await buildContainer();
      final notifier = container.read(friendCallCoordinatorProvider.notifier);

      expect(container.read(friendCallCoordinatorProvider).isMicOn, isFalse);
      await notifier.toggleMic();
      expect(container.read(friendCallCoordinatorProvider).isMicOn, isTrue);

      expect(
        container.read(friendCallCoordinatorProvider).isLoudSpeakerOn,
        isTrue,
      );
      await notifier.toggleLoudSpeaker();
      expect(
        container.read(friendCallCoordinatorProvider).isLoudSpeakerOn,
        isFalse,
      );
    });
  });
}
