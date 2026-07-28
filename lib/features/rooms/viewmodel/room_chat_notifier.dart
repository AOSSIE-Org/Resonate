import 'package:resonate/features/rooms/data/room_chat.dart';
import 'package:resonate/features/rooms/model/reply_to.dart';
import 'package:resonate/features/rooms/model/room_message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/room_chat_notifier.g.dart';


@riverpod
class RoomChatComposer extends _$RoomChatComposer {
  @override
  ReplyTo? build(String roomId, String roomName, bool isUpcoming) => null;

  RoomChatMessages get _messages =>
      ref.read(roomChatMessagesProvider(roomId, roomName, isUpcoming).notifier);

  Future<bool> sendMessage({required String content, String? pollId}) async {
    final replyTo = state;
    state = null;
    return _messages.sendMessage(
      content: content,
      replyTo: replyTo,
      pollId: pollId,
    );
  }

  Future<bool> retrySend({required String messageId}) =>
      _messages.retrySend(messageId: messageId);

  Future<void> editMessage({
    required String messageId,
    required String newContent,
  }) => _messages.editMessage(messageId: messageId, newContent: newContent);

  Future<void> deleteMessage(String messageId) =>
      _messages.deleteMessage(messageId);

  void setReplyingTo(RoomMessage message) {
    final messages =
        ref
            .read(roomChatMessagesProvider(roomId, roomName, isUpcoming))
            .value ??
        const <RoomMessage>[];
    state = ReplyTo(
      messageId: message.messageId,
      creatorUsername: message.creatorUsername,
      content: message.content,
      creatorImgUrl: message.creatorImgUrl,
      index: messages.indexOf(message),
    );
  }

  void clearReplyingTo() => state = null;
}
