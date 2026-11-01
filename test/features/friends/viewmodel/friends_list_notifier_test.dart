import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/friends/data/friend_call_coordinator.dart';
import 'package:resonate/features/friends/data/friends.dart';
import 'package:resonate/features/friends/model/friends_state.dart';
import 'package:resonate/features/friends/model/start_call_outcome.dart';
import 'package:resonate/features/friends/viewmodel/friends_list_notifier.dart';

import '../friends_test_helpers.dart';

void main() {
  ProviderContainer makeContainer({
    FakeFriendsNotifier? friends,
    FakeFriendCallCoordinator? calls,
  }) {
    final container = ProviderContainer(
      overrides: [
        currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
        requireUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
        friendsProvider.overrideWith(() => friends ?? FakeFriendsNotifier()),
        friendCallCoordinatorProvider.overrideWith(
          () => calls ?? FakeFriendCallCoordinator(),
        ),
      ],
    );
    addTearDown(container.dispose);
    container.listen(friendsListProvider, (_, _) {});
    return container;
  }

  test('nothing is busy to begin with', () {
    final container = makeContainer();

    expect(container.read(friendsListProvider).busy, isEmpty);
  });

  test('friends exposes the accepted list from the data layer', () async {
    final model = fakeFriendsModel(senderId: 'other', docId: 'f1');
    final container = makeContainer(
      friends: FakeFriendsNotifier(
        buildState: FriendsState(friends: [model]),
      ),
    );
    await container.read(friendsProvider.future);

    final rows = container.read(friendsListProvider).rows;
    expect(rows.value, hasLength(1));
    expect(rows.value!.single.docId, 'f1');
  });

  test('otherNameOf picks the far side of the friendship', () {
    final container = makeContainer();
    final notifier = container.read(friendsListProvider.notifier);

    expect(
      notifier.otherNameOf(
        fakeFriendsModel(senderId: 'me', recieverName: 'Them'),
      ),
      'Them',
    );
    expect(
      notifier.otherNameOf(
        fakeFriendsModel(senderId: 'other', senderName: 'Them'),
      ),
      'Them',
    );
  });

  test('startCall rings the friend and reports it started', () async {
    final calls = FakeFriendCallCoordinator();
    final container = makeContainer(calls: calls);
    final model = fakeFriendsModel(senderId: 'other', docId: 'call-1');

    final outcome = await container
        .read(friendsListProvider.notifier)
        .startCall(model);

    expect(outcome, isA<StartCallStarted>());
    expect(calls.started.single.docId, 'call-1');
  });

  test('a call blocked by activity status comes back as blocked', () async {
    final calls = FakeFriendCallCoordinator(blockedBy: ActivityStatus.dnd);
    final container = makeContainer(calls: calls);

    final outcome = await container
        .read(friendsListProvider.notifier)
        .startCall(fakeFriendsModel(senderId: 'other'));

    expect(outcome, isA<StartCallBlocked>());
    expect((outcome as StartCallBlocked).status, ActivityStatus.dnd);
  });

  test('a thrown error comes back as failed rather than escaping', () async {
    final calls = FakeFriendCallCoordinator(throwError: true);
    final container = makeContainer(calls: calls);

    final outcome = await container
        .read(friendsListProvider.notifier)
        .startCall(fakeFriendsModel(senderId: 'other'));

    expect(outcome, isA<StartCallFailed>());
  });

  test('the row is busy while the call is being placed, then free', () async {
    final completer = Completer<void>();
    final calls = FakeFriendCallCoordinator(
      startFuture: () => completer.future,
    );
    final container = makeContainer(calls: calls);
    final notifier = container.read(friendsListProvider.notifier);
    final model = fakeFriendsModel(senderId: 'other', docId: 'call-9');

    final pending = notifier.startCall(model);
    expect(container.read(friendsListProvider).isBusy('call-9'), isTrue);

    completer.complete();
    await pending;

    expect(container.read(friendsListProvider).isBusy('call-9'), isFalse);
  });

  test('a row already in flight is not dialled twice', () async {
    final completer = Completer<void>();
    final calls = FakeFriendCallCoordinator(
      startFuture: () => completer.future,
    );
    final container = makeContainer(calls: calls);
    final notifier = container.read(friendsListProvider.notifier);
    final model = fakeFriendsModel(senderId: 'other', docId: 'call-9');

    final first = notifier.startCall(model);
    await notifier.startCall(model);

    expect(calls.startCallCount, 1);

    completer.complete();
    await first;
  });
}
