import 'dart:async';
import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart' as enums;
import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/core/services/api_service.dart';
import 'package:resonate/features/friends/data/repositories/friend_call_repository.dart';
import 'package:resonate/features/friends/model/friend_call_model.dart';
import 'package:resonate/features/friends/model/friends_state.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/friend_call_status.dart';

import 'friend_call_repository_test.mocks.dart';

@GenerateMocks([TablesDB, Realtime, Functions, RealtimeSubscription])
// Builds a FriendCallModel row. fromJson reads $id for docId.
Row callRow({
  String id = 'call-1',
  String callerName = 'Caller',
  String recieverName = 'Reciever',
  String callerUsername = 'caller',
  String recieverUsername = 'reciever',
  String callerUid = 'caller-uid',
  String recieverUid = 'reciever-uid',
  String callerProfileImageUrl = 'https://example.com/c.jpg',
  String recieverProfileImageUrl = 'https://example.com/r.jpg',
  String livekitRoomId = 'lk-room-1',
  FriendCallStatus callStatus = FriendCallStatus.waiting,
}) {
  final model = FriendCallModel(
    callerName: callerName,
    recieverName: recieverName,
    callerUsername: callerUsername,
    recieverUsername: recieverUsername,
    callerUid: callerUid,
    recieverUid: recieverUid,
    callerProfileImageUrl: callerProfileImageUrl,
    recieverProfileImageUrl: recieverProfileImageUrl,
    livekitRoomId: livekitRoomId,
    callStatus: callStatus,
    docId: id,
  );
  return Row(
    $id: id,
    $sequence: 0,
    $tableId: friendCallsTableId,
    $databaseId: masterDatabaseId,
    $createdAt: DateTime.now().toIso8601String(),
    $updatedAt: DateTime.now().toIso8601String(),
    $permissions: const [],
    data: {...model.toJson(), '\$id': id},
  );
}

FriendCallModel fakeCall({
  String docId = 'call-1',
  FriendCallStatus callStatus = FriendCallStatus.waiting,
}) => FriendCallModel(
  callerName: 'Caller',
  recieverName: 'Reciever',
  callerUsername: 'caller',
  recieverUsername: 'reciever',
  callerUid: 'caller-uid',
  recieverUid: 'reciever-uid',
  callerProfileImageUrl: 'https://example.com/c.jpg',
  recieverProfileImageUrl: 'https://example.com/r.jpg',
  livekitRoomId: 'lk-room-1',
  callStatus: callStatus,
  docId: docId,
);

// Real Execution with a 200 join response body.
Execution joinExecution(Map<String, dynamic> data) => Execution(
  $id: 'exec-1',
  $createdAt: '2023-01-01',
  $updatedAt: '2023-01-01',
  $permissions: const [],
  functionId: 'func-1',
  trigger: enums.ExecutionTrigger.http,
  status: enums.ExecutionStatus.completed,
  requestMethod: 'POST',
  requestPath: '/',
  requestHeaders: const [],
  responseStatusCode: 200,
  responseBody: jsonEncode(data),
  responseHeaders: const [],
  logs: '',
  errors: '',
  duration: 0.1,
  deploymentId: 'dep-1',
);

