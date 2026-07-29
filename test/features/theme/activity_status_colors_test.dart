import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/theme/model/activity_status_colors.dart';

void main() {
  group('ActivityStatusColors', () {
    test('both built-in themes register the extension', () {
      final source = File(
        'lib/features/theme/model/theme_modes.dart',
      ).readAsStringSync();

      expect(
        source,
        contains('extensions: const [ActivityStatusColors.light]'),
        reason: 'the light theme must carry ActivityStatusColors',
      );
      expect(
        source,
        contains('extensions: const [ActivityStatusColors.dark]'),
        reason: 'the dark theme must carry ActivityStatusColors',
      );
    });

    test('status colours are distinct from each other', () {
      for (final colors in [
        ActivityStatusColors.light,
        ActivityStatusColors.dark,
      ]) {
        final distinct = {
          colors.online,
          colors.dnd,
          colors.inRoom,
          colors.offline,
        };
        expect(distinct, hasLength(4));
        expect(colors.invisible, colors.offline);
      }
    });

    testWidgets('of() falls back by brightness when the theme has no extension',
        (tester) async {
      late ActivityStatusColors light;
      late ActivityStatusColors dark;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Builder(
            builder: (context) {
              light = ActivityStatusColors.of(context);
              return Theme(
                data: ThemeData(brightness: Brightness.dark),
                child: Builder(
                  builder: (context) {
                    dark = ActivityStatusColors.of(context);
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );

      expect(light.online, ActivityStatusColors.light.online);
      expect(dark.online, ActivityStatusColors.dark.online);
    });

    testWidgets('of() prefers the extension the theme provides', (tester) async {
      const custom = ActivityStatusColors(
        online: Color(0xFF010101),
        dnd: Color(0xFF030303),
        inRoom: Color(0xFF040404),
        invisible: Color(0xFF050505),
        offline: Color(0xFF060606),
      );
      late ActivityStatusColors resolved;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [custom]),
          home: Builder(
            builder: (context) {
              resolved = ActivityStatusColors.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(resolved.online, const Color(0xFF010101));
    });

    test('lerp moves every channel toward the other set', () {
      final mid = ActivityStatusColors.light.lerp(
        ActivityStatusColors.dark,
        1,
      );

      expect(mid.online, ActivityStatusColors.dark.online);
      expect(mid.offline, ActivityStatusColors.dark.offline);
    });
  });
}
