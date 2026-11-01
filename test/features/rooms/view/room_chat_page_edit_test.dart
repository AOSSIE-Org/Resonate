import 'package:flutter/gestures.dart' show kDoubleTapMinTime;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/rooms/data/room_chat.dart';
import 'package:resonate/features/rooms/data/room_polls.dart';
import 'package:resonate/features/rooms/model/reply_to.dart';
import 'package:resonate/features/rooms/model/room_message.dart';
import 'package:resonate/features/rooms/model/room_polls_state.dart';
import 'package:resonate/features/rooms/view/pages/room_chat_page.dart';
import 'package:resonate/features/rooms/viewmodel/room_chat_notifier.dart';

import '../rooms_test_helpers.dart';

const _roomId = 'room-1';
const _roomName = 'Test Room';

RoomMessage chatMessage({
  String messageId = 'm-1',
  String creatorId = 'me',
  String content = 'hello world',
  int index = 0,
  bool isEdited = false,
  bool isDeleted = false,
  ReplyTo? replyTo,
  RoomMessageStatus status = RoomMessageStatus.sent,
}) => RoomMessage(
  roomId: _roomId,
  messageId: messageId,
  creatorId: creatorId,
  creatorUsername: 'alice',
  creatorName: 'alice',
  creatorImgUrl: 'https://example.com/a.jpg',
  hasValidTag: false,
  index: index,
  isEdited: isEdited,
  content: content,
  creationDateTime: DateTime(2024, 1, 1, 12),
  isDeleted: isDeleted,
  replyTo: replyTo,
  status: status,
);

class _NoPolls extends RoomPollsNotifier {
  @override
  Future<RoomPollsState> build(String roomId) async => const RoomPollsState();
}

class _ListedMessages extends RoomChatMessages {
  _ListedMessages(this.messages);

  final List<RoomMessage> messages;

  @override
  Future<List<RoomMessage>> build(
    String roomId,
    String roomName,
    bool isUpcoming,
  ) async => messages;
}

class _RecordingComposer extends RoomChatComposer {
  _RecordingComposer(this._replyingTo);

  final ReplyTo? _replyingTo;
  ({String messageId, String newContent})? edited;
  int setReplyingCount = 0;

  @override
  ReplyTo? build(String roomId, String roomName, bool isUpcoming) =>
      _replyingTo;

  @override
  Future<void> editMessage({
    required String messageId,
    required String newContent,
  }) async {
    edited = (messageId: messageId, newContent: newContent);
  }

  @override
  void setReplyingTo(RoomMessage message) => setReplyingCount++;
}

