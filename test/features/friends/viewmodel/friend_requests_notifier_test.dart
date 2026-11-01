import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/friends/data/friends.dart';
import 'package:resonate/features/friends/model/friends_state.dart';
import 'package:resonate/features/friends/viewmodel/friend_requests_notifier.dart';

import '../friends_test_helpers.dart';

void main() {
  ProviderContainer makeContainer({FakeFriendsNotifier? friends}) {
    final container = ProviderContainer(
      overrides: [
        currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
        requireUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
        friendsProvider.overrideWith(() => friends ?? FakeFriendsNotifier()),
      ],
    );
    addTearDown(container.dispose);
    container.listen(friendRequestsProvider, (_, _) {});
    return container;
  }

  test('incoming drops the requests we sent ourselves', () async {
    final mine = fakeFriendsModel(
      senderId: 'me',
      docId: 'outgoing',
    ).copyWith(requestSentByUserId: 'me');
    final theirs = fakeFriendsModel(
      senderId: 'other',
      docId: 'incoming',
    ).copyWith(requestSentByUserId: 'other');
    final container = makeContainer(
      friends: FakeFriendsNotifier(
        buildState: FriendsState(friendRequests: [mine, theirs]),
      ),
    );
    await container.read(friendsProvider.future);

    final incoming = container.read(friendRequestsProvider).rows.value!;

    expect(incoming.map((f) => f.docId), ['incoming']);
  });

  test('accept passes the request to the data layer', () async {
    final friends = FakeFriendsNotifier();
    final container = makeContainer(friends: friends);
    final model = fakeFriendsModel(senderId: 'other', docId: 'req-1');

    final ok = await container
        .read(friendRequestsProvider.notifier)
        .accept(model);

    expect(ok, isTrue);
    expect(friends.accepted.single.docId, 'req-1');
    expect(friends.declined, isEmpty);
  });

  test('decline passes the request to the data layer', () async {
    final friends = FakeFriendsNotifier();
    final container = makeContainer(friends: friends);
    final model = fakeFriendsModel(senderId: 'other', docId: 'req-2');

    final ok = await container
        .read(friendRequestsProvider.notifier)
        .decline(model);

    expect(ok, isTrue);
    expect(friends.declined.single.docId, 'req-2');
    expect(friends.accepted, isEmpty);
  });

  // The tile used to let a failure escape as an unhandled async error.
  test('a failing accept reports false instead of throwing', () async {
    final friends = FakeFriendsNotifier(
      acceptFuture: () => Future<void>.error(StateError('boom')),
    );
    final container = makeContainer(friends: friends);

    final ok = await container
        .read(friendRequestsProvider.notifier)
        .accept(fakeFriendsModel(senderId: 'other', docId: 'req-3'));

    expect(ok, isFalse);
  });

  test('the row is busy while the action runs, then free', () async {
    final completer = Completer<void>();
    final friends = FakeFriendsNotifier(acceptFuture: () => completer.future);
    final container = makeContainer(friends: friends);
    final notifier = container.read(friendRequestsProvider.notifier);
    final model = fakeFriendsModel(senderId: 'other', docId: 'req-4');

    final pending = notifier.accept(model);
    expect(container.read(friendRequestsProvider).isBusy('req-4'), isTrue);

    completer.complete();
    await pending;

    expect(container.read(friendRequestsProvider).isBusy('req-4'), isFalse);
  });

  test('a row already in flight is not actioned twice', () async {
    final completer = Completer<void>();
    final friends = FakeFriendsNotifier(acceptFuture: () => completer.future);
    final container = makeContainer(friends: friends);
    final notifier = container.read(friendRequestsProvider.notifier);
    final model = fakeFriendsModel(senderId: 'other', docId: 'req-5');

    final first = notifier.accept(model);
    await notifier.accept(model);

    expect(friends.accepted, hasLength(1));

    completer.complete();
    await first;
  });
}
