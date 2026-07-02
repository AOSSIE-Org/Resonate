import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/viewmodel/current_user.dart';
import 'package:resonate/features/friends/model/friends_state.dart';
import 'package:resonate/features/friends/view/pages/friend_requests_page.dart';
import 'package:resonate/features/friends/view/pages/friends_page.dart';
import 'package:resonate/features/friends/view/widgets/friend_list_tile.dart';
import 'package:resonate/features/friends/view/widgets/friends_empty_view.dart';
import 'package:resonate/features/friends/viewmodel/friends_notifier.dart';
import 'package:resonate/utils/enums/friend_request_status.dart';

import '../friends_test_helpers.dart';

List<Override> _overridesFor(
  FriendsState state, {
  Future<void>? buildFuture,
  String uid = 'me',
}) {
  final user = fakeAuthUser(uid: uid);
  return [
    requireUserProvider.overrideWithValue(user),
    currentUserProvider.overrideWithValue(user),
    friendsProvider.overrideWith(
      () => FakeFriendsNotifier(buildState: state, buildFuture: buildFuture),
    ),
  ];
}

// Overrides whose friendsProvider build() throws (AsyncError path).
List<Override> _errorOverrides({String uid = 'me'}) {
  final user = fakeAuthUser(uid: uid);
  return [
    requireUserProvider.overrideWithValue(user),
    currentUserProvider.overrideWithValue(user),
    friendsProvider.overrideWith(
      () => FakeFriendsNotifier(throwOnBuild: true),
    ),
  ];
}

void main() {
  group('FriendsPage', () {
    testFriendsWidget('shows a loader while friends resolve', (tester) async {
      final completer = Completer<void>();
      await pumpFriendsPage(
        tester,
        const FriendsPage(),
        overrides: _overridesFor(
          const FriendsState(),
          buildFuture: completer.future,
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete();
      await tester.pumpAndSettle();
    });

    testFriendsWidget('shows the empty view when build errors', (tester) async {
      await pumpFriendsPage(
        tester,
        const FriendsPage(),
        overrides: _errorOverrides(),
      );
      await tester.pumpAndSettle();

      final empty = tester.widget<FriendsEmptyView>(
        find.byType(FriendsEmptyView),
      );
      expect(empty.isRequestsScreen, isFalse);
      expect(find.byType(FriendListTile), findsNothing);
    });

    testFriendsWidget('shows the empty view when the accepted list is empty', (
      tester,
    ) async {
      await pumpFriendsPage(
        tester,
        const FriendsPage(),
        overrides: _overridesFor(const FriendsState()),
      );
      await tester.pumpAndSettle();

      final empty = tester.widget<FriendsEmptyView>(
        find.byType(FriendsEmptyView),
      );
      expect(empty.isRequestsScreen, isFalse);
      expect(find.byType(FriendListTile), findsNothing);
    });

    testFriendsWidget('renders one FriendListTile per accepted friend', (
      tester,
    ) async {
      final friends = [
        // Current user is the sender -> tile shows the reciever name.
        fakeFriendsModel(
          docId: 'f1',
          senderId: 'me',
          recieverId: 'friend-1',
          recieverName: 'Friend One',
          requestStatus: FriendRequestStatus.accepted,
        ),
        fakeFriendsModel(
          docId: 'f2',
          senderId: 'me',
          recieverId: 'friend-2',
          recieverName: 'Friend Two',
          requestStatus: FriendRequestStatus.accepted,
        ),
      ];
      await pumpFriendsPage(
        tester,
        const FriendsPage(),
        overrides: _overridesFor(FriendsState(friends: friends)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FriendListTile), findsNWidgets(2));
      expect(find.byType(FriendsEmptyView), findsNothing);
      expect(find.text('Friend One'), findsOneWidget);
      expect(find.text('Friend Two'), findsOneWidget);
      // Non-request tiles show a call button, not accept/decline.
      expect(find.byIcon(Icons.call), findsNWidgets(2));
      expect(find.byIcon(Icons.check), findsNothing);
    });
  });

  group('FriendRequestsPage', () {
    testFriendsWidget('shows a loader while requests resolve', (tester) async {
      final completer = Completer<void>();
      await pumpFriendsPage(
        tester,
        const FriendRequestsPage(),
        overrides: _overridesFor(
          const FriendsState(),
          buildFuture: completer.future,
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete();
      await tester.pumpAndSettle();
    });

    testFriendsWidget('shows the requests empty view on error', (tester) async {
      await pumpFriendsPage(
        tester,
        const FriendRequestsPage(),
        overrides: _errorOverrides(),
      );
      await tester.pumpAndSettle();

      final empty = tester.widget<FriendsEmptyView>(
        find.byType(FriendsEmptyView),
      );
      expect(empty.isRequestsScreen, isTrue);
      expect(find.byType(FriendListTile), findsNothing);
    });

    testFriendsWidget(
      'shows the empty view when there are no incoming requests',
      (tester) async {
        // Only an outgoing request (sent by me) -> filtered out.
        final outgoing = fakeFriendsModel(
          docId: 'out-1',
          senderId: 'me',
          recieverId: 'friend-3',
          requestSentByUserId: 'me',
          requestStatus: FriendRequestStatus.sent,
        );
        await pumpFriendsPage(
          tester,
          const FriendRequestsPage(),
          overrides: _overridesFor(
            FriendsState(friendRequests: [outgoing]),
          ),
        );
        await tester.pumpAndSettle();

        final empty = tester.widget<FriendsEmptyView>(
          find.byType(FriendsEmptyView),
        );
        expect(empty.isRequestsScreen, isTrue);
        expect(find.byType(FriendListTile), findsNothing);
      },
    );

    testFriendsWidget(
      'renders only incoming requests as request tiles',
      (tester) async {
        // Incoming: sent by someone else to me.
        final incoming = fakeFriendsModel(
          docId: 'in-1',
          senderId: 'friend-2',
          recieverId: 'me',
          senderName: 'Incoming Friend',
          requestSentByUserId: 'friend-2',
          requestStatus: FriendRequestStatus.sent,
        );
        // Outgoing: sent by me -> excluded.
        final outgoing = fakeFriendsModel(
          docId: 'out-1',
          senderId: 'me',
          recieverId: 'friend-3',
          recieverName: 'Outgoing Friend',
          requestSentByUserId: 'me',
          requestStatus: FriendRequestStatus.sent,
        );
        await pumpFriendsPage(
          tester,
          const FriendRequestsPage(),
          overrides: _overridesFor(
            FriendsState(friendRequests: [incoming, outgoing]),
          ),
        );
        await tester.pumpAndSettle();

        // Exactly one tile (the incoming one), rendered as a request.
        expect(find.byType(FriendListTile), findsOneWidget);
        final tile = tester.widget<FriendListTile>(find.byType(FriendListTile));
        expect(tile.isRequest, isTrue);
        expect(tile.friendModel.docId, 'in-1');

        // Current user is the reciever -> shows the sender name.
        expect(find.text('Incoming Friend'), findsOneWidget);
        expect(find.text('Outgoing Friend'), findsNothing);

        // Request tiles show accept/decline, not a call button.
        expect(find.byIcon(Icons.check), findsOneWidget);
        expect(find.byIcon(Icons.close), findsOneWidget);
        expect(find.byIcon(Icons.call), findsNothing);
      },
    );
  });
}
