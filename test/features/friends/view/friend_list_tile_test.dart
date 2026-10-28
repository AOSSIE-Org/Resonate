import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/features/activity_status/view/widgets/activity_dot.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/friends/view/widgets/friend_list_tile.dart';
import 'package:resonate/features/live_audio/data/services/livekit_controller.dart';

import '../friends_test_helpers.dart';


List<Override> buildOverrides({required String uid}) => [
  requireUserProvider.overrideWithValue(fakeAuthUser(uid: uid)),
  currentUserProvider.overrideWithValue(fakeAuthUser(uid: uid)),
  liveKitControllerProvider.overrideWith(FakeLiveKitController.new),
];

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
        FriendListTile(
          friendModel: model,
          isRequest: true,
          isProcessing: false,
        ),
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
        FriendListTile(
          friendModel: model,
          isRequest: true,
          isProcessing: false,
        ),
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
        FriendListTile(
          friendModel: model,
          isRequest: true,
          isProcessing: false,
        ),
        overrides: buildOverrides(uid: 'me'),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byIcon(Icons.call), findsNothing);
    });

    testFriendsWidget('tapping accept reports to onAccept', (tester) async {
      var accepted = 0;
      final model = fakeFriendsModel(senderId: 'other');
      await pumpFriendsPage(
        tester,
        FriendListTile(
          friendModel: model,
          isRequest: true,
          isProcessing: false,
          onAccept: () => accepted++,
          onDecline: () {},
        ),
        overrides: buildOverrides(uid: 'me'),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(accepted, 1);
    });

    testFriendsWidget('tapping decline reports to onDecline', (tester) async {
      var declined = 0;
      final model = fakeFriendsModel(senderId: 'other');
      await pumpFriendsPage(
        tester,
        FriendListTile(
          friendModel: model,
          isRequest: true,
          isProcessing: false,
          onAccept: () {},
          onDecline: () => declined++,
        ),
        overrides: buildOverrides(uid: 'me'),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(declined, 1);
    });
  });

  group('FriendListTile call action', () {
    testFriendsWidget('isRequest false shows the call IconButton', (
      tester,
    ) async {
      final model = fakeFriendsModel(senderId: 'other');
      await pumpFriendsPage(
        tester,
        FriendListTile(
          friendModel: model,
          isRequest: false,
          isProcessing: false,
        ),
        overrides: buildOverrides(uid: 'me'),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.call), findsOneWidget);
      expect(find.byIcon(Icons.check), findsNothing);
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testFriendsWidget('tapping call reports to onCall', (tester) async {
      var calls = 0;
      final model = fakeFriendsModel(senderId: 'other');
      await pumpFriendsPage(
        tester,
        FriendListTile(
          friendModel: model,
          isRequest: false,
          isProcessing: false,
          onCall: () => calls++,
        ),
        overrides: buildOverrides(uid: 'me'),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.call));
      await tester.pumpAndSettle();

      expect(calls, 1);
    });
  });

  group('FriendListTile activity status', () {
    testFriendsWidget('shows the friend activity status dot', (tester) async {
      final model = fakeFriendsModel(senderId: 'other', recieverId: 'me');
      await pumpFriendsPage(
        tester,
        FriendListTile(
          friendModel: model,
          isRequest: false,
          isProcessing: false,
        ),
        overrides: buildOverrides(uid: 'me'),
        activityStatuses: {'other': ActivityStatus.online},
      );
      await tester.pumpAndSettle();

      final dot = tester.widget<ActivityDot>(find.byType(ActivityDot));
      expect(dot.status, ActivityStatus.online);
    });

    testFriendsWidget('draws no dot until the activity status resolves', (
      tester,
    ) async {
      final model = fakeFriendsModel(senderId: 'other', recieverId: 'me');
      await pumpFriendsPage(
        tester,
        FriendListTile(
          friendModel: model,
          isRequest: false,
          isProcessing: false,
        ),
        overrides: buildOverrides(uid: 'me'),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ActivityDot), findsNothing);
    });

    testFriendsWidget('a friend on dnd gets the disabled call icon', (
      tester,
    ) async {
      final model = fakeFriendsModel(senderId: 'other', recieverId: 'me');
      await pumpFriendsPage(
        tester,
        FriendListTile(
          friendModel: model,
          isRequest: false,
          isProcessing: false,
        ),
        overrides: buildOverrides(uid: 'me'),
        activityStatuses: {'other': ActivityStatus.dnd},
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.phone_disabled), findsOneWidget);
      expect(find.byIcon(Icons.call), findsNothing);
    });

    testFriendsWidget('a friend in a session gets the disabled call icon', (
      tester,
    ) async {
      final model = fakeFriendsModel(senderId: 'other', recieverId: 'me');
      await pumpFriendsPage(
        tester,
        FriendListTile(
          friendModel: model,
          isRequest: false,
          isProcessing: false,
        ),
        overrides: buildOverrides(uid: 'me'),
        activityStatuses: {'other': ActivityStatus.inRoom},
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.phone_disabled), findsOneWidget);
    });

    testFriendsWidget('invisible friends stay callable', (tester) async {
      final model = fakeFriendsModel(senderId: 'other', recieverId: 'me');
      await pumpFriendsPage(
        tester,
        FriendListTile(
          friendModel: model,
          isRequest: false,
          isProcessing: false,
        ),
        // What the tile actually receives is offline -- UserActivityStatus never
        // hands invisible to anyone else -- and offline does not block.
        activityStatuses: {'other': ActivityStatus.offline},
        overrides: buildOverrides(uid: 'me'),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.call), findsOneWidget);
    });
  });

  group('FriendListTile in-flight loading', () {
    testFriendsWidget('isProcessing replaces the request actions', (
      tester,
    ) async {
      final model = fakeFriendsModel(senderId: 'other');
      await pumpFriendsPage(
        tester,
        FriendListTile(
          friendModel: model,
          isRequest: true,
          isProcessing: true,
        ),
        overrides: buildOverrides(uid: 'me'),
      );
      // Not pumpAndSettle: the spinner animates forever and would never settle.
      await tester.pump();

      expect(find.byType(LoadingIndicator), findsOneWidget);
      expect(find.byIcon(Icons.check), findsNothing);
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testFriendsWidget('isProcessing replaces the call action', (tester) async {
      final model = fakeFriendsModel(senderId: 'other');
      await pumpFriendsPage(
        tester,
        FriendListTile(
          friendModel: model,
          isRequest: false,
          isProcessing: true,
        ),
        overrides: buildOverrides(uid: 'me'),
      );
      // Not pumpAndSettle: the spinner animates forever and would never settle.
      await tester.pump();

      expect(find.byType(LoadingIndicator), findsOneWidget);
      expect(find.byIcon(Icons.call), findsNothing);
    });
  });
}
