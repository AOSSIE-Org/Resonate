import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/achievements/model/badge_category.dart';
import 'package:resonate/features/theme/model/achievement_colors.dart';

void main() {
  group('AchievementColors', () {
    test('both built-in themes register the extension', () {
      final source = File(
        'lib/features/theme/model/theme_modes.dart',
      ).readAsStringSync();

      final registered = RegExp(
        r'extensions: const \[([^\]]*)\]',
      ).allMatches(source).map((match) => match.group(1)!).toList();

      expect(registered, hasLength(2), reason: 'one list per theme');
      expect(registered.first, contains('AchievementColors.light'));
      expect(registered.last, contains('AchievementColors.dark'));
    });

    // Two categories sharing a colour would make the pills unreadable.
    test('category colours are distinct from each other', () {
      for (final colors in [AchievementColors.light, AchievementColors.dark]) {
        final distinct = BadgeCategory.values.map(colors.forCategory).toSet();
        expect(distinct, hasLength(BadgeCategory.values.length));
      }
    });

    test('forCategory covers every category', () {
      for (final category in BadgeCategory.values) {
        expect(AchievementColors.light.forCategory(category), isNotNull);
      }
    });

    test('light and dark differ, so a badge suits the theme it is on', () {
      expect(
        AchievementColors.light.hosting,
        isNot(AchievementColors.dark.hosting),
      );
    });

    testWidgets('of() falls back by brightness when no extension is set', (
      tester,
    ) async {
      late AchievementColors light;
      late AchievementColors dark;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Builder(
            builder: (context) {
              light = AchievementColors.of(context);
              return MaterialApp(
                theme: ThemeData(brightness: Brightness.dark),
                home: Builder(
                  builder: (context) {
                    dark = AchievementColors.of(context);
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );

      expect(light.hosting, AchievementColors.light.hosting);
      expect(dark.hosting, AchievementColors.dark.hosting);
    });

    testWidgets('of() prefers the extension the theme provides', (
      tester,
    ) async {
      const custom = AchievementColors(
        hosting: Color(0xFF010101),
        moderation: Color(0xFF020202),
        echo: Color(0xFF030303),
        rhythm: Color(0xFF040404),
        core: Color(0xFF050505),
        onBadge: Color(0xFF060606),
      );
      late AchievementColors resolved;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [custom]),
          home: Builder(
            builder: (context) {
              resolved = AchievementColors.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(resolved.hosting, const Color(0xFF010101));
    });

    test('copyWith replaces only what it is given', () {
      final updated = AchievementColors.light.copyWith(
        hosting: const Color(0xFF123456),
      );

      expect(updated.hosting, const Color(0xFF123456));
      expect(updated.moderation, AchievementColors.light.moderation);
      expect(updated.onBadge, AchievementColors.light.onBadge);
    });

    // No == on the extension, so compare colours rather than instances.
    test('lerp moves every colour, and ignores a foreign extension', () {
      final done = AchievementColors.light.lerp(AchievementColors.dark, 1.0);
      for (final category in BadgeCategory.values) {
        expect(
          done.forCategory(category),
          AchievementColors.dark.forCategory(category),
          reason: category.wire,
        );
      }

      final ignored = AchievementColors.light.lerp(null, 0.5);
      expect(ignored.hosting, AchievementColors.light.hosting);
    });
  });
}
