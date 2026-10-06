import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/friends/model/friend_call_model.dart';
import 'package:resonate/features/friends/model/friend_call_state.dart';
import 'package:resonate/features/friends/view/pages/friend_call_page.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/friends/view/widgets/call_participant_tile.dart';
import 'package:resonate/shared/widgets/session_control_bar.dart';
import 'package:resonate/shared/widgets/session_header.dart';
import 'package:resonate/features/friends/data/services/friend_call_coordinator.dart';
import 'package:resonate/features/live_audio/data/services/livekit_controller.dart';
import 'package:resonate/utils/enums/friend_call_status.dart';

import '../friends_test_helpers.dart';

FriendCallModel _fakeCall({
  String callerName = 'Alice',
  String recieverName = 'Bob',
  FriendCallStatus status = FriendCallStatus.connected,
}) => FriendCallModel(
  callerName: callerName,
  recieverName: recieverName,
  callerUsername: 'alice',
  recieverUsername: 'bob',
  callerUid: 'caller-uid',
  recieverUid: 'reciever-uid',
  callerProfileImageUrl: 'https://example.com/caller.jpg',
  recieverProfileImageUrl: 'https://example.com/reciever.jpg',
  livekitRoomId: 'room-1',
  callStatus: status,
  docId: 'call-1',
);

List<Override> _overrides(
  FriendCallState state, {
  FakeFriendCallCoordinator? notifier,
  String myUid = 'caller-uid',
}) {
  return [
    currentUserProvider.overrideWithValue(fakeAuthUser(uid: myUid)),
    liveKitControllerProvider.overrideWith(FakeLiveKitController.new),
    friendCallCoordinatorProvider.overrideWith(
      () => notifier ?? FakeFriendCallCoordinator(initial: state),
    ),
  ];
}

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  required List<Override> overrides,
}) async {
  await pumpFriendsPage(tester, child, overrides: overrides);
  await tester.pumpAndSettle();
}

void main() {
  group('FriendCallPage', () {
    testFriendsWidget('renders SizedBox.shrink when there is no active call', (
      tester,
    ) async {
      await _pump(
        tester,
        const FriendCallPage(),
        overrides: _overrides(const FriendCallState()),
      );

      expect(find.byType(CallParticipantTile), findsNothing);
      expect(find.byType(SessionControlBar), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testFriendsWidget('hanging up is the leftmost control', (tester) async {
      await _pump(
        tester,
        const FriendCallPage(),
        overrides: _overrides(FriendCallState(activeCall: _fakeCall())),
      );

      final leave = tester
          .getCenter(find.byKey(const ValueKey('session-control-leave')))
          .dx;
      final mic = tester
          .getCenter(find.byKey(const ValueKey('session-control-mic')))
          .dx;
      expect(leave, lessThan(mic));
    });

    testFriendsWidget('mic toggle routes through the notifier', (tester) async {
      final fake = FakeFriendCallCoordinator(
        initial: FriendCallState(activeCall: _fakeCall()),
      );
      await _pump(
        tester,
        const FriendCallPage(),
        overrides: _overrides(FriendCallState(), notifier: fake),
      );

      await tester.tap(find.byIcon(Icons.mic_off));
      await tester.pump();
      expect(fake.toggleMicCount, 1);
    });

    testFriendsWidget('end button routes through the notifier', (tester) async {
      final fake = FakeFriendCallCoordinator(
        initial: FriendCallState(activeCall: _fakeCall()),
      );
      await _pump(
        tester,
        const FriendCallPage(),
        overrides: _overrides(FriendCallState(), notifier: fake),
      );

      await tester.tap(find.byIcon(Icons.call_end));
      await tester.pump();
      expect(fake.endCallCount, 1);
    });

    testFriendsWidget('the other party gets the stage, we get the PiP tile', (
      tester,
    ) async {
      await _pump(
        tester,
        const FriendCallPage(),
        overrides: _overrides(
          FriendCallState(activeCall: _fakeCall()),
          myUid: 'caller-uid',
        ),
      );

      final tiles = tester
          .widgetList<CallParticipantTile>(find.byType(CallParticipantTile))
          .toList();
      expect(tiles, hasLength(2));
      // Stage first, then the corner tile.
      expect(tiles.first.compact, isFalse);
      expect(tiles.first.uid, 'reciever-uid');
      expect(tiles.first.name, 'Bob');
      expect(tiles.last.compact, isTrue);
      expect(tiles.last.uid, 'caller-uid');
      expect(tiles.last.name, 'You');
    });

    testFriendsWidget('the receiver sees the caller on the stage', (
      tester,
    ) async {
      await _pump(
        tester,
        const FriendCallPage(),
        overrides: _overrides(
          FriendCallState(activeCall: _fakeCall()),
          myUid: 'reciever-uid',
        ),
      );

      final tiles = tester
          .widgetList<CallParticipantTile>(find.byType(CallParticipantTile))
          .toList();
      expect(tiles.first.uid, 'caller-uid');
      expect(tiles.first.name, 'Alice');
      expect(tiles.last.uid, 'reciever-uid');
    });

    testFriendsWidget('swiping the page down minimises the live call', (
      tester,
    ) async {
      final fake = FakeFriendCallCoordinator(
        initial: FriendCallState(activeCall: _fakeCall()),
      );
      await _pump(
        tester,
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const FriendCallPage()),
            ),
            child: const Text('open call'),
          ),
        ),
        overrides: _overrides(FriendCallState(), notifier: fake),
      );
      await tester.tap(find.text('open call'));
      await tester.pumpAndSettle();
      expect(find.byType(FriendCallPage), findsOneWidget);

      await tester.fling(
        find.byType(SessionHeader),
        const Offset(0, 400),
        1200,
      );
      await tester.pumpAndSettle();

      // Minimised, not hung up: the call keeps running behind the miniplayer.
      expect(find.byType(FriendCallPage), findsNothing);
      expect(find.text('open call'), findsOneWidget);
      expect(fake.endCallCount, 0);
    });

    testFriendsWidget('a short drag settles back instead of minimising', (
      tester,
    ) async {
      await _pump(
        tester,
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const FriendCallPage()),
            ),
            child: const Text('open call'),
          ),
        ),
        overrides: _overrides(FriendCallState(activeCall: _fakeCall())),
      );
      await tester.tap(find.text('open call'));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(SessionHeader), const Offset(0, 40));
      await tester.pumpAndSettle();

      expect(find.byType(FriendCallPage), findsOneWidget);
    });

    testFriendsWidget('PopScope prevents popping the call page', (tester) async {
      await _pump(
        tester,
        const FriendCallPage(),
        overrides: _overrides(FriendCallState(activeCall: _fakeCall())),
      );

      final popScope = tester.widget<PopScope>(find.byType(PopScope));
      expect(popScope.canPop, isFalse);
    });
  });
}
