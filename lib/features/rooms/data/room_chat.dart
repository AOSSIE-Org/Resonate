import 'dart:async';
import 'dart:developer';

import 'package:appwrite/appwrite.dart' show ID;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide Message;
import 'package:resonate/features/achievements/data/services/activity_recorder.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/rooms/data/repositories/room_chat_repository.dart';
import 'package:resonate/features/rooms/model/reply_to.dart';
import 'package:resonate/features/rooms/model/room_message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/room_chat.g.dart';

const _androidChannel = AndroidNotificationDetails(
  'Resonate Chat',
  'Resonate Notifications',
  channelDescription: 'General notifications from Resonate',
  importance: Importance.max,
  priority: Priority.high,
);
const _notificationDetails = NotificationDetails(android: _androidChannel);

@riverpod
class RoomChatMessages extends _$RoomChatMessages {
  StreamSubscription? _messageSub;
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  @override
  Future<List<RoomMessage>> build(
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
    return messages;
  }

  void _subscribe(String roomId, String roomName, bool isUpcoming) {
    final repo = ref.read(roomChatRepositoryProvider);
    _messageSub = repo.messageStream(roomId).listen((event) {
      final current = state.value;
      if (current == null) return;

      if (event.action == 'create') {
        final existingIndex = current.indexWhere(
          (m) => m.messageId == event.message.messageId,
        );
        final List<RoomMessage> list;
        if (existingIndex >= 0) {
          list = [...current];
          list[existingIndex] = event.message;
        } else {
          list = [...current, event.message];
        }
        state = AsyncData(list);

        final fromSelf =
            event.message.creatorId == ref.read(requireUserProvider).uid;
        if (!isUpcoming && !fromSelf) {
          _notify(
            'Message received in $roomName',
            '${event.message.creatorName} said: ${event.message.content}',
          );
        }
      } else if (event.action == 'update') {
        final updated = current.map((m) {
          if (m.messageId != event.message.messageId) return m;
          return m.copyWith(
            content: event.message.content,
            isEdited: event.message.isEdited,
            isDeleted: event.message.isDeleted,
          );
        }).toList();
        state = AsyncData(updated);

        final fromSelf =
            event.message.creatorId == ref.read(requireUserProvider).uid;
        if (!isUpcoming && !fromSelf) {
          _notify(
            'Message Edited in $roomName',
            '${event.message.creatorName} updated his message: ${event.message.content}',
          );
        }
      }
    });
  }

  void _notify(String title, String body) {
    try {
      _notifications
          .show(0, title, body, _notificationDetails)
          .catchError((Object e) => log('local notification failed: $e'));
    } catch (e) {
      log('local notification failed: $e');
    }
  }

  // Optimistically appends the message then posts it
  Future<bool> sendMessage({
    required String content,
    ReplyTo? replyTo,
    String? pollId,
  }) async {
    try {
      await future;
    } catch (e) {
      log('chat messages unavailable before sendMessage: $e');
    }
    if (!ref.mounted) return false;

    final current = state.value;
    if (current == null) return false;

    final user = ref.read(requireUserProvider);
    final message = RoomMessage(
      roomId: roomId,
      messageId: ID.unique(),
      creatorId: user.uid,
      creatorUsername: user.userName ?? '',
      creatorName: user.displayName,
      hasValidTag: false,
      index: current.isNotEmpty ? current.last.index + 1 : 0,
      creatorImgUrl: user.profileImageUrl ?? '',
      isEdited: false,
      content: content,
      creationDateTime: DateTime.now(),
      isDeleted: false,
      pollId: pollId,
      replyTo: replyTo,
      status: RoomMessageStatus.pending,
    );

    state = AsyncData([...current, message]);

    return _postMessage(message: message, replyTo: replyTo);
  }

  // Retries a previously-failed message.
  Future<bool> retrySend({required String messageId}) async {
    final current = state.value;
    if (current == null) return false;
    final idx = current.indexWhere((m) => m.messageId == messageId);
    if (idx < 0) return false;
    final failed = current[idx];
    if (failed.status != RoomMessageStatus.failed) return false;

    state = AsyncData(
      _replaceStatus(current, messageId, RoomMessageStatus.pending),
    );

    return _postMessage(
      message: failed.copyWith(status: RoomMessageStatus.pending),
      replyTo: failed.replyTo,
    );
  }

  Future<bool> _postMessage({
    required RoomMessage message,
    required ReplyTo? replyTo,
  }) async {
    try {
      await ref
          .read(roomChatRepositoryProvider)
          .sendMessage(message: message, replyTo: replyTo);
      // On success
      final after = state.value;
      if (after != null) {
        state = AsyncData(
          _replaceStatus(after, message.messageId, RoomMessageStatus.sent),
        );
      }
      // createPoll already counted the poll; its announcement must not count too.
      if (message.pollId == null) {
        ref.read(activityRecorderProvider.notifier).recordInteraction();
      }
      if (isUpcoming) {
        await ref
            .read(roomChatRepositoryProvider)
            .notifyUpcomingRoomSubscribers(
              upcomingRoomId: message.roomId,
              title: 'Message received in $roomName',
              body: '${message.creatorName} said: ${message.content}',
            );
      }
      return true;
    } catch (e) {
      log(
        'sendMessage failed: $e — marking message ${message.messageId} as failed',
      );
      final rolled = state.value;
      if (rolled != null) {
        state = AsyncData(
          _replaceStatus(rolled, message.messageId, RoomMessageStatus.failed),
        );
      }
      return false;
    }
  }

  List<RoomMessage> _replaceStatus(
    List<RoomMessage> current,
    String messageId,
    RoomMessageStatus status,
  ) {
    return current.map((m) {
      if (m.messageId != messageId) return m;
      return m.copyWith(status: status);
    }).toList();
  }

  Future<void> editMessage({
    required String messageId,
    required String newContent,
  }) async {
    final current = state.value;
    if (current == null) return;

    final idx = current.indexWhere((m) => m.messageId == messageId);
    if (idx < 0) return; // message no longer in the list
    final updated = current[idx].copyWith(
      content: newContent,
      isEdited: true,
      isDeleted: false,
    );

    try {
      await ref.read(roomChatRepositoryProvider).editMessage(updated);
      if (isUpcoming) {
        await ref
            .read(roomChatRepositoryProvider)
            .notifyUpcomingRoomSubscribers(
              upcomingRoomId: updated.roomId,
              title: 'Message Edited in $roomName',
              body:
                  '${updated.creatorName} updated his message: ${updated.content}',
            );
      }
    } catch (e) {
      log('editMessage failed: $e');
    }
  }

  Future<void> deleteMessage(String messageId) async {
    final current = state.value;
    if (current == null) return;

    final idx = current.indexWhere((m) => m.messageId == messageId);
    if (idx < 0) return; // message no longer in the list
    final softDeleted = current[idx].copyWith(content: '', isDeleted: true);

    try {
      await ref.read(roomChatRepositoryProvider).deleteMessage(softDeleted);
    } catch (e) {
      log('deleteMessage failed: $e');
    }
  }
}
