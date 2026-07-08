import 'dart:async';
import 'dart:developer';

import 'package:appwrite/appwrite.dart' show ID;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide Message;
import 'package:resonate/features/auth/viewmodel/current_user.dart';
import 'package:resonate/features/rooms/data/repositories/room_chat_repository.dart';
import 'package:resonate/features/rooms/model/reply_to.dart';
import 'package:resonate/features/rooms/model/room_chat_state.dart';
import 'package:resonate/features/rooms/model/room_message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/room_chat_notifier.g.dart';

const _androidChannel = AndroidNotificationDetails(
  'your channel id',
  'your channel name',
  channelDescription: 'your channel description',
  importance: Importance.max,
  priority: Priority.high,
  ticker: 'ticker',
);
const _notificationDetails = NotificationDetails(android: _androidChannel);

@riverpod
class RoomChatNotifier extends _$RoomChatNotifier {
  StreamSubscription? _messageSub;
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  @override
  Future<RoomChatState> build(
    String roomId,
    String roomName,
    bool isUpcoming,
  ) async {
    ref.onDispose(() async {
      await _messageSub?.cancel();
    });

    final repo = ref.read(roomChatRepositoryProvider);
    final messages = await repo.loadMessages(roomId);
    _subscribe(roomId, roomName, isUpcoming);
    return RoomChatState(messages: messages);
  }

  void _subscribe(String roomId, String roomName, bool isUpcoming) {
    final repo = ref.read(roomChatRepositoryProvider);
    _messageSub = repo.messageStream(roomId).listen((event) {
      final current = state.value;
      if (current == null) return;

      if (event.action == 'create') {
        // Dedupe: if this messageId was optimistically inserted by us,
        // replace it in place rather than appending a duplicate.
        final existingIndex = current.messages.indexWhere(
          (m) => m.messageId == event.message.messageId,
        );
        final List<RoomMessage> list;
        if (existingIndex >= 0) {
          list = [...current.messages];
          list[existingIndex] = event.message;
        } else {
          list = [...current.messages, event.message];
        }
        state = AsyncData(current.copyWith(messages: list));

        // Only notify on incoming messages from others, not echoes of ours.
        final fromSelf =
            event.message.creatorId == ref.read(requireUserProvider).uid;
        if (!isUpcoming && !fromSelf) {
          _notifications.show(
            0,
            'Message received in $roomName',
            '${event.message.creatorName} said: ${event.message.content}',
            _notificationDetails,
          );
        }
      } else if (event.action == 'update') {
        final updated = current.messages.map((m) {
          if (m.messageId != event.message.messageId) return m;
          return m.copyWith(
            content: event.message.content,
            isEdited: event.message.isEdited,
            isDeleted: event.message.isDeleted,
          );
        }).toList();
        state = AsyncData(current.copyWith(messages: updated));

        final fromSelf =
            event.message.creatorId == ref.read(requireUserProvider).uid;
        if (!isUpcoming && !fromSelf) {
          _notifications.show(
            0,
            'Message Edited in $roomName',
            '${event.message.creatorName} updated his message: ${event.message.content}',
            _notificationDetails,
          );
        }
      }
    });
  }

  // Returns true on successful POST, false if it failed
  Future<bool> sendMessage({
    required String roomId,
    required String roomName,
    required bool isUpcoming,
    required String content,
  }) async {
    final current = state.value;
    if (current == null) return false;

    final messageId = ID.unique();
    final newIndex =
        current.messages.isNotEmpty ? current.messages.last.index + 1 : 0;
    final user = ref.read(requireUserProvider);
    final replyTo = current.replyingTo;

    final message = RoomMessage(
      roomId: roomId,
      messageId: messageId,
      creatorId: user.uid,
      creatorUsername: user.userName ?? '',
      creatorName: user.displayName,
      hasValidTag: false,
      index: newIndex,
      creatorImgUrl: user.profileImageUrl ?? '',
      isEdited: false,
      content: content,
      creationDateTime: DateTime.now(),
      isDeleted: false,
      replyTo: replyTo,
      status: RoomMessageStatus.pending,
    );

// Optimistic insertion: show the message immediately with a pending status while we attempt to send it.
    state = AsyncData(
      current.copyWith(
        messages: [...current.messages, message],
        replyingTo: null,
      ),
    );

    return _postMessage(
      message: message,
      replyTo: replyTo,
      roomName: roomName,
      isUpcoming: isUpcoming,
    );
  }

