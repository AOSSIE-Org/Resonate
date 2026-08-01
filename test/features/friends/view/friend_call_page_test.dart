import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/friends/model/friend_call_model.dart';
import 'package:resonate/features/friends/model/friend_call_state.dart';
import 'package:resonate/features/friends/view/pages/friend_call_page.dart';
import 'package:resonate/features/friends/view/widgets/call_control_panel.dart';
import 'package:resonate/features/friends/view/widgets/call_user_info_row.dart';
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
}) {
  return [
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

      expect(find.byType(CallUserInfoRow), findsNothing);
      expect(find.byType(CallControlPanel), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
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

    testFriendsWidget('speaker toggle routes through the notifier', (
      tester,
    ) async {
      final fake = FakeFriendCallCoordinator(
        initial: FriendCallState(activeCall: _fakeCall()),
      );
      await _pump(
        tester,
        const FriendCallPage(),
        overrides: _overrides(FriendCallState(), notifier: fake),
      );

      await tester.tap(find.byIcon(Icons.volume_up));
      await tester.pump();
      expect(fake.toggleLoudSpeakerCount, 1);
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

      await tester.tap(find.byIcon(Icons.cancel_outlined));
      await tester.pump();
      expect(fake.endCallCount, 1);
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
