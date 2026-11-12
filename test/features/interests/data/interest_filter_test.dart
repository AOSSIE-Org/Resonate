import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/interests/data/interest_filter.dart';
import 'package:resonate/features/interests/data/repositories/interests_repository.dart';
import 'package:resonate/features/interests/model/interest.dart';

import '../../../helpers/test_root_container.dart';
import '../interests_test_helpers.dart';

void main() {
  late FakeInterestsRepository repo;

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        interestsRepositoryProvider.overrideWithValue(repo),
        currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
      ],
    );
    addTearDown(container.dispose);
    container.listen(interestFilterProvider, (_, _) {}, fireImmediately: true);
    return container;
  }

  setUp(() {
    repo = FakeInterestsRepository();
    repo.matches = (interests) => [
      for (final interest in interests)
        fakeResonateUser(uid: 'u-${interest.wire}'),
    ];
  });

  test('starts inactive and asks for nothing', () {
    final container = makeContainer();

    final state = container.read(interestFilterProvider);
    expect(state.selected, isEmpty);
    expect(state.isActive, isFalse);
    expect(state.matches.value, isEmpty);
    expect(repo.calls, isEmpty);
  });

  test('selecting an interest loads the profiles that match it', () async {
    final container = makeContainer();

    await container.read(interestFilterProvider.notifier).toggle(Interest.ai);

    final state = container.read(interestFilterProvider);
    expect(state.selected, {Interest.ai});
    expect(state.isActive, isTrue);
    expect(state.matches.value!.map((u) => u.uid), ['u-ai']);
    expect(repo.calls.single.interests, {Interest.ai});
    // the signed-in user is never their own search result
    expect(repo.calls.single.excludeUid, 'me');
  });

  test('a second interest widens the search rather than replacing it', () async {
    final container = makeContainer();
    final notifier = container.read(interestFilterProvider.notifier);

    await notifier.toggle(Interest.ai);
    await notifier.toggle(Interest.music);

    expect(container.read(interestFilterProvider).selected, {
      Interest.ai,
      Interest.music,
    });
    expect(repo.calls.last.interests, {Interest.ai, Interest.music});
  });

  test('toggling the last interest off clears the results', () async {
    final container = makeContainer();
    final notifier = container.read(interestFilterProvider.notifier);

    await notifier.toggle(Interest.ai);
    await notifier.toggle(Interest.ai);

    final state = container.read(interestFilterProvider);
    expect(state.selected, isEmpty);
    expect(state.isActive, isFalse);
    expect(state.matches.value, isEmpty);
    // no query for the empty selection
    expect(repo.calls, hasLength(1));
  });

  test('clear drops the whole selection', () async {
    final container = makeContainer();
    final notifier = container.read(interestFilterProvider.notifier);
    await notifier.toggle(Interest.ai);
    await notifier.toggle(Interest.music);

    await notifier.clear();

    expect(container.read(interestFilterProvider).selected, isEmpty);
    expect(container.read(interestFilterProvider).matches.value, isEmpty);
  });

  test('a failed query surfaces as an error, not an empty result', () async {
    repo.error = Exception('offline');
    final container = makeContainer();

    await container.read(interestFilterProvider.notifier).toggle(Interest.ai);

    expect(container.read(interestFilterProvider).matches.hasError, isTrue);
  });

  test('a slow response for a stale selection is discarded', () async {
    final container = makeContainer();
    final notifier = container.read(interestFilterProvider.notifier);

    // First tap hangs...
    final slow = Completer<void>();
    repo.gate = slow;
    final first = notifier.toggle(Interest.ai);

    // ...and a second tap resolves before it does.
    repo.gate = null;
    await notifier.toggle(Interest.music);
    slow.complete();
    await first;

    // The results belong to the second tap.
    expect(container.read(interestFilterProvider).selected, {
      Interest.ai,
      Interest.music,
    });
    expect(container.read(interestFilterProvider).matches.value!.map((u) => u.uid), [
      'u-ai',
      'u-music',
    ]);
  });
}