  // Retry sending a previously-failed message
  Future<bool> retrySend({
    required String messageId,
    required String roomName,
    required bool isUpcoming,
  }) async {
    final current = state.value;
    if (current == null) return false;
    final idx = current.messages.indexWhere((m) => m.messageId == messageId);
    if (idx < 0) return false;
    final failed = current.messages[idx];
    if (failed.status != RoomMessageStatus.failed) return false;

    // Flip back to pending while we re-attempt.
    state = AsyncData(_replaceStatus(current, messageId, RoomMessageStatus.pending));

    return _postMessage(
      message: failed.copyWith(status: RoomMessageStatus.pending),
      replyTo: failed.replyTo,
      roomName: roomName,
      isUpcoming: isUpcoming,
    );
  }

  Future<bool> _postMessage({
    required RoomMessage message,
    required ReplyTo? replyTo,
    required String roomName,
    required bool isUpcoming,
  }) async {
    try {
      await ref.read(roomChatRepositoryProvider).sendMessage(
        message: message,
        replyTo: replyTo,
      );
// On success, the Realtime listener will update the message in state
      final after = state.value;
      if (after != null) {
        state = AsyncData(
          _replaceStatus(after, message.messageId, RoomMessageStatus.sent),
        );
      }
      if (isUpcoming) {
        await ref.read(roomChatRepositoryProvider).notifyUpcomingRoomSubscribers(
          upcomingRoomId: message.roomId,
          title: 'Message received in $roomName',
          body: '${message.creatorName} said: ${message.content}',
        );
      }
      return true;
    } catch (e) {
      log('sendMessage failed: $e — marking message ${message.messageId} as failed');
      final rolled = state.value;
      if (rolled != null) {
        state = AsyncData(
          _replaceStatus(rolled, message.messageId, RoomMessageStatus.failed),
        );
      }
      return false;
    }
  }

  RoomChatState _replaceStatus(
    RoomChatState current,
    String messageId,
    RoomMessageStatus status,
  ) {
    return current.copyWith(
      messages: current.messages.map((m) {
        if (m.messageId != messageId) return m;
        return m.copyWith(status: status);
      }).toList(),
    );
  }

  Future<void> editMessage({
    required String messageId,
    required String roomName,
    required bool isUpcoming,
    required String newContent,
  }) async {
    final current = state.value;
    if (current == null) return;

    final idx = current.messages.indexWhere((m) => m.messageId == messageId);
    if (idx < 0) return; // message no longer in the list
    final original = current.messages[idx];
    final updated = original.copyWith(
      content: newContent,
      isEdited: true,
      isDeleted: false,
    );

    try {
      await ref.read(roomChatRepositoryProvider).editMessage(updated);
      if (isUpcoming) {
        await ref.read(roomChatRepositoryProvider).notifyUpcomingRoomSubscribers(
          upcomingRoomId: updated.roomId,
          title: 'Message Edited in $roomName',
          body: '${updated.creatorName} updated his message: ${updated.content}',
        );
      }
    } catch (e) {
      log('editMessage failed: $e');
    }
  }

  Future<void> deleteMessage(String messageId) async {
    final current = state.value;
    if (current == null) return;

    final idx = current.messages.indexWhere((m) => m.messageId == messageId);
    if (idx < 0) return; // message no longer in the list
    final original = current.messages[idx];
    final softDeleted = original.copyWith(content: '', isDeleted: true);

    try {
      await ref.read(roomChatRepositoryProvider).deleteMessage(softDeleted);
    } catch (e) {
      log('deleteMessage failed: $e');
    }
  }

  void setReplyingTo(RoomMessage message) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        replyingTo: ReplyTo(
          messageId: message.messageId,
          creatorUsername: message.creatorUsername,
          content: message.content,
          creatorImgUrl: message.creatorImgUrl,
          index: current.messages.indexOf(message),
        ),
      ),
    );
  }

  void clearReplyingTo() {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(replyingTo: null));
  }
}
