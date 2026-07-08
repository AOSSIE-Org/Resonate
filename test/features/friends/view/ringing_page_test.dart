import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/friends/model/friend_call_model.dart';
import 'package:resonate/features/friends/model/friend_call_state.dart';
import 'package:resonate/features/friends/view/pages/ringing_page.dart';
import 'package:resonate/features/friends/viewmodel/friend_call_notifier.dart';
import 'package:resonate/utils/enums/friend_call_status.dart';

import '../friends_test_helpers.dart';

// Builds a FriendCallModel directly for the active-call cases.
FriendCallModel fakeCall({
  String recieverName = 'Bob',
  String recieverProfileImageUrl = 'https://example.com/bob.jpg',
}) => FriendCallModel(
  callerName: 'Alice',
  recieverName: recieverName,
  callerUsername: 'alice',
  recieverUsername: 'bob',
  callerUid: 'me',
  recieverUid: 'bob-uid',
  callerProfileImageUrl: 'https://example.com/alice.jpg',
  recieverProfileImageUrl: recieverProfileImageUrl,
  livekitRoomId: 'room-1',
  callStatus: FriendCallStatus.waiting,
  docId: 'call-1',
);

List<Override> overridesWith(FriendCallState state, FakeFriendCallNotifier fake) {
  return [friendCallProvider.overrideWith(() => fake)];
}

void main() {
  testFriendsWidget('activeCall null renders SizedBox.shrink', (tester) async {
    final fake = FakeFriendCallNotifier();
    await pumpFriendsPage(
      tester,
      const RingingPage(),
      overrides: overridesWith(const FriendCallState(), fake),
    );
    await tester.pump(const Duration(milliseconds: 100));

    // No calling text and no avatar when there's no active call.
    expect(find.textContaining('Calling'), findsNothing);
    expect(find.byType(CircleAvatar), findsNothing);
    expect(find.byType(SizedBox), findsWidgets);
  });

  testFriendsWidget('Cancel button invokes endCall on the notifier', (
    tester,
  ) async {
    final state = FriendCallState(activeCall: fakeCall());
    final fake = FakeFriendCallNotifier(initial: state);
    await pumpFriendsPage(
      tester,
      const RingingPage(),
      overrides: overridesWith(state, fake),
    );
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(const Duration(milliseconds: 100));

    expect(fake.endCallCount, 1);
  });
}
