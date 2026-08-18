import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/core/providers/get_storage_provider.dart';
import 'package:resonate/features/settings/data/feature_flags.dart';
import 'package:resonate/features/settings/model/app_feature.dart';

import '../../helpers/test_root_container.dart';

void main() {
  ProviderContainer containerWith(FakeGetStorage storage) {
    final container = ProviderContainer(
      overrides: [getStorageBoxProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('every feature is enabled when nothing was stored', () {
    final container = containerWith(FakeGetStorage());

    expect(container.read(featureFlagsProvider), AppFeature.values.toSet());
  });

  test('a stored false hides that feature on the next launch', () {
    final storage = FakeGetStorage();
    storage.write(AppFeature.pairChat.storageKey, false);

    final container = containerWith(storage);

    expect(container.read(featureFlagsProvider), isNot(contains(AppFeature.pairChat)));
  });

  test('setEnabled(false) drops the feature and persists the choice', () async {
    final storage = FakeGetStorage();
    final container = containerWith(storage);

    await container
        .read(featureFlagsProvider.notifier)
        .setEnabled(AppFeature.pairChat, false);

    expect(container.read(featureFlagsProvider), isNot(contains(AppFeature.pairChat)));
    expect(storage.read<bool>(AppFeature.pairChat.storageKey), isFalse);
  });

  test('setEnabled(true) restores the feature and persists the choice', () async {
    final storage = FakeGetStorage();
    storage.write(AppFeature.pairChat.storageKey, false);
    final container = containerWith(storage);

    await container
        .read(featureFlagsProvider.notifier)
        .setEnabled(AppFeature.pairChat, true);

    expect(container.read(featureFlagsProvider), contains(AppFeature.pairChat));
    expect(storage.read<bool>(AppFeature.pairChat.storageKey), isTrue);
  });

  test('featureEnabled tracks the flag it was asked about', () async {
    final container = containerWith(FakeGetStorage());
    final provider = featureEnabledProvider(AppFeature.pairChat);

    expect(container.read(provider), isTrue);

    await container
        .read(featureFlagsProvider.notifier)
        .setEnabled(AppFeature.pairChat, false);

    expect(container.read(provider), isFalse);
  });

  test('every feature owns a distinct storage key', () {
    final keys = AppFeature.values.map((f) => f.storageKey).toSet();

    expect(keys, hasLength(AppFeature.values.length));
  });

  test('pair chat owns its three routes', () {
    expect(
      AppFeature.pairChat.routes,
      {'/pairing', '/pairChat', '/pairChatUsers'},
    );
  });

  test('live chapter owns its two routes', () {
    expect(
      AppFeature.liveChapter.routes,
      {'/liveChapterScreen', '/verifyChapterDetails'},
    );
  });

  test('no two features claim the same route', () {
    final claimed = AppFeature.values.expand((f) => f.routes).toList();

    expect(claimed.toSet(), hasLength(claimed.length));
  });

  test('toggling one feature leaves the others alone', () async {
    final container = containerWith(FakeGetStorage());

    await container
        .read(featureFlagsProvider.notifier)
        .setEnabled(AppFeature.liveChapter, false);

    expect(container.read(featureFlagsProvider), contains(AppFeature.pairChat));
    expect(
      container.read(featureEnabledProvider(AppFeature.liveChapter)),
      isFalse,
    );
  });
}