void main() {
  late _RecordingComposer composer;

  Future<void> pumpChat(
    WidgetTester tester, {
    required List<RoomMessage> messages,
    String uid = 'me',
    ReplyTo? replyingTo,
  }) async {
    composer = _RecordingComposer(replyingTo);
    await pumpTestApp(
      tester,
      RoomChatPage(roomId: _roomId, roomName: _roomName, isUpcoming: false),
      overrides: [
        roomChatMessagesProvider(
          _roomId,
          _roomName,
          false,
        ).overrideWith(() => _ListedMessages(messages)),
        roomChatComposerProvider(
          _roomId,
          _roomName,
          false,
        ).overrideWith(() => composer),
        roomPollsProvider(_roomId).overrideWith(_NoPolls.new),
        requireUserProvider.overrideWithValue(fakeAuthUser(uid: uid)),
        currentUserProvider.overrideWithValue(fakeAuthUser(uid: uid)),
      ],
    );
    await tester.pumpAndSettle();
  }

  // Editing opens on a double-tap of your own message.
  Future<void> startEditing(WidgetTester tester) async {
    final bubble = find.byType(ChatMessageItem).first;
    await tester.tap(bubble);
    await tester.pump(kDoubleTapMinTime);
    await tester.tap(bubble);
    await tester.pumpAndSettle();
  }

  // Replying is a swipe right; the handler fires past 70px of drag.
  Future<void> swipeToReply(WidgetTester tester, {double by = 120}) async {
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(ChatMessageItem).first),
    );
    for (var moved = 0.0; moved < by; moved += 30) {
      await gesture.moveBy(const Offset(30, 0));
      await tester.pump();
    }
    await gesture.up();
    await tester.pumpAndSettle();
  }

  // The editor replaces the bubble with a TextField seeded with the message.
  Finder editField() => find.descendant(
    of: find.byType(ChatMessageItem),
    matching: find.byType(TextField),
  );

  group('who may edit', () {
    testAppWidget('a double-tap opens your own message', (tester) async {
      await pumpChat(tester, messages: [chatMessage(creatorId: 'me')]);

      await startEditing(tester);

      expect(editField(), findsOneWidget);
    });

    testAppWidget('offers no edit on someone else\'s', (tester) async {
      await pumpChat(tester, messages: [chatMessage(creatorId: 'other')]);

      await startEditing(tester);

      expect(editField(), findsNothing);
    });

    // There is nothing left to edit once a message is withdrawn.
    testAppWidget('a deleted message does not open', (tester) async {
      await pumpChat(
        tester,
        messages: [chatMessage(creatorId: 'me', isDeleted: true)],
      );

      await startEditing(tester);

      expect(editField(), findsNothing);
    });
  });

  group('editing a message', () {
    testAppWidget('opens an editor holding the current text', (tester) async {
      await pumpChat(
        tester,
        messages: [chatMessage(creatorId: 'me', content: 'first draft')],
      );

      await startEditing(tester);

      expect(editField(), findsOneWidget);
      expect(
        tester.widget<TextField>(editField()).controller?.text,
        'first draft',
      );
    });

    testAppWidget('saving sends the new text', (tester) async {
      await pumpChat(
        tester,
        messages: [
          chatMessage(messageId: 'm-9', creatorId: 'me', content: 'typo'),
        ],
      );
      await startEditing(tester);

      await tester.enterText(editField(), 'fixed');
      tester.widget<TextField>(editField()).onSubmitted!('fixed');
      await tester.pumpAndSettle();

      expect(composer.edited?.messageId, 'm-9');
      expect(composer.edited?.newContent, 'fixed');
      expect(editField(), findsNothing, reason: 'editor closes');
    });

    // Backing out must leave the message exactly as it was.
    testAppWidget('cancelling sends nothing and restores the text', (
      tester,
    ) async {
      await pumpChat(
        tester,
        messages: [chatMessage(creatorId: 'me', content: 'original')],
      );
      await startEditing(tester);
      await tester.enterText(editField(), 'scrapped');

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(composer.edited, isNull);
      expect(editField(), findsNothing);
      expect(find.text('original'), findsOneWidget);
    });
  });

  group('replying', () {
    testAppWidget('a swipe right starts a reply', (tester) async {
      await pumpChat(
        tester,
        messages: [chatMessage(messageId: 'm-3', creatorId: 'other')],
      );

      await swipeToReply(tester);

      expect(composer.setReplyingCount, 1);
    });

    // A short drag is a scroll, not a reply.
    testAppWidget('a short swipe does not', (tester) async {
      await pumpChat(tester, messages: [chatMessage(creatorId: 'other')]);

      await swipeToReply(tester, by: 30);

      expect(composer.setReplyingCount, 0);
    });

    testAppWidget('tapping a quote does not throw', (tester) async {
      await pumpChat(
        tester,
        messages: [
          chatMessage(messageId: 'm-1', content: 'the original'),
          chatMessage(
            messageId: 'm-2',
            index: 1,
            content: 'the answer',
            replyTo: const ReplyTo(
              messageId: 'm-1',
              creatorUsername: 'alice',
              creatorImgUrl: 'https://example.com/a.jpg',
              index: 0,
              content: 'the original',
            ),
          ),
        ],
      );

      await tester.tap(find.text('the original').last);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });

  testAppWidget('the back button leaves the chat', (tester) async {
    await pumpChat(tester, messages: [chatMessage()]);

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
