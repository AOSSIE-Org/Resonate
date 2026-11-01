import 'dart:async';
import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart' as enums;
import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/rooms/data/repositories/room_chat_repository.dart';
import 'package:resonate/features/rooms/model/reply_to.dart';
import 'package:resonate/features/rooms/model/room_message.dart';
import 'package:resonate/utils/constants.dart';

import 'room_chat_repository_test.mocks.dart';

@GenerateMocks([TablesDB, Realtime, Functions, RealtimeSubscription])
// Builds a chat message row payload matching RoomMessage.fromJson.
Map<String, dynamic> messageData({
  String roomId = 'room-1',
  String messageId = 'msg-1',
  String creatorId = 'me',
  String creatorUsername = 'me',
  String creatorName = 'Me',
  String creatorImgUrl = '',
  bool hasValidTag = false,
  int index = 0,
  bool isEdited = false,
  String content = 'hi',
  bool isDeleted = false,
}) => {
  'roomId': roomId,
  'messageId': messageId,
  'creatorId': creatorId,
  'creatorUsername': creatorUsername,
  'creatorName': creatorName,
  'creatorImgUrl': creatorImgUrl,
  'hasValidTag': hasValidTag,
  'index': index,
  'isEdited': isEdited,
  'content': content,
  'creationDateTime': DateTime.utc(2024, 1, 1).toIso8601String(),
  'isDeleted': isDeleted,
};

Row messageRow({String id = 'msg-1', int index = 0}) => Row(
  $id: id,
  $sequence: 0,
  $tableId: chatMessagesTableId,
  $databaseId: masterDatabaseId,
  $createdAt: DateTime.now().toIso8601String(),
  $updatedAt: DateTime.now().toIso8601String(),
  $permissions: const [],
  data: messageData(messageId: id, index: index),
);

Map<String, dynamic> replyData({
  String messageId = 'reply-1',
  String creatorUsername = 'other',
  String creatorImgUrl = '',
  int index = 0,
  String content = 'original',
}) => {
  'messageId': messageId,
  'creatorUsername': creatorUsername,
  'creatorImgUrl': creatorImgUrl,
  'index': index,
  'content': content,
};

Row replyRow({String id = 'msg-1'}) => Row(
  $id: id,
  $sequence: 0,
  $tableId: chatMessageReplyTableId,
  $databaseId: masterDatabaseId,
  $createdAt: DateTime.now().toIso8601String(),
  $updatedAt: DateTime.now().toIso8601String(),
  $permissions: const [],
  data: replyData(),
);

RoomMessage fakeMessage({
  String messageId = 'msg-1',
  String roomId = 'room-1',
  int index = 0,
  bool isDeleted = false,
  ReplyTo? replyTo,
}) => RoomMessage(
  roomId: roomId,
  messageId: messageId,
  creatorId: 'me',
  creatorUsername: 'me',
  creatorName: 'Me',
  creatorImgUrl: '',
  hasValidTag: false,
  index: index,
  isEdited: false,
  content: 'hi',
  creationDateTime: DateTime.utc(2024, 1, 1),
  isDeleted: isDeleted,
  replyTo: replyTo,
);

ReplyTo fakeReplyTo() => const ReplyTo(
  messageId: 'reply-1',
  creatorUsername: 'other',
  creatorImgUrl: '',
  index: 0,
  content: 'original',
);

