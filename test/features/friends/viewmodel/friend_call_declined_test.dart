import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/friends/data/friend_call_coordinator.dart';
import 'package:resonate/features/friends/model/friend_call_model.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/friend_call_status.dart';
import 'package:resonate/utils/enums/friend_request_status.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

class _RecordingRouter extends GoRouter {
  _RecordingRouter()
    : super.routingConfig(
        routingConfig: ValueNotifier(
          RoutingConfig(
            routes: [
              GoRoute(path: '/', builder: (_, _) => const SizedBox.shrink()),
            ],
          ),
        ),
      );

  final List<String> calls = [];

  @override
  Future<T?> push<T extends Object?>(String location, {Object? extra}) async {
    calls.add('push $location');
    return null;
  }

  @override
  void go(String location, {Object? extra}) => calls.add('go $location');

  @override
  Future<T?> pushReplacement<T extends Object?>(
    String location, {
    Object? extra,
  }) async {
    calls.add('replace $location');
    return null;
  }
}

void main() {
  late MockTablesDB tables;
  late MockRealtime realtime;
  late MockFunctions functions;
  late StreamController<RealtimeMessage> realtimeEvents;

  // The friendship row was created by them; I am the receiver side of it.
  final friendWhereIAmReceiver = fakeFriendsModel(
    senderId: 'them',
    recieverId: 'me',
    senderName: 'Them',
    recieverName: 'Me',
    senderUsername: 'them',
    recieverUsername: 'me',
    requestStatus: FriendRequestStatus.accepted,
    docId: 'friendship-doc',
  );

  Map<String, dynamic> callJson(FriendCallModel call) => {
    ...call.toJson(),
    '\$id': call.docId,
  };

  MockExecution okExecution() {
    final exec = MockExecution();
    when(exec.responseStatusCode).thenReturn(200);
    when(exec.responseBody).thenReturn(
      '{"access_token":"t","livekit_socket_url":"wss://host.docker.internal:7880"}',
    );
    return exec;
  }

  setUp(() {
    tables = MockTablesDB();
    realtime = MockRealtime();
    functions = MockFunctions();
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
    ).thenAnswer((_) async => okExecution());
    when(realtime.subscribe(any)).thenAnswer(
      (invocation) => RealtimeSubscription(
        close: () async {},
        unsubscribe: () async {},
        update: ({List<Object>? channels, List<String>? queries}) async {},
        queries: const [],
        channels: List<String>.from(invocation.positionalArguments[0] as List),
        controller: realtimeEvents,
      ),
    );
  });

  tearDown(() => realtimeEvents.close());

  Future<dynamic> buildContainer({_RecordingRouter? router}) =>
      installTestRootContainer(
        overrides: [
          if (router != null) routerProvider.overrideWithValue(router),
        ],
        authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
        tables: tables,
        realtime: realtime,
        functions: functions,
      );

  Future<void> emitCall(FriendCallModel call) async {
    final channel = 'databases.$databaseId.tables.$friendCallsTableId.rows';
    realtimeEvents.add(
      RealtimeMessage(
        events: ['$channel.${call.docId}.update'],
        payload: callJson(call),
        channels: [channel],
        timestamp: '',
      ),
    );
    for (var i = 0; i < 6; i++) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  // Whichever side of the friendship row I am on, I am the caller.
  test('calling from the receiver side still makes me the caller', () async {
    final container = await buildContainer();

    await container
        .read(friendCallCoordinatorProvider.notifier)
        .startCall(friendWhereIAmReceiver);

    final call = container.read(friendCallCoordinatorProvider).activeCall!;
    expect(call.callerUid, 'me');
    expect(call.recieverUid, 'them');
    expect(call.callerName, 'Me');
    expect(call.recieverName, 'Them');
    expect(call.callerUsername, 'me');
    expect(call.recieverUsername, 'them');
  });

  group('when the other side declines', () {
    test('the call is marked declined and torn down', () async {
      final router = _RecordingRouter();
      final container = await buildContainer(router: router);
      await container
          .read(friendCallCoordinatorProvider.notifier)
          .startCall(friendWhereIAmReceiver);
      final call = container.read(friendCallCoordinatorProvider).activeCall!;

      await emitCall(call.copyWith(callStatus: FriendCallStatus.declined));

      expect(
        container.read(friendCallCoordinatorProvider).activeCall?.callStatus,
        FriendCallStatus.declined,
      );
      expect(router.calls, contains('go ${RoutePathsForTest.tabview}'));
    });

    // A second decline for a call already marked declined must not re-run the
    // teardown and bounce the user again.
    test('a repeated decline does not navigate twice', () async {
      final router = _RecordingRouter();
      final container = await buildContainer(router: router);
      await container
          .read(friendCallCoordinatorProvider.notifier)
          .startCall(friendWhereIAmReceiver);
      final call = container.read(friendCallCoordinatorProvider).activeCall!;

      await emitCall(call.copyWith(callStatus: FriendCallStatus.declined));
      final after = router.calls.length;
      await emitCall(call.copyWith(callStatus: FriendCallStatus.declined));

      expect(router.calls.length, after);
    });
  });

  group('mic and hang-up are best effort', () {
    test('a failed status write does not throw out of endCall', () async {
      final container = await buildContainer();
      await container
          .read(friendCallCoordinatorProvider.notifier)
          .startCall(friendWhereIAmReceiver);
      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenThrow(AppwriteException('offline'));

      await expectLater(
        container.read(friendCallCoordinatorProvider.notifier).endCall(),
        completes,
      );
    });

    test('toggling the mic with no session does not throw', () async {
      final container = await buildContainer();

      await expectLater(
        container.read(friendCallCoordinatorProvider.notifier).toggleMic(),
        completes,
      );
    });
  });
}

class RoutePathsForTest {
  static const tabview = '/tabview';
}
