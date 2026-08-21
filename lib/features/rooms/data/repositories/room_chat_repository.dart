import 'dart:async';
import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/features/rooms/model/reply_to.dart';
import 'package:resonate/features/rooms/model/room_message.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/realtime_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/room_chat_repository.g.dart';

@Riverpod(keepAlive: true)
RoomChatRepository roomChatRepository(Ref ref) => RoomChatRepository(
  tables: ref.watch(appwriteTablesProvider),
  realtime: ref.watch(appwriteRealtimeProvider),
  functions: ref.watch(appwriteFunctionsProvider),
);

class RoomChatRepository {
  RoomChatRepository({
    required TablesDB tables,
    required Realtime realtime,
    required Functions functions,
  }) : _tables = tables,
       _realtime = realtime,
       _functions = functions;

  final TablesDB _tables;
  final Realtime _realtime;
  final Functions _functions;

  Future<List<RoomMessage>> loadMessages(String roomId) async {
    final result = await _tables.listRows(
      databaseId: masterDatabaseId,
      tableId: chatMessagesTableId,
      queries: [
        Query.equal('roomId', roomId),
        // Latest window, not the oldest: late joiners must see recent
        // messages (and poll cards). The sort below restores ascending order.
        Query.orderDesc('index'),
        Query.limit(100),
      ],
    );

    final messages = <RoomMessage>[];
    for (final row in result.rows) {
      final replyTo = await _fetchReplyTo(row.$id);
      final json = Map<String, dynamic>.from(row.data);
      if (replyTo != null) {
        json['replyTo'] = replyTo.toJson();
      }
      messages.add(RoomMessage.fromJson(json));
    }
    messages.sort((a, b) => a.index.compareTo(b.index));
    return messages;
  }

  Future<ReplyTo?> _fetchReplyTo(String messageId) async {
    try {
      final doc = await _tables.getRow(
        databaseId: masterDatabaseId,
        tableId: chatMessageReplyTableId,
        rowId: messageId,
      );
      return ReplyTo.fromJson(doc.data);
    } on AppwriteException catch (e) {
      if (e.code == 404) return null;
      rethrow;
    }
  }

  Future<ReplyTo?> fetchReplyTo(String messageId) => _fetchReplyTo(messageId);

  Future<void> sendMessage({
    required RoomMessage message,
    ReplyTo? replyTo,
  }) async {
    await _tables.createRow(
      databaseId: masterDatabaseId,
      tableId: chatMessagesTableId,
      rowId: message.messageId,
      data: message.toJsonForUpload(),
    );
    if (replyTo != null) {
      await _tables.createRow(
        databaseId: masterDatabaseId,
        tableId: chatMessageReplyTableId,
        rowId: message.messageId,
        data: replyTo.toJson(),
      );
    }
  }

  Future<void> editMessage(RoomMessage updated) async {
    await _tables.updateRow(
      databaseId: masterDatabaseId,
      tableId: chatMessagesTableId,
      rowId: updated.messageId,
      data: updated.toJsonForUpload(),
    );
  }

  Future<void> deleteMessage(RoomMessage softDeleted) async {
    await _tables.updateRow(
      databaseId: masterDatabaseId,
      tableId: chatMessagesTableId,
      rowId: softDeleted.messageId,
      data: softDeleted.toJsonForUpload(),
    );
  }

  Future<void> notifyUpcomingRoomSubscribers({
    required String upcomingRoomId,
    required String title,
    required String body,
  }) async {
    await _functions.createExecution(
      functionId: sendMessageNotificationFunctionID,
      body: json.encode({
        'roomId': upcomingRoomId,
        'payload': {'title': title, 'body': body},
      }),
    );
  }

  Stream<({RoomMessage message, String action})> messageStream(
    String roomId,
  ) {
    final channel =
        'databases.$masterDatabaseId.tables.$chatMessagesTableId.rows';
    final subscription = _realtime.subscribe([channel]);
    final controller =
        StreamController<({RoomMessage message, String action})>();

    final sub = subscription.stream.listen((data) async {
      if (data.payload.isEmpty || data.payload['roomId'] != roomId) return;

      final docId = data.payload['\$id'] as String;
      final action = realtimeAction(data.events);

      if (action == 'create' || action == 'update') {
        try {
          final replyTo = await _fetchReplyTo(docId);
          final json = Map<String, dynamic>.from(data.payload);
          if (replyTo != null) json['replyTo'] = replyTo.toJson();
          controller.add(
            (message: RoomMessage.fromJson(json), action: action),
          );
        } catch (_) {}
      }
    });

    controller.onCancel = () async {
      await sub.cancel();
      await subscription.close();
    };
    return controller.stream;
  }
}