void main() {
  late MockTablesDB tables;
  late MockRealtime realtime;
  late MockFunctions functions;
  late FriendCallRepository repo;

  setUp(() {
    tables = MockTablesDB();
    realtime = MockRealtime();
    functions = MockFunctions();
    repo = FriendCallRepository(
      tables: tables,
      realtime: realtime,
      functions: functions,
      apiService: ApiService(functions: functions),
    );
  });

  group('createCall', () {
    test('builds a waiting call and writes it to the master db', () async {
      when(
        tables.createRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => callRow());

      final call = await repo.createCall(
        callerName: 'Caller',
        recieverName: 'Reciever',
        callerUsername: 'caller',
        recieverUsername: 'reciever',
        callerUid: 'caller-uid',
        recieverUid: 'reciever-uid',
        callerProfileImageUrl: 'https://example.com/c.jpg',
        recieverProfileImageUrl: 'https://example.com/r.jpg',
        livekitRoomId: 'lk-room-1',
      );

      expect(call.callStatus, FriendCallStatus.waiting);
      expect(call.docId, isNotEmpty);
      expect(call.livekitRoomId, 'lk-room-1');

      final captured = verify(
        tables.createRow(
          databaseId: masterDatabaseId,
          tableId: friendCallsTableId,
          rowId: call.docId,
          data: captureAnyNamed('data'),
        ),
      ).captured.single as Map<String, dynamic>;
      expect(captured['callStatus'], 'waiting');
      expect(captured['callerUid'], 'caller-uid');
      expect(captured.containsKey('\$id'), isFalse);
    });

    test('maps AppwriteException 401 to permissionDenied', () async {
      when(
        tables.createRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenThrow(AppwriteException('unauthorized', 401));

      expect(
        repo.createCall(
          callerName: 'Caller',
          recieverName: 'Reciever',
          callerUsername: 'caller',
          recieverUsername: 'reciever',
          callerUid: 'caller-uid',
          recieverUid: 'reciever-uid',
          callerProfileImageUrl: 'https://example.com/c.jpg',
          recieverProfileImageUrl: 'https://example.com/r.jpg',
          livekitRoomId: 'lk-room-1',
        ),
        throwsA(isA<FriendsFailurePermissionDenied>()),
      );
    });
  });

  group('getCall', () {
    test('parses the row into a FriendCallModel', () async {
      when(
        tables.getRow(
          databaseId: masterDatabaseId,
          tableId: friendCallsTableId,
          rowId: 'call-1',
        ),
      ).thenAnswer(
        (_) async =>
            callRow(id: 'call-1', callStatus: FriendCallStatus.connected),
      );

      final call = await repo.getCall('call-1');

      expect(call.docId, 'call-1');
      expect(call.callStatus, FriendCallStatus.connected);
      expect(call.callerUid, 'caller-uid');
      verify(
        tables.getRow(
          databaseId: masterDatabaseId,
          tableId: friendCallsTableId,
          rowId: 'call-1',
        ),
      ).called(1);
    });

    test('maps AppwriteException 404 to notFound', () async {
      when(
        tables.getRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenThrow(AppwriteException('missing', 404));

      expect(
        repo.getCall('missing'),
        throwsA(isA<FriendsFailureNotFound>()),
      );
    });
  });

  group('setCallStatus', () {
    test('copies the status and updates the row', () async {
      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => callRow());

      final call = fakeCall(callStatus: FriendCallStatus.waiting);
      final updated = await repo.setCallStatus(call, FriendCallStatus.ended);

      expect(updated.callStatus, FriendCallStatus.ended);
      final captured = verify(
        tables.updateRow(
          databaseId: masterDatabaseId,
          tableId: friendCallsTableId,
          rowId: 'call-1',
          data: captureAnyNamed('data'),
        ),
      ).captured.single as Map<String, dynamic>;
      expect(captured['callStatus'], 'ended');
    });

    test('maps AppwriteException 403 to permissionDenied', () async {
      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenThrow(AppwriteException('forbidden', 403));

      expect(
        repo.setCallStatus(fakeCall(), FriendCallStatus.ended),
        throwsA(isA<FriendsFailurePermissionDenied>()),
      );
    });
  });

  group('sendCallNotification', () {
    test('invokes the start-friend-call function with the incoming-call body',
        () async {
      when(
        functions.createExecution(
          functionId: anyNamed('functionId'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => joinExecution({'ok': true}));

      final call = fakeCall();
      await repo.sendCallNotification(
        call: call,
        recieverFCMToken: 'fcm-token-1',
      );

      final body = verify(
        functions.createExecution(
          functionId: startFriendCallFunctionID,
          body: captureAnyNamed('body'),
        ),
      ).captured.single as String;

      final decoded = jsonDecode(body) as Map<String, dynamic>;
      expect(decoded['recieverFCMToken'], 'fcm-token-1');
      final data = decoded['data'] as Map<String, dynamic>;
      expect(data['type'], 'incoming_call');
      expect(data['call_id'], call.docId);
      expect(data['livekit_room_id'], call.livekitRoomId);
      expect(data['caller_name'], call.callerName);
      expect(data['caller_username'], call.callerUsername);
      expect(data['caller_uid'], call.callerUid);
      expect(data['caller_profile_image_url'], call.callerProfileImageUrl);
      // extra is the jsonEncoded call itself.
      final extra = jsonDecode(data['extra'] as String) as Map<String, dynamic>;
      expect(extra['callerUid'], call.callerUid);
    });
  });

  group('callStream', () {
    test('subscribes to the per-doc channel and emits non-empty payloads',
        () async {
      final sub = MockRealtimeSubscription();
      final controller = StreamController<RealtimeMessage>.broadcast();
      final channel =
          'databases.$masterDatabaseId.tables.$friendCallsTableId.rows.call-1';

      when(realtime.subscribe([channel])).thenReturn(sub);
      when(sub.stream).thenAnswer((_) => controller.stream);
      when(sub.close).thenReturn(() async {});

      final emitted = <RealtimeMessage>[];
      final streamSub = repo.callStream('call-1').listen(emitted.add);

      // Empty payload is filtered out.
      controller.add(
        RealtimeMessage(
          events: const [],
          payload: const {},
          channels: [channel],
          timestamp: DateTime.now().toIso8601String(),
        ),
      );
      // Non-empty payload is forwarded.
      controller.add(
        RealtimeMessage(
          events: ['$channel.update'],
          payload: {'callStatus': 'connected'},
          channels: [channel],
          timestamp: DateTime.now().toIso8601String(),
        ),
      );
      await pumpEventQueue();

      expect(emitted, hasLength(1));
      expect(emitted.single.payload['callStatus'], 'connected');
      verify(realtime.subscribe([channel])).called(1);

      await streamSub.cancel();
      await controller.close();
    });
  });

  group('callJoinInfo', () {
    test('delegates to ApiService.joinRoom and maps the response', () async {
      when(
        functions.createExecution(
          functionId: joinRoomServiceId,
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => joinExecution({
          'access_token': 'token-1',
          'livekit_socket_url': 'wss://real-host:7880',
        }),
      );

      final info = await repo.callJoinInfo(roomId: 'lk-room-1', userId: 'u1');

      expect(info.roomToken, 'token-1');
      expect(info.liveKitUri, 'wss://real-host:7880');
      verify(
        functions.createExecution(
          functionId: joinRoomServiceId,
          body: anyNamed('body'),
        ),
      ).called(1);
    });

    test('rewrites the docker socket url to the localhost endpoint', () async {
      when(
        functions.createExecution(
          functionId: joinRoomServiceId,
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => joinExecution({
          'access_token': 'token-2',
          'livekit_socket_url': 'wss://host.docker.internal:7880',
        }),
      );

      final info = await repo.callJoinInfo(roomId: 'lk-room-1', userId: 'u1');

      expect(info.liveKitUri, localhostLivekitEndpoint);
      expect(info.roomToken, 'token-2');
    });
  });
}
