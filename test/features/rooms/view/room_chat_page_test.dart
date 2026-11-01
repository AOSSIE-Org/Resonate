import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/rooms/model/reply_to.dart';
import 'package:resonate/features/rooms/model/room_chat_state.dart';
import 'package:resonate/features/rooms/model/room_message.dart';
import 'package:resonate/features/rooms/view/pages/room_chat_page.dart';
import 'package:resonate/features/rooms/viewmodel/room_chat_notifier.dart';

import '../rooms_test_helpers.dart';

const _roomId = 'room-1';
const _roomName = 'Test Room';

RoomMessage fakeMessage({
  String messageId = 'm-1',
  String creatorId = 'me',
  String creatorName = 'alice',
  String creatorUsername = 'alice',
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
  creatorUsername: creatorUsername,
  creatorName: creatorName,
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

// Builds the overrides with the fake chat + a current user of the given uid.
List<Override> buildOverrides(
  FakeRoomChat fake, {
  String uid = 'me',
  bool isUpcoming = false,
}) {
  return [
    roomChatProvider(_roomId, _roomName, isUpcoming).overrideWith(() => fake),
    requireUserProvider.overrideWithValue(fakeAuthUser(uid: uid)),
    currentUserProvider.overrideWithValue(fakeAuthUser(uid: uid)),
  ];
}

Widget page({bool isUpcoming = false}) => RoomChatPage(
  roomId: _roomId,
  roomName: _roomName,
  isUpcoming: isUpcoming,
);

void main() {
  group('RoomChatPage state rendering', () {
    testRoomsWidget('loading shows a CircularProgressIndicator', (tester) async {
      final completer = Completer<RoomChatState>();
      // A fake whose build never completes until we complete it.
      final fake = _PendingRoomChat(completer.future);
      await pumpRoomsPage(
        tester,
        page(),
        overrides: [
          roomChatProvider(_roomId, _roomName, false).overrideWith(() => fake),
          requireUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
          currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
        ],
      );
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      completer.complete(const RoomChatState());
      await tester.pumpAndSettle();
    });

    testRoomsWidget('error shows the localized error text', (tester) async {
      final fake = FakeRoomChat(const RoomChatState(), error: true);
      await pumpRoomsPage(tester, page(), overrides: buildOverrides(fake));
      await tester.pumpAndSettle();
      expect(find.text('Error'), findsWidgets);
    });

    testRoomsWidget('data renders one ChatMessageItem per message', (tester) async {
      final state = RoomChatState(
        messages: [
          fakeMessage(messageId: 'm-1', content: 'first'),
          fakeMessage(messageId: 'm-2', content: 'second', index: 1),
        ],
      );
      final fake = FakeRoomChat(state);
      await pumpRoomsPage(tester, page(), overrides: buildOverrides(fake));
      await tester.pumpAndSettle();
      expect(find.byType(ChatMessageItem), findsNWidgets(2));
      expect(find.text('first'), findsOneWidget);
      expect(find.text('second'), findsOneWidget);
    });
  });

  group('ChatMessageItem content variants', () {
    testRoomsWidget('deleted message shows italic deleted text', (tester) async {
      final state = RoomChatState(
        messages: [fakeMessage(isDeleted: true, content: '')],
      );
      final fake = FakeRoomChat(state);
      await pumpRoomsPage(tester, page(), overrides: buildOverrides(fake));
      await tester.pumpAndSettle();
      final finder = find.text('This message was deleted');
      expect(finder, findsOneWidget);
      final textWidget = tester.widget<Text>(finder);
      expect(textWidget.style?.fontStyle, FontStyle.italic);
    });

    testRoomsWidget('edited message shows the edited tag', (tester) async {
      final state = RoomChatState(
        messages: [fakeMessage(isEdited: true, content: 'hi')],
      );
      final fake = FakeRoomChat(state);
      await pumpRoomsPage(tester, page(), overrides: buildOverrides(fake));
      await tester.pumpAndSettle();
      expect(find.text(' (edited)'), findsOneWidget);
    });

    testRoomsWidget('reply preview renders when replyTo is set', (tester) async {
      final state = RoomChatState(
        messages: [
          fakeMessage(
            content: 'a reply',
            replyTo: const ReplyTo(
              messageId: 'orig',
              creatorUsername: 'bob',
              creatorImgUrl: 'https://example.com/b.jpg',
              index: 0,
              content: 'original text',
            ),
          ),
        ],
      );
      final fake = FakeRoomChat(state);
      await pumpRoomsPage(tester, page(), overrides: buildOverrides(fake));
      await tester.pumpAndSettle();
      expect(find.text('@bob'), findsOneWidget);
      expect(find.text('original text'), findsOneWidget);
    });
  });

  group('_StatusIndicator', () {
    testRoomsWidget('sent renders no indicator', (tester) async {
      final state = RoomChatState(
        messages: [fakeMessage(status: RoomMessageStatus.sent)],
      );
      final fake = FakeRoomChat(state);
      await pumpRoomsPage(tester, page(), overrides: buildOverrides(fake));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.access_time), findsNothing);
      expect(find.text('Retry'), findsNothing);
    });

    testRoomsWidget('pending shows the access_time icon', (tester) async {
      final state = RoomChatState(
        messages: [fakeMessage(status: RoomMessageStatus.pending)],
      );
      final fake = FakeRoomChat(state);
      await pumpRoomsPage(tester, page(), overrides: buildOverrides(fake));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.access_time), findsOneWidget);
    });

    testRoomsWidget('failed shows a retry row and tapping calls retrySend', (
      tester,
    ) async {
      final state = RoomChatState(
        messages: [fakeMessage(status: RoomMessageStatus.failed)],
      );
      final fake = FakeRoomChat(state);
      await pumpRoomsPage(tester, page(), overrides: buildOverrides(fake));
      await tester.pumpAndSettle();
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);

      final retryGesture = tester.widget<GestureDetector>(
        find
            .ancestor(
              of: find.byTooltip('Tap to retry'),
              matching: find.byType(GestureDetector),
            )
            .first,
      );
      retryGesture.onTap!();
      await tester.pumpAndSettle();
      expect(fake.retryCount, 1);
    });
  });

  group('canEdit / canDelete gating', () {
    // Owner + not deleted/edited -> context menu shows Delete -> confirm calls delete.
    testRoomsWidget('owner can delete via context menu confirm', (tester) async {
      final state = RoomChatState(
        messages: [fakeMessage(messageId: 'm-x', creatorId: 'me')],
      );
      final fake = FakeRoomChat(state);
      await pumpRoomsPage(
        tester,
        page(),
        overrides: buildOverrides(fake, uid: 'me'),
      );
      await tester.pumpAndSettle();

      await tester.longPress(find.byType(ChatMessageItem));
      await tester.pumpAndSettle();
      // 'delete' appears as the context-menu tile.
      expect(find.text('delete'), findsWidgets);

      await tester.tap(find.text('delete').first);
      await tester.pumpAndSettle();
      // Confirm dialog now shows; tap its delete action.
      expect(find.text('Delete Message'), findsOneWidget);
      await tester.tap(find.text('delete').last);
      await tester.pumpAndSettle();

      expect(fake.deleteCount, 1);
      expect(fake.lastDeletedId, 'm-x');
    });

    testRoomsWidget('non-owner sees no Delete in context menu', (tester) async {
      final state = RoomChatState(
        messages: [fakeMessage(creatorId: 'other')],
      );
      final fake = FakeRoomChat(state);
      await pumpRoomsPage(
        tester,
        page(),
        overrides: buildOverrides(fake, uid: 'me'),
      );
      await tester.pumpAndSettle();

      await tester.longPress(find.byType(ChatMessageItem));
      await tester.pumpAndSettle();
      // Only the Cancel tile should be present, no delete tile.
      expect(find.text('delete'), findsNothing);
      expect(find.text('Cancel'), findsOneWidget);
    });
  });

  group('ChatInputField', () {
    testRoomsWidget('empty send is a no-op', (tester) async {
      final fake = FakeRoomChat(const RoomChatState());
      await pumpRoomsPage(tester, page(), overrides: buildOverrides(fake));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();
      expect(fake.sendCount, 0);
    });

    testRoomsWidget('non-empty send calls sendMessage and clears field', (
      tester,
    ) async {
      final fake = FakeRoomChat(const RoomChatState());
      await pumpRoomsPage(tester, page(), overrides: buildOverrides(fake));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'hi there');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      expect(fake.sendCount, 1);
      expect(fake.lastSentContent, 'hi there');
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.controller?.text, '');
    });

    testRoomsWidget('reply banner shows and close calls clearReplyingTo', (
      tester,
    ) async {
      final state = const RoomChatState(
        replyingTo: ReplyTo(
          messageId: 'orig',
          creatorUsername: 'carol',
          creatorImgUrl: 'https://example.com/c.jpg',
          index: 0,
          content: 'banner content',
        ),
      );
      final fake = FakeRoomChat(state);
      await pumpRoomsPage(tester, page(), overrides: buildOverrides(fake));
      await tester.pumpAndSettle();

      expect(find.text('@carol'), findsOneWidget);
      expect(find.text('banner content'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(fake.clearReplyingCount, 1);
    });
  });
}

// A fake whose build stays pending until the supplied future completes.
class _PendingRoomChat extends RoomChatNotifier {
  _PendingRoomChat(this._future);
  final Future<RoomChatState> _future;

  @override
  Future<RoomChatState> build(String roomId, String roomName, bool isUpcoming) =>
      _future;
}
