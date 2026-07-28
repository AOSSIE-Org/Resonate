import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/rooms/model/room_message.dart';
import 'package:resonate/features/rooms/data/room_chat.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

void main() {
  late MockTablesDB tables;
  late MockRealtime realtime;
  late MockFunctions functions;
  late MockRealtimeSubscription subscription;
  late StreamController<RealtimeMessage> chatEvents;

  setUp(() {
    tables = MockTablesDB();
    realtime = MockRealtime();
    functions = MockFunctions();
    subscription = MockRealtimeSubscription();
    chatEvents = StreamController<RealtimeMessage>.broadcast();

    when(subscription.stream).thenAnswer((_) => chatEvents.stream);
    when(subscription.close).thenReturn(() async {});
    when(realtime.subscribe(any)).thenReturn(subscription);

    // Default: no historical messages, no replyTo rows.
    when(tables.listRows(
      databaseId: masterDatabaseId,
      tableId: chatMessagesTableId,
      queries: anyNamed('queries'),
    )).thenAnswer((_) async => RowList(total: 0, rows: []));
    when(tables.getRow(
      databaseId: masterDatabaseId,
      tableId: chatMessageReplyTableId,
      rowId: anyNamed('rowId'),
    )).thenThrow(AppwriteException('not found', 404));
  });

  tearDown(() => chatEvents.close());

  Future<dynamic> install() => installTestRootContainer(
        authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
        tables: tables,
        realtime: realtime,
        functions: functions,
      );

  group('RoomChatNotifier', () {
    test('build loads messages from the repository', () async {
      when(tables.listRows(
        databaseId: masterDatabaseId,
        tableId: chatMessagesTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => RowList(
            total: 1,
            rows: [
              buildRow(
                id: 'm1',
                tableId: chatMessagesTableId,
                databaseId: masterDatabaseId,
                data: {
                  'roomId': 'room-1',
                  'messageId': 'm1',
                  'creatorId': 'someone-else',
                  'creatorUsername': 'other',
                  'creatorName': 'Other',
                  'creatorImgUrl': '',
                  'hasValidTag': false,
                  'index': 0,
                  'isEdited': false,
                  'content': 'hello',
                  'creationDateTime':
                      DateTime.now().toUtc().toIso8601String(),
                  'isDeleted': false,
                },
              ),
            ],
          ));

      final container = await install();
      final state = await container
          .read(roomChatMessagesProvider('room-1', 'Room 1', false).future);

      expect(state, hasLength(1));
      expect(state.first.messageId, 'm1');
    });

    test(
      'sendMessage inserts optimistically and flips to sent on POST success',
      () async {
        when(tables.createRow(
          databaseId: masterDatabaseId,
          tableId: chatMessagesTableId,
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        )).thenAnswer((_) async => buildRow(
              id: 'mid',
              tableId: chatMessagesTableId,
              databaseId: masterDatabaseId,
              data: const {},
            ));

        final container = await install();
        final providerKey = roomChatMessagesProvider('room-1', 'Room 1', false);
        container.listen(providerKey, (_, _) {});
        await container.read(providerKey.future);

        final ok = await container.read(providerKey.notifier).sendMessage(
          content:'hi',
        );

        expect(ok, isTrue);
        final messages = container.read(providerKey).value!;
        expect(messages, hasLength(1));
        expect(messages.first.content, 'hi');
        expect(messages.first.status, RoomMessageStatus.sent);
      },
    );

    test('sendMessage marks message as failed when POST throws', () async {
      when(tables.createRow(
        databaseId: masterDatabaseId,
        tableId: chatMessagesTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenThrow(Exception('network down'));

      final container = await install();
      final providerKey = roomChatMessagesProvider('room-1', 'Room 1', false);
      container.listen(providerKey, (_, _) {});
      await container.read(providerKey.future);

      final ok = await container.read(providerKey.notifier).sendMessage(
        content:'oops',
      );

      expect(ok, isFalse);
      final messages = container.read(providerKey).value!;
      expect(messages, hasLength(1));
      expect(messages.first.status, RoomMessageStatus.failed);
    });

    test('retrySend flips a failed message back to sent on success', () async {
      var shouldFail = true;
      when(tables.createRow(
        databaseId: masterDatabaseId,
        tableId: chatMessagesTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenAnswer((_) async {
        if (shouldFail) throw Exception('network down');
        return buildRow(
          id: 'mid',
          tableId: chatMessagesTableId,
          databaseId: masterDatabaseId,
          data: const {},
        );
      });

      final container = await install();
      final providerKey = roomChatMessagesProvider('room-1', 'Room 1', false);
      container.listen(providerKey, (_, _) {});
      await container.read(providerKey.future);

      await container.read(providerKey.notifier).sendMessage(
        content:'oops',
      );
      final failedId =
          container.read(providerKey).value!.first.messageId;

      shouldFail = false;
      final ok = await container.read(providerKey.notifier).retrySend(
        messageId: failedId,
      );

      expect(ok, isTrue);
      final retried = container
          .read(providerKey)
          .value!
          .firstWhere((m) => m.messageId == failedId);
      expect(retried.status, RoomMessageStatus.sent);
    });

    test(
      'realtime create echo dedupes by messageId — no duplicate appended',
      () async {
        when(tables.createRow(
          databaseId: masterDatabaseId,
          tableId: chatMessagesTableId,
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        )).thenAnswer((_) async => buildRow(
              id: 'mid',
              tableId: chatMessagesTableId,
              databaseId: masterDatabaseId,
              data: const {},
            ));

        final container = await install();
        final providerKey = roomChatMessagesProvider('room-1', 'Room 1', false);
        container.listen(providerKey, (_, _) {});
        await container.read(providerKey.future);

        await container.read(providerKey.notifier).sendMessage(
          content:'hi',
        );
        final sentId =
            container.read(providerKey).value!.first.messageId;

        // Server echoes the same message back via realtime.
        final channel =
            'databases.$masterDatabaseId.tables.$chatMessagesTableId.rows';
        chatEvents.add(RealtimeMessage(
          events: ['$channel.$sentId.create'],
          payload: {
            '\$id': sentId,
            'roomId': 'room-1',
            'messageId': sentId,
            'creatorId': 'me',
            'creatorUsername': 'me',
            'creatorName': 'Me',
            'creatorImgUrl': '',
            'hasValidTag': false,
            'index': 0,
            'isEdited': false,
            'content': 'hi',
            'creationDateTime': DateTime.now().toUtc().toIso8601String(),
            'isDeleted': false,
          },
          channels: [channel],
          timestamp: DateTime.now().toIso8601String(),
        ));
        await Future<void>.delayed(Duration.zero);

        final messages = container.read(providerKey).value!;
        expect(messages, hasLength(1));
        expect(messages.first.messageId, sentId);
      },
    );
  });
}
