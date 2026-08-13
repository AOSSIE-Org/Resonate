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
    for (final tile in tester.widgetList<SwitchListTile>(
      find.byType(SwitchListTile),
    )) {
      expect(tile.value, isTrue);
    }
  });

  testWidgets('a stored false renders the switch off', (tester) async {
    final storage = FakeGetStorage();
    storage.write(AppFeature.pairChat.storageKey, false);

    await pumpFeatures(tester, storage: storage);

    final tile = tester.widget<SwitchListTile>(find.byType(SwitchListTile));
    expect(tile.value, isFalse);
  });

  testWidgets('toggling the switch off persists and flips the tile', (
    tester,
  ) async {
    final storage = await pumpFeatures(tester);

    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    expect(storage.read<bool>(AppFeature.pairChat.storageKey), isFalse);
    final tile = tester.widget<SwitchListTile>(find.byType(SwitchListTile));
    expect(tile.value, isFalse);
  });

  testWidgets('toggling it back on persists and flips the tile', (
    tester,
  ) async {
    final storage = FakeGetStorage();
    storage.write(AppFeature.pairChat.storageKey, false);
    await pumpFeatures(tester, storage: storage);

    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    expect(storage.read<bool>(AppFeature.pairChat.storageKey), isTrue);
    final tile = tester.widget<SwitchListTile>(find.byType(SwitchListTile));
    expect(tile.value, isTrue);
  });
}
