import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/rooms/data/room_chat.dart';
import 'package:resonate/features/rooms/model/reply_to.dart';
import 'package:resonate/features/rooms/model/room_message.dart';
import 'package:resonate/features/rooms/viewmodel/room_chat_notifier.dart';

RoomMessage message({
  String id = 'm1',
  String username = 'bob',
  String content = 'hello',
  String imgUrl = 'https://example.com/bob.jpg',
  int index = 0,
}) => RoomMessage(
  roomId: 'room-1',
  messageId: id,
  creatorId: 'bob-1',
  creatorUsername: username,
  creatorName: 'Bob',
  creatorImgUrl: imgUrl,
  hasValidTag: false,
  index: index,
  isEdited: false,
  content: content,
  creationDateTime: DateTime.utc(2026),
);


class _RecordingChatMessages extends RoomChatMessages {
  _RecordingChatMessages(this.messages);

  final List<RoomMessage> messages;

  ({String content, ReplyTo? replyTo, String? pollId})? sent;
  String? retried;
  ({String messageId, String newContent})? edited;
  String? deleted;

  @override
  Future<List<RoomMessage>> build(
    String roomId,
    String roomName,
    bool isUpcoming,
  ) async => messages;

  @override
  Future<bool> sendMessage({
    required String content,
    ReplyTo? replyTo,
    String? pollId,
  }) async {
    sent = (content: content, replyTo: replyTo, pollId: pollId);
    return true;
  }

  @override
  Future<bool> retrySend({required String messageId}) async {
    retried = messageId;
    return true;
  }

  @override
  Future<void> editMessage({
    required String messageId,
    required String newContent,
  }) async {
    edited = (messageId: messageId, newContent: newContent);
  }

  @override
  Future<void> deleteMessage(String messageId) async => deleted = messageId;
}

void main() {
  late _RecordingChatMessages chat;

  final composerKey = roomChatComposerProvider('room-1', 'Room 1', false);
  final messagesKey = roomChatMessagesProvider('room-1', 'Room 1', false);

  Future<ProviderContainer> open({List<RoomMessage>? messages}) async {
    chat = _RecordingChatMessages(messages ?? [message()]);
    final container = ProviderContainer(
      overrides: [messagesKey.overrideWith(() => chat)],
    );
    addTearDown(container.dispose);
    container.listen(composerKey, (_, _) {});
    await container.read(messagesKey.future);
    return container;
  }

  test('starts with nothing being replied to', () async {
    final container = await open();

    expect(container.read(composerKey), isNull);
  });

  group('replying', () {
    test('captures what is needed to render the quote', () async {
      final container = await open(
        messages: [
          message(id: 'm1'),
          message(id: 'm2', username: 'ada', content: 'the answer', index: 1),
        ],
      );

      container
          .read(composerKey.notifier)
          .setReplyingTo(
            message(id: 'm2', username: 'ada', content: 'the answer', index: 1),
          );

      final reply = container.read(composerKey)!;
      expect(reply.messageId, 'm2');
      expect(reply.creatorUsername, 'ada');
      expect(reply.content, 'the answer');
      expect(reply.index, 1, reason: 'position in the loaded list');
    });

    // The quote scrolls the list to `index`; a message that is no longer
    // loaded reports -1 rather than throwing.
    test('a message that is not loaded gets index -1', () async {
      final container = await open(messages: [message(id: 'm1')]);

      container
          .read(composerKey.notifier)
          .setReplyingTo(message(id: 'gone', index: 9));

      expect(container.read(composerKey)!.index, -1);
    });

    test('can be cancelled', () async {
      final container = await open();
      container.read(composerKey.notifier).setReplyingTo(message());
      expect(container.read(composerKey), isNotNull);

      container.read(composerKey.notifier).clearReplyingTo();

      expect(container.read(composerKey), isNull);
    });

    test('a second reply replaces the first', () async {
      final container = await open(
        messages: [
          message(id: 'm1'),
          message(id: 'm2', index: 1),
        ],
      );

      container.read(composerKey.notifier).setReplyingTo(message(id: 'm1'));
      container
          .read(composerKey.notifier)
          .setReplyingTo(message(id: 'm2', index: 1));

      expect(container.read(composerKey)!.messageId, 'm2');
    });
  });

  group('sending', () {
    test('carries the reply through', () async {
      final container = await open();
      container.read(composerKey.notifier).setReplyingTo(message(id: 'm1'));

      await container.read(composerKey.notifier).sendMessage(content: 'yes');

      expect(chat.sent?.content, 'yes');
      expect(chat.sent?.replyTo?.messageId, 'm1');
    });

    // Otherwise the next message would silently quote the previous one.
    test('clears the reply once it is sent', () async {
      final container = await open();
      container.read(composerKey.notifier).setReplyingTo(message(id: 'm1'));

      await container.read(composerKey.notifier).sendMessage(content: 'yes');

      expect(container.read(composerKey), isNull);
    });

    test('sends nothing to reply to when none was chosen', () async {
      final container = await open();

      await container.read(composerKey.notifier).sendMessage(content: 'hi');

      expect(chat.sent?.replyTo, isNull);
    });

    test('passes a poll id along', () async {
      final container = await open();

      await container
          .read(composerKey.notifier)
          .sendMessage(content: 'vote', pollId: 'poll-1');

      expect(chat.sent?.pollId, 'poll-1');
    });
  });

  group('delegating to the message list', () {
    test('retrySend', () async {
      final container = await open();

      await container.read(composerKey.notifier).retrySend(messageId: 'm1');

      expect(chat.retried, 'm1');
    });

    test('editMessage', () async {
      final container = await open();

      await container
          .read(composerKey.notifier)
          .editMessage(messageId: 'm1', newContent: 'fixed');

      expect(chat.edited?.messageId, 'm1');
      expect(chat.edited?.newContent, 'fixed');
    });

    test('deleteMessage', () async {
      final container = await open();

      await container.read(composerKey.notifier).deleteMessage('m1');

      expect(chat.deleted, 'm1');
    });
  });
}
