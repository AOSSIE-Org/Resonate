import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/core/providers/get_storage_provider.dart';
import 'package:resonate/features/theme/model/theme_enums.dart';
import 'package:resonate/features/theme/model/theme_list.dart';
import 'package:resonate/features/theme/view/pages/theme_screen.dart';
import 'package:resonate/features/theme/view/widgets/theme_tile_title.dart';
import 'package:resonate/features/theme/view/widgets/theme_tile_trailing.dart';
import 'package:resonate/features/theme/viewmodel/theme_notifier.dart';

import '../../helpers/pump_widget.dart';
import '../../helpers/test_root_container.dart';

void main() {
  late FakeGetStorage storage;

  setUp(() => storage = FakeGetStorage());

  Future<ProviderContainer> pumpThemes(
    WidgetTester tester, {
    Themes current = Themes.classic,
  }) async {
    await storage.write('theme', current.name);
    final container = ProviderContainer(
      overrides: [getStorageBoxProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: testApp(const ThemeScreen()),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  Future<void> tapTheme(WidgetTester tester, String themeName) async {
    final title = find.widgetWithText(TileTitle, themeName);
    await tester.scrollUntilVisible(
      title,
      100,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();
    // onTap lives on the ListTile; the title column does not fill it.
    await tester.tap(find.ancestor(of: title, matching: find.byType(ListTile)));
    await tester.pumpAndSettle();
  }

  TileTrailing trailingFor(WidgetTester tester, String themeName) =>
      tester.widget<TileTrailing>(
        find.descendant(
          of: find.ancestor(
            of: find.widgetWithText(TileTitle, themeName),
            matching: find.byType(ListTile),
          ),
          matching: find.byType(TileTrailing),
        ),
      );

  group('the theme list', () {
    testAppWidget('offers every theme the app ships', (tester) async {
      await pumpThemes(tester);

      // Asserted on itemCount rather than rendered tiles: the list is lazy
      // and the last theme is below the fold at the test viewport.
      final list = tester.widget<ListView>(find.byType(ListView));
      expect(list.semanticChildCount, ThemeList.themesList.length);

      for (final theme in ThemeList.themesList) {
        await tester.scrollUntilVisible(
          find.text(theme.name),
          100,
          scrollable: find.byType(Scrollable),
        );
        expect(find.text(theme.name), findsOneWidget);
      }
    });

    testAppWidget('each tile shows the theme its three colours', (
      tester,
    ) async {
      await pumpThemes(tester);

      final title = tester.widget<TileTitle>(find.byType(TileTitle).first);
      expect(title.theme.primaryColor, isNotNull);
      expect(title.theme.secondaryColor, isNotNull);
      expect(title.theme.onPrimaryColor, isNotNull);
    });
  });

  group('the current theme', () {
    testAppWidget('is the only one marked selected', (tester) async {
      await pumpThemes(tester, current: Themes.forest);

      final selected = tester
          .widgetList<TileTrailing>(find.byType(TileTrailing))
          .where((t) => t.isSelected);
      expect(selected, hasLength(1));
      expect(trailingFor(tester, 'Forest').isSelected, isTrue);
    });

    // The tick is the only visual difference between the two trailing states.
    testAppWidget('carries a tick, the others do not', (tester) async {
      await pumpThemes(tester, current: Themes.forest);

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(trailingFor(tester, 'Classic').isSelected, isFalse);
    });

    testAppWidget('tells its title tile it is selected', (tester) async {
      await pumpThemes(tester, current: Themes.amber);

      final amber = tester.widget<TileTitle>(
        find.widgetWithText(TileTitle, 'Amber'),
      );
      expect(amber.isSelected, isTrue);
    });

    // An unrecognised stored value falls back rather than selecting nothing.
    testAppWidget('falls back to classic for an unknown stored theme', (
      tester,
    ) async {
      await storage.write('theme', 'not-a-theme');
      final container = ProviderContainer(
        overrides: [getStorageBoxProvider.overrideWithValue(storage)],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: testApp(const ThemeScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(trailingFor(tester, 'Classic').isSelected, isTrue);
    });
  });

  group('picking a theme', () {
    testAppWidget('moves the selection', (tester) async {
      final container = await pumpThemes(tester, current: Themes.classic);

      await tapTheme(tester, 'Vintage');

      expect(container.read(appThemeProvider), Themes.vintage);
      expect(trailingFor(tester, 'Vintage').isSelected, isTrue);
      final selected = tester
          .widgetList<TileTrailing>(find.byType(TileTrailing))
          .where((t) => t.isSelected);
      expect(selected, hasLength(1));
    });

    // The choice has to survive a restart, so it is written through.
    testAppWidget('remembers the choice', (tester) async {
      await pumpThemes(tester, current: Themes.classic);

      await tapTheme(tester, 'Cream');

      expect(storage.read<String>('theme'), Themes.cream.name);
    });

    testAppWidget('re-picking the current theme leaves it selected', (
      tester,
    ) async {
      final container = await pumpThemes(tester, current: Themes.time);

      await tapTheme(tester, 'Time');

      expect(container.read(appThemeProvider), Themes.time);
      expect(trailingFor(tester, 'Time').isSelected, isTrue);
    });

    // The avatar placeholder is served per theme, so it has to move too.
    testAppWidget('changes the profile image placeholder', (tester) async {
      final container = await pumpThemes(tester, current: Themes.classic);
      final before = container.read(userProfileImagePlaceholderUrlProvider);

      await tapTheme(tester, 'Forest');

      expect(
        container.read(userProfileImagePlaceholderUrlProvider),
        isNot(before),
      );
    });
  });
}
