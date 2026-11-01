import 'dart:async';
import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/rooms/data/room_chat.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

const _channel = 'databases.$databaseId.tables.$chatMessagesTableId.rows';

void main() {
  late MockTablesDB tables;
  late MockRealtime realtime;
  late MockFunctions functions;
  late MockRealtimeSubscription subscription;
  late StreamController<RealtimeMessage> chatEvents;

  Map<String, dynamic> messagePayload({
    String id = 'm1',
    String creatorId = 'someone-else',
    String creatorName = 'Other',
    String content = 'hello',
    bool isEdited = false,
    bool isDeleted = false,
    int index = 0,
  }) => {
    '\$id': id,
    'roomId': 'room-1',
    'messageId': id,
    'creatorId': creatorId,
    'creatorUsername': 'other',
    'creatorName': creatorName,
    'creatorImgUrl': '',
    'hasValidTag': false,
    'index': index,
    'isEdited': isEdited,
    'isDeleted': isDeleted,
    'content': content,
    'creationDateTime': DateTime.now().toUtc().toIso8601String(),
  };

  setUp(() {
    tables = MockTablesDB();
    realtime = MockRealtime();
    functions = MockFunctions();
    subscription = MockRealtimeSubscription();
    chatEvents = StreamController<RealtimeMessage>.broadcast();

    when(subscription.stream).thenAnswer((_) => chatEvents.stream);
    when(subscription.close).thenReturn(() async {});
    when(realtime.subscribe(any)).thenReturn(subscription);

    // One existing message to act on.
    when(
      tables.listRows(
        databaseId: databaseId,
        tableId: chatMessagesTableId,
        queries: anyNamed('queries'),
      ),
    ).thenAnswer(
      (_) async => RowList(
        total: 1,
        rows: [
          buildRow(
            id: 'm1',
            tableId: chatMessagesTableId,
            databaseId: databaseId,
            data: messagePayload(),
          ),
        ],
      ),
    );
    when(
      tables.listRows(
        databaseId: databaseId,
        tableId: chatMessageReplyTableId,
        queries: anyNamed('queries'),
      ),
    ).thenAnswer((_) async => RowList(total: 0, rows: const []));
    when(
      tables.getRow(
        databaseId: databaseId,
        tableId: chatMessageReplyTableId,
        rowId: anyNamed('rowId'),
      ),
    ).thenThrow(AppwriteException('not found', 404));
    when(
      tables.updateRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      ),
    ).thenAnswer(
      (_) async => buildRow(
        id: 'm1',
        tableId: chatMessagesTableId,
        databaseId: databaseId,
        data: const {},
      ),
    );
  });

  tearDown(() => chatEvents.close());

  Future<ProviderContainer> install() => installTestRootContainer(
    authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
    tables: tables,
    realtime: realtime,
    functions: functions,
  );

  Future<(ProviderContainer, RoomChatMessagesProvider)> openChat({
    bool isUpcoming = false,
  }) async {
    final container = await install();
    final key = roomChatMessagesProvider('room-1', 'Room 1', isUpcoming);
    container.listen(key, (_, _) {});
    await container.read(key.future);
    return (container, key);
  }

  Map getUpdateFor(String rowId) =>
      verify(
            tables.updateRow(
              databaseId: databaseId,
              tableId: chatMessagesTableId,
              rowId: rowId,
              data: captureAnyNamed('data'),
            ),
          ).captured.last
          as Map;

  group('editMessage', () {
    test('writes the new content and marks it edited', () async {
      final (container, key) = await openChat();

      await container
          .read(key.notifier)
          .editMessage(messageId: 'm1', newContent: 'fixed typo');

      final data = getUpdateFor('m1');
      expect(data['content'], 'fixed typo');
      expect(data['isEdited'], isTrue);
      expect(data['isDeleted'], isFalse);
    });

    // The message may have been removed between opening the sheet and saving.
    test('a message that is no longer listed is left alone', () async {
      final (container, key) = await openChat();

      await container
          .read(key.notifier)
          .editMessage(messageId: 'gone', newContent: 'nope');

      verifyNever(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: chatMessagesTableId,
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      );
    });

    test('a failed write does not throw back into the editor', () async {
      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenThrow(AppwriteException('offline', 500));
      final (container, key) = await openChat();

      await expectLater(
        container
            .read(key.notifier)
            .editMessage(messageId: 'm1', newContent: 'fixed typo'),
        completes,
      );
    });

    // Subscribers to a scheduled room are told about edits; people in a live
    // room are already looking at the chat.
    test('an upcoming room also tells its subscribers', () async {
      when(
        functions.createExecution(
          functionId: anyNamed('functionId'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => MockExecution());
      final (container, key) = await openChat(isUpcoming: true);

      await container
          .read(key.notifier)
          .editMessage(messageId: 'm1', newContent: 'fixed typo');

      final body =
          verify(
                functions.createExecution(
                  functionId: sendMessageNotificationFunctionID,
                  body: captureAnyNamed('body'),
                ),
              ).captured.single
              as String;
      final decoded = json.decode(body) as Map<String, dynamic>;
      expect(decoded['roomId'], 'room-1');
      expect(decoded['payload']['title'], 'Message Edited in Room 1');
      expect(decoded['payload']['body'], contains('fixed typo'));
    });

    test('a live room does not notify anyone', () async {
      final (container, key) = await openChat();

      await container
          .read(key.notifier)
          .editMessage(messageId: 'm1', newContent: 'fixed typo');

      verifyNever(
        functions.createExecution(
          functionId: anyNamed('functionId'),
          body: anyNamed('body'),
        ),
      );
    });
  });

  group('deleteMessage', () {
    // Deleting is a soft delete: the row stays so the realtime update reaches
    // everyone and the placeholder keeps its position in the thread.
    test('blanks the content and flags the row deleted', () async {
      final (container, key) = await openChat();

      await container.read(key.notifier).deleteMessage('m1');

      final data = getUpdateFor('m1');
      expect(data['content'], isEmpty);
      expect(data['isDeleted'], isTrue);
    });

    test('a message that is no longer listed is left alone', () async {
      final (container, key) = await openChat();

      await container.read(key.notifier).deleteMessage('gone');

      verifyNever(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: chatMessagesTableId,
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      );
    });

    test('a failed write does not throw', () async {
      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenThrow(AppwriteException('offline', 500));
      final (container, key) = await openChat();

      await expectLater(
        container.read(key.notifier).deleteMessage('m1'),
        completes,
      );
    });
  });

  group('a realtime update', () {
    Future<void> emitUpdate(Map<String, dynamic> payload) async {
      chatEvents.add(
        RealtimeMessage(
          events: ['$_channel.${payload['messageId']}.update'],
          payload: payload,
          channels: const [_channel],
          timestamp: DateTime.now().toIso8601String(),
        ),
      );
      for (var i = 0; i < 5; i++) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    test('rewrites the message in place', () async {
      final (container, key) = await openChat();

      await emitUpdate(
        messagePayload(content: 'edited elsewhere', isEdited: true),
      );

      final messages = container.read(key).value!;
      expect(messages, hasLength(1));
      expect(messages.single.content, 'edited elsewhere');
      expect(messages.single.isEdited, isTrue);
    });

    test('carries a delete through to the list', () async {
      final (container, key) = await openChat();

      await emitUpdate(messagePayload(content: '', isDeleted: true));

      final messages = container.read(key).value!;
      expect(messages.single.isDeleted, isTrue);
      expect(messages.single.content, isEmpty);
    });

    // Nothing to rewrite, and appending would resurrect a message the viewer
    // never had.
    test('for an unknown message changes nothing', () async {
      final (container, key) = await openChat();

      await emitUpdate(messagePayload(id: 'not-mine', content: 'stray'));

      final messages = container.read(key).value!;
      expect(messages, hasLength(1));
      expect(messages.single.messageId, 'm1');
      expect(messages.single.content, 'hello');
    });
  });
}
