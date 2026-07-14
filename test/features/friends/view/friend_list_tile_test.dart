import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/friends/view/widgets/friend_list_tile.dart';
import 'package:resonate/features/friends/data/services/friend_call_coordinator.dart';
import 'package:resonate/features/friends/data/friends.dart';
import 'package:resonate/features/rooms/data/services/livekit_controller.dart';

import '../friends_test_helpers.dart';

// uid == senderId -> userIsSender true (shows receiver side); else sender side.
List<Override> buildOverrides({
  required String uid,
  FakeFriendsNotifier? friends,
  FakeFriendCallCoordinator? calls,
}) {
  return [
    requireUserProvider.overrideWithValue(fakeAuthUser(uid: uid)),
    currentUserProvider.overrideWithValue(fakeAuthUser(uid: uid)),
    liveKitControllerProvider.overrideWith(FakeLiveKitController.new),
    friendsProvider.overrideWith(() => friends ?? FakeFriendsNotifier()),
    friendCallCoordinatorProvider.overrideWith(() => calls ?? FakeFriendCallCoordinator()),
  ];
}

void main() {
  group('FriendListTile identity side', () {
    testFriendsWidget('userIsSender shows receiver name/username/rating', (
      tester,
    ) async {
      final model = fakeFriendsModel(
        senderId: 'me',
        recieverName: 'Recv Name',
        recieverUsername: 'recv_user',
        recieverRating: 3.5,
      );
      await pumpFriendsPage(
        tester,
        FriendListTile(friendModel: model, isRequest: true),
        overrides: buildOverrides(uid: 'me'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Recv Name'), findsOneWidget);
      expect(find.text('recv_user'), findsOneWidget);
      expect(find.text('3.5'), findsOneWidget);
    });

    testFriendsWidget('not sender shows sender name/username/rating', (
      tester,
    ) async {
      final model = fakeFriendsModel(
        senderId: 'other',
        senderName: 'Sender Name',
        senderUsername: 'sender_user',
        senderRating: 4.2,
      );
      await pumpFriendsPage(
        tester,
        FriendListTile(friendModel: model, isRequest: true),
        overrides: buildOverrides(uid: 'me'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sender Name'), findsOneWidget);
      expect(find.text('sender_user'), findsOneWidget);
      expect(find.text('4.2'), findsOneWidget);
    });
  });

  group('FriendListTile request actions', () {
    testFriendsWidget('isRequest shows accept + decline IconButtons', (
      tester,
    ) async {
      final model = fakeFriendsModel(senderId: 'other');
      await pumpFriendsPage(
        tester,
        FriendListTile(friendModel: model, isRequest: true),
        overrides: buildOverrides(uid: 'me'),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byIcon(Icons.call), findsNothing);
    });

    testFriendsWidget('tapping accept calls acceptFriendRequest', (
      tester,
    ) async {
      final model = fakeFriendsModel(senderId: 'other', docId: 'req-1');
      final friends = FakeFriendsNotifier();
      await pumpFriendsPage(
        tester,
        FriendListTile(friendModel: model, isRequest: true),
        overrides: buildOverrides(uid: 'me', friends: friends),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(friends.accepted, hasLength(1));
      expect(friends.accepted.first.docId, 'req-1');
      expect(friends.declined, isEmpty);
    });

    testFriendsWidget('tapping decline calls declineFriendRequest', (
      tester,
    ) async {
      final model = fakeFriendsModel(senderId: 'other', docId: 'req-2');
      final friends = FakeFriendsNotifier();
      await pumpFriendsPage(
        tester,
        FriendListTile(friendModel: model, isRequest: true),
        overrides: buildOverrides(uid: 'me', friends: friends),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(friends.declined, hasLength(1));
      expect(friends.declined.first.docId, 'req-2');
      expect(friends.accepted, isEmpty);
    });
  });

  group('FriendListTile call action', () {
    testFriendsWidget('isRequest false shows the call IconButton', (
      tester,
    ) async {
      final model = fakeFriendsModel(senderId: 'other');
      await pumpFriendsPage(
        tester,
        FriendListTile(friendModel: model, isRequest: false),
        overrides: buildOverrides(uid: 'me'),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.call), findsOneWidget);
      expect(find.byIcon(Icons.check), findsNothing);
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testFriendsWidget('tapping call calls startCall', (tester) async {
      final model = fakeFriendsModel(senderId: 'other', docId: 'call-1');
      final calls = FakeFriendCallCoordinator();
      await pumpFriendsPage(
        tester,
        FriendListTile(friendModel: model, isRequest: false),
        overrides: buildOverrides(uid: 'me', calls: calls),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.call));
      await tester.pumpAndSettle();

      expect(calls.started, hasLength(1));
      expect(calls.started.first.docId, 'call-1');
    });

    testFriendsWidget('startCall throwing is caught and restores the button', (
      tester,
    ) async {
      final model = fakeFriendsModel(senderId: 'other');
      final calls = FakeFriendCallCoordinator(throwError: true);
      await pumpFriendsPage(
        tester,
        FriendListTile(friendModel: model, isRequest: false),
        overrides: buildOverrides(uid: 'me', calls: calls),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.call));
      await tester.pumpAndSettle();

      // Error was swallowed via customSnackbar; button restored, not stuck.
      expect(calls.started, hasLength(1));
      expect(find.byIcon(Icons.call), findsOneWidget);
      expect(find.byType(LoadingIndicator), findsNothing);
    });
  });

  group('FriendListTile in-flight loading', () {
    testFriendsWidget('shows LoadingIndicator while action runs then restores', (
      tester,
    ) async {
      final completer = Completer<void>();
      final model = fakeFriendsModel(senderId: 'other');
      final friends = FakeFriendsNotifier(acceptFuture: () => completer.future);
      await pumpFriendsPage(
        tester,
        FriendListTile(friendModel: model, isRequest: true),
        overrides: buildOverrides(uid: 'me', friends: friends),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.check));
      await tester.pump();

      // Action pending -> spinner replaces the action row.
      expect(find.byType(LoadingIndicator), findsOneWidget);
      expect(find.byIcon(Icons.check), findsNothing);
      expect(find.byIcon(Icons.close), findsNothing);

      completer.complete();
      await tester.pumpAndSettle();

      // Restored to the accept/decline buttons.
      expect(find.byType(LoadingIndicator), findsNothing);
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });
  });
}
