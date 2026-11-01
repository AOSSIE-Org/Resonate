import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/core/providers/get_storage_provider.dart';
import 'package:resonate/features/settings/model/app_feature.dart';
import 'package:resonate/features/settings/view/pages/features_screen.dart';

import '../settings_test_helpers.dart';

void main() {
  Future<FakeGetStorage> pumpFeatures(
    WidgetTester tester, {
    FakeGetStorage? storage,
  }) async {
    final box = storage ?? FakeGetStorage();
    await pumpSettingsPage(
      tester,
      const FeaturesScreen(),
      overrides: [getStorageBoxProvider.overrideWithValue(box)],
    );
    await tester.pumpAndSettle();
    return box;
  }

  // Each feature owns one switch, found by the title it renders.
  Finder switchFor(String title) => find.ancestor(
    of: find.text(title),
    matching: find.byType(SwitchListTile),
  );

  bool isOn(WidgetTester tester, String title) =>
      tester.widget<SwitchListTile>(switchFor(title)).value;

  testWidgets('renders a switch for every feature, on by default', (
    tester,
  ) async {
    await pumpFeatures(tester);

    expect(find.text('Features'), findsOneWidget);
    expect(find.byType(SwitchListTile), findsNWidgets(AppFeature.values.length));
    expect(find.text('Pair Chat'), findsOneWidget);
    expect(
      find.text('One-on-one voice chats with a random or a chosen user.'),
      findsOneWidget,
    );
    expect(find.text('Live Chapter'), findsOneWidget);
    expect(
      find.text(
        'Record a story chapter live with an audience, and join the ones '
        'others host.',
      ),
      findsOneWidget,
    );
    for (final tile in tester.widgetList<SwitchListTile>(
      find.byType(SwitchListTile),
    )) {
      expect(tile.value, isTrue);
    }
  });

  testWidgets('a stored false renders that feature switch off', (tester) async {
    final storage = FakeGetStorage();
    storage.write(AppFeature.pairChat.storageKey, false);

    await pumpFeatures(tester, storage: storage);

    expect(isOn(tester, 'Pair Chat'), isFalse);
    expect(isOn(tester, 'Live Chapter'), isTrue);
  });

  testWidgets('toggling a switch off persists and flips only that tile', (
    tester,
  ) async {
    final storage = await pumpFeatures(tester);

    await tester.tap(switchFor('Live Chapter'));
    await tester.pumpAndSettle();

    expect(storage.read<bool>(AppFeature.liveChapter.storageKey), isFalse);
    expect(isOn(tester, 'Live Chapter'), isFalse);
    expect(isOn(tester, 'Pair Chat'), isTrue);
  });

  testWidgets('toggling it back on persists and flips the tile', (
    tester,
  ) async {
    final storage = FakeGetStorage();
    storage.write(AppFeature.pairChat.storageKey, false);
    await pumpFeatures(tester, storage: storage);

    await tester.tap(switchFor('Pair Chat'));
    await tester.pumpAndSettle();

    expect(storage.read<bool>(AppFeature.pairChat.storageKey), isTrue);
    expect(isOn(tester, 'Pair Chat'), isTrue);
  });
}
