import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/achievements/model/known_badge.dart';
import 'package:resonate/features/achievements/model/user_stats.dart';
import 'package:resonate/features/achievements/view/widgets/badge_mark.dart';
import 'package:resonate/features/achievements/view/widgets/badge_pill.dart';
import 'package:resonate/features/achievements/view/widgets/badge_visuals.dart';
import 'package:resonate/features/activity_status/view/widgets/activity_avatar.dart';
import 'package:resonate/features/activity_status/view/widgets/activity_dot.dart';
import 'package:resonate/features/theme/model/achievement_colors.dart';
import 'package:resonate/features/theme/model/activity_status_colors.dart';
import 'package:resonate/utils/enums/activity_status.dart';

import '../../../helpers/pump_widget.dart';

Container dotContainer(WidgetTester tester) => tester.widget<Container>(
  find
      .descendant(
        of: find.byType(ActivityDot),
        matching: find.byType(Container),
      )
      .first,
);

void main() {
  group('BadgePill', () {
    testAppWidget('shows the badge name and icon', (tester) async {
      await pumpTestApp(tester, const BadgePill(badge: KnownBadge.maestro));

      expect(find.text('Maestro'), findsOneWidget);
      expect(find.byIcon(KnownBadge.maestro.icon), findsOneWidget);
    });

    testAppWidget('takes its colour from the category', (tester) async {
      await pumpTestApp(tester, const BadgePill(badge: KnownBadge.warden));
      final context = tester.element(find.byType(BadgePill));

      final decoration =
          tester
                  .widget<Container>(
                    find
                        .descendant(
                          of: find.byType(BadgePill),
                          matching: find.byType(Container),
                        )
                        .first,
                  )
                  .decoration
              as BoxDecoration;

      expect(decoration.color, AchievementColors.of(context).moderation);
    });
  });

  group('BadgePillRow', () {
    testAppWidget('renders one pill per displayed badge', (tester) async {
      await pumpTestApp(
        tester,
        const BadgePillRow(uid: 'other'),
        otherStats: const {
          'other': UserStats(
            badges: ['maestro', 'echo'],
            displayedBadges: ['maestro', 'echo'],
          ),
        },
      );
      await tester.pumpAndSettle();

      expect(find.byType(BadgePill), findsNWidgets(2));
    });

    testAppWidget('renders nothing when no badge is displayed', (tester) async {
      await pumpTestApp(tester, const BadgePillRow(uid: 'other'));
      await tester.pumpAndSettle();

      expect(find.byType(BadgePill), findsNothing);
    });

    // Two pills plus a long name is the shape that overflows a 360dp phone.
    testAppWidget('two pills stay on one line at 360dp beside a long name', (
      tester,
    ) async {
      await pumpTestApp(
        tester,
        const Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('A Really Quite Long Display Name'),
                  BadgePillRow(uid: 'other'),
                ],
              ),
            ),
          ],
        ),
        otherStats: const {
          'other': UserStats(
            badges: ['maestro', 'sentinel'],
            displayedBadges: ['maestro', 'sentinel'],
          ),
        },
      );
      await tester.pumpAndSettle();

      expect(find.byType(BadgePill), findsNWidgets(2));
      expect(tester.takeException(), isNull);

      final tops = find
          .byType(BadgePill)
          .evaluate()
          .map(
            (e) => (e.renderObject! as RenderBox).localToGlobal(Offset.zero).dy,
          )
          .toSet();
      expect(tops, hasLength(1), reason: 'the pills wrapped onto two rows');
    });
  });

  group('BadgeMark', () {
    testAppWidget('draws the worn badge', (tester) async {
      await pumpTestApp(
        tester,
        const BadgeMark(uid: 'other'),
        otherStats: const {
          'other': UserStats(badges: ['guard'], avatarBadge: 'guard'),
        },
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(KnownBadge.guard.icon), findsOneWidget);
    });

    // Callers drop it into a Stack unconditionally, so it has to be harmless.
    testAppWidget('collapses when no badge is worn', (tester) async {
      await pumpTestApp(tester, const BadgeMark(uid: 'other'));
      await tester.pumpAndSettle();

      expect(tester.getSize(find.byType(BadgeMark)), Size.zero);
    });
  });

  group('ActivityDot with a badge glyph', () {
    testAppWidget('draws the glyph over the status colour', (tester) async {
      await pumpTestApp(
        tester,
        ActivityDot(
          status: ActivityStatus.online,
          glyph: KnownBadge.echo.icon,
          glyphLabel: 'Echo',
        ),
      );
      final context = tester.element(find.byType(ActivityDot));

      final decoration = dotContainer(tester).decoration as BoxDecoration;
      expect(decoration.color, ActivityStatusColors.of(context).online);
      expect(find.byIcon(KnownBadge.echo.icon), findsOneWidget);
    });

    // A hollow ring with an icon inside reads as neither, so a badge fills the dot.
    testAppWidget('fills a normally hollow status', (tester) async {
      await pumpTestApp(
        tester,
        ActivityDot(
          status: ActivityStatus.offline,
          glyph: KnownBadge.core.icon,
        ),
      );
      final context = tester.element(find.byType(ActivityDot));

      final decoration = dotContainer(tester).decoration as BoxDecoration;
      expect(decoration.color, ActivityStatusColors.of(context).offline);
      expect(find.byIcon(KnownBadge.core.icon), findsOneWidget);
    });

    testAppWidget('leaves an unbadged hollow status hollow', (tester) async {
      await pumpTestApp(
        tester,
        const ActivityDot(status: ActivityStatus.offline),
      );
      final context = tester.element(find.byType(ActivityDot));

      final decoration = dotContainer(tester).decoration as BoxDecoration;
      expect(decoration.color, Theme.of(context).colorScheme.surface);
    });

    testAppWidget('reads out the status and the badge together', (
      tester,
    ) async {
      await pumpTestApp(
        tester,
        ActivityDot(
          status: ActivityStatus.online,
          glyph: KnownBadge.icon.icon,
          glyphLabel: 'Icon',
        ),
      );

      expect(
        tester.getSemantics(find.byType(ActivityDot)).label,
        contains('Icon'),
      );
    });
  });

  group('ActivityAvatar', () {
    testAppWidget('gives the dot more room when a badge is worn', (
      tester,
    ) async {
      await pumpTestApp(
        tester,
        ActivityAvatar(
          imageUrl: null,
          status: ActivityStatus.online,
          radius: 40,
          dotSize: 14,
          badgeGlyph: KnownBadge.rhythm.icon,
        ),
      );

      expect(tester.getSize(find.byType(ActivityDot)).width, greaterThan(14));
    });

    testAppWidget('keeps the plain dot size when no badge is worn', (
      tester,
    ) async {
      await pumpTestApp(
        tester,
        const ActivityAvatar(
          imageUrl: null,
          status: ActivityStatus.online,
          radius: 40,
          dotSize: 14,
        ),
      );

      expect(tester.getSize(find.byType(ActivityDot)).width, 14);
    });
  });
}