void main() {
  late MockTablesDB tables;
  late MockRealtime realtime;
  late MockFunctions functions;
  late RoomChatRepository repo;

  setUp(() {
    tables = MockTablesDB();
    realtime = MockRealtime();
    functions = MockFunctions();
    repo = RoomChatRepository(
      tables: tables,
      realtime: realtime,
      functions: functions,
    );
  });

  group('loadMessages', () {
    test('queries the latest window (orderDesc) and sorts ascending', () async {
      when(
        tables.listRows(
          databaseId: masterDatabaseId,
          tableId: chatMessagesTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 2,
          rows: [messageRow(id: 'm2', index: 2), messageRow(id: 'm1', index: 1)],
        ),
      );
      // No replies for these messages.
      when(
        tables.getRow(
          databaseId: masterDatabaseId,
          tableId: chatMessageReplyTableId,
          rowId: anyNamed('rowId'),
        ),
      ).thenThrow(AppwriteException('not found', 404));

      final messages = await repo.loadMessages('room-1');

      expect(messages, hasLength(2));
      // Sorted ascending by index.
      expect(messages[0].index, 1);
      expect(messages[1].index, 2);

      final queries = verify(
        tables.listRows(
          databaseId: masterDatabaseId,
          tableId: chatMessagesTableId,
          queries: captureAnyNamed('queries'),
        ),
      ).captured.single as List<String>;
      expect(queries, [
        Query.equal('roomId', 'room-1'),
        Query.orderDesc('index'),
        Query.limit(100),
      ]);
    });

    test('merges fetched replyTo into the message json', () async {
      when(
        tables.listRows(
          databaseId: masterDatabaseId,
          tableId: chatMessagesTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(total: 1, rows: [messageRow(id: 'm1', index: 0)]),
      );
      when(
        tables.getRow(
          databaseId: masterDatabaseId,
          tableId: chatMessageReplyTableId,
          rowId: 'm1',
        ),
      ).thenAnswer((_) async => replyRow(id: 'm1'));

      final messages = await repo.loadMessages('room-1');

      expect(messages, hasLength(1));
      expect(messages.first.replyTo, isNotNull);
      expect(messages.first.replyTo!.content, 'original');
    });
  });

  group('fetchReplyTo', () {
    test('returns ReplyTo on success', () async {
      when(
        tables.getRow(
          databaseId: masterDatabaseId,
          tableId: chatMessageReplyTableId,
          rowId: 'msg-1',
        ),
      ).thenAnswer((_) async => replyRow());

      final reply = await repo.fetchReplyTo('msg-1');

      expect(reply, isNotNull);
      expect(reply!.messageId, 'reply-1');
      verify(
        tables.getRow(
          databaseId: masterDatabaseId,
          tableId: chatMessageReplyTableId,
          rowId: 'msg-1',
        ),
      ).called(1);
    });

    test('returns null on AppwriteException 404', () async {
      when(
        tables.getRow(
          databaseId: masterDatabaseId,
          tableId: chatMessageReplyTableId,
          rowId: 'msg-1',
        ),
      ).thenThrow(AppwriteException('not found', 404));

      final reply = await repo.fetchReplyTo('msg-1');

      expect(reply, isNull);
    });

    test('rethrows for non-404 codes', () async {
      when(
        tables.getRow(
          databaseId: masterDatabaseId,
          tableId: chatMessageReplyTableId,
          rowId: 'msg-1',
        ),
      ).thenThrow(AppwriteException('unauthorized', 401));

      expect(
        repo.fetchReplyTo('msg-1'),
        throwsA(isA<AppwriteException>()),
      );
    });
  });

  group('sendMessage', () {
    test('creates only the chat row when replyTo is null', () async {
      when(
        tables.createRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => messageRow());

      final message = fakeMessage(messageId: 'msg-1');
      await repo.sendMessage(message: message);

      verify(
        tables.createRow(
          databaseId: masterDatabaseId,
          tableId: chatMessagesTableId,
          rowId: 'msg-1',
          data: message.toJsonForUpload(),
        ),
      ).called(1);
      verifyNever(
        tables.createRow(
          databaseId: masterDatabaseId,
          tableId: chatMessageReplyTableId,
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      );
    });

    test('creates chat row and reply row when replyTo is set', () async {
      when(
        tables.createRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => messageRow());

      final message = fakeMessage(messageId: 'msg-1');
      final reply = fakeReplyTo();
      await repo.sendMessage(message: message, replyTo: reply);

      verify(
        tables.createRow(
          databaseId: masterDatabaseId,
          tableId: chatMessagesTableId,
          rowId: 'msg-1',
          data: message.toJsonForUpload(),
        ),
      ).called(1);
      verify(
        tables.createRow(
          databaseId: masterDatabaseId,
          tableId: chatMessageReplyTableId,
          rowId: 'msg-1',
          data: reply.toJson(),
        ),
      ).called(1);
    });
  });

  group('editMessage', () {
    test('updates the chat row with the uploaded json', () async {
      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => messageRow());

      final message = fakeMessage(messageId: 'msg-1');
      await repo.editMessage(message);

      verify(
        tables.updateRow(
          databaseId: masterDatabaseId,
          tableId: chatMessagesTableId,
          rowId: 'msg-1',
          data: message.toJsonForUpload(),
        ),
      ).called(1);
    });
  });

  group('deleteMessage', () {
    test('soft-deletes via updateRow (not deleteRow)', () async {
      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => messageRow());

      final message = fakeMessage(messageId: 'msg-1', isDeleted: true);
      await repo.deleteMessage(message);

      verify(
        tables.updateRow(
          databaseId: masterDatabaseId,
          tableId: chatMessagesTableId,
          rowId: 'msg-1',
          data: message.toJsonForUpload(),
        ),
      ).called(1);
      verifyNever(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      );
    });
  });

  group('notifyUpcomingRoomSubscribers', () {
    test('invokes the notification function with the json body', () async {
      when(
        functions.createExecution(
          functionId: anyNamed('functionId'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => Execution(
            $id: 'e1',
            $createdAt: '2023-01-01',
            $updatedAt: '2023-01-01',
            $permissions: const [],
            functionId: sendMessageNotificationFunctionID,
            trigger: enums.ExecutionTrigger.http,
            status: enums.ExecutionStatus.completed,
            requestMethod: 'POST',
            requestPath: '/',
            requestHeaders: const [],
            responseStatusCode: 200,
            responseBody: '',
            responseHeaders: const [],
            logs: '',
            errors: '',
            duration: 0.1,
            deploymentId: 'dep-1',
          ));

      await repo.notifyUpcomingRoomSubscribers(
        upcomingRoomId: 'up-1',
        title: 'Title',
        body: 'Body',
      );

      final body = verify(
        functions.createExecution(
          functionId: sendMessageNotificationFunctionID,
          body: captureAnyNamed('body'),
        ),
      ).captured.single as String;

      final decoded = jsonDecode(body) as Map<String, dynamic>;
      expect(decoded['roomId'], 'up-1');
      final payload = decoded['payload'] as Map<String, dynamic>;
      expect(payload['title'], 'Title');
      expect(payload['body'], 'Body');
    });
  });

  group('messageStream', () {
    late MockRealtimeSubscription sub;
    late StreamController<RealtimeMessage> controller;
    late String channel;

    setUp(() {
      sub = MockRealtimeSubscription();
      controller = StreamController<RealtimeMessage>.broadcast();
      channel = 'databases.$masterDatabaseId.tables.$chatMessagesTableId.rows';
      when(realtime.subscribe([channel])).thenReturn(sub);
      when(sub.stream).thenAnswer((_) => controller.stream);
      when(sub.close).thenReturn(() async {});
    });

    RealtimeMessage event({
      required String docId,
      required String action,
      Map<String, dynamic>? payload,
    }) => RealtimeMessage(
      events: ['$channel.$docId.$action'],
      // Realtime payload carries the row $id the repo reads before parsing.
      payload: {'\$id': docId, ...(payload ?? messageData(messageId: docId))},
      channels: [channel],
      timestamp: DateTime.now().toIso8601String(),
    );

    test('filters empty and mismatched roomId payloads', () async {
      when(
        tables.getRow(
          databaseId: masterDatabaseId,
          tableId: chatMessageReplyTableId,
          rowId: anyNamed('rowId'),
        ),
      ).thenThrow(AppwriteException('not found', 404));

      final emitted = <({RoomMessage message, String action})>[];
      final streamSub = repo.messageStream('room-1').listen(emitted.add);

      // Empty payload -> filtered.
      controller.add(RealtimeMessage(
        events: ['$channel.x.create'],
        payload: const {},
        channels: [channel],
        timestamp: DateTime.now().toIso8601String(),
      ));
      // Mismatched roomId -> filtered.
      controller.add(event(
        docId: 'y',
        action: 'create',
        payload: messageData(messageId: 'y', roomId: 'other-room'),
      ));
      // Matching roomId -> emitted.
      controller.add(event(docId: 'z', action: 'create'));
      await pumpEventQueue();

      expect(emitted, hasLength(1));
      expect(emitted.single.action, 'create');
      expect(emitted.single.message.messageId, 'z');

      await streamSub.cancel();
    });

    test('parses the action substring and emits create and update only',
        () async {
      when(
        tables.getRow(
          databaseId: masterDatabaseId,
          tableId: chatMessageReplyTableId,
          rowId: anyNamed('rowId'),
        ),
      ).thenThrow(AppwriteException('not found', 404));

      final emitted = <({RoomMessage message, String action})>[];
      final streamSub = repo.messageStream('room-1').listen(emitted.add);

      controller.add(event(docId: 'a', action: 'create'));
      controller.add(event(docId: 'b', action: 'update'));
      // delete is ignored.
      controller.add(event(docId: 'c', action: 'delete'));
      await pumpEventQueue();

      expect(emitted.map((e) => e.action), ['create', 'update']);
      verify(realtime.subscribe([channel])).called(1);

      await streamSub.cancel();
    });

    test('swallows fetchReplyTo errors and emits without replyTo', () async {
      // Non-404 error from replyTo lookup is swallowed by the stream.
      when(
        tables.getRow(
          databaseId: masterDatabaseId,
          tableId: chatMessageReplyTableId,
          rowId: anyNamed('rowId'),
        ),
      ).thenThrow(AppwriteException('boom', 500));

      final emitted = <({RoomMessage message, String action})>[];
      final streamSub = repo.messageStream('room-1').listen(emitted.add);

      controller.add(event(docId: 'a', action: 'create'));
      await pumpEventQueue();

      // fetchReplyTo threw -> caught -> nothing emitted.
      expect(emitted, isEmpty);

      await streamSub.cancel();
    });

    test('merges replyTo into the emitted message when present', () async {
      when(
        tables.getRow(
          databaseId: masterDatabaseId,
          tableId: chatMessageReplyTableId,
          rowId: 'a',
        ),
      ).thenAnswer((_) async => replyRow(id: 'a'));

      final emitted = <({RoomMessage message, String action})>[];
      final streamSub = repo.messageStream('room-1').listen(emitted.add);

      controller.add(event(docId: 'a', action: 'update'));
      await pumpEventQueue();

      expect(emitted, hasLength(1));
      expect(emitted.single.message.replyTo, isNotNull);
      expect(emitted.single.message.replyTo!.content, 'original');

      await streamSub.cancel();
    });
  });
}
