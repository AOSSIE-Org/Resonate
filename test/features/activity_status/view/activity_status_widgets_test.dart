import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/activity_status/data/my_activity_status.dart';
import 'package:resonate/features/activity_status/view/widgets/activity_avatar.dart';
import 'package:resonate/features/activity_status/view/widgets/activity_dot.dart';
import 'package:resonate/features/activity_status/view/widgets/activity_status_sheet.dart';
import 'package:resonate/features/theme/model/activity_status_colors.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../activity_status_test_helpers.dart';

void main() {
  group('ActivityDot', () {
    testActivityStatusWidget('online is a filled dot', (tester) async {
      await pumpActivityStatusWidget(
        tester,
        const ActivityDot(status: ActivityStatus.online),
      );
      await tester.pumpAndSettle();

      final decoration =
          tester
                  .widget<Container>(
                    find.descendant(
                      of: find.byType(ActivityDot),
                      matching: find.byType(Container),
                    ).first,
                  )
                  .decoration
              as BoxDecoration;
      expect(decoration.color, ActivityStatusColors.light.online);
      expect(decoration.shape, BoxShape.circle);
    });

    testActivityStatusWidget('takes its colour from the theme extension', (
      tester,
    ) async {
      const custom = ActivityStatusColors(
        online: Color(0xFF112233),
        dnd: Color(0xFFED4245),
        inRoom: Color(0xFFFAA81A),
        invisible: Color(0xFF80848E),
        offline: Color(0xFF80848E),
        onStatus: Color(0xFFFFFFFF),
      );
      await pumpActivityStatusWidget(
        tester,
        const ActivityDot(status: ActivityStatus.online),
        theme: ThemeData(extensions: const [custom]),
      );
      await tester.pumpAndSettle();

      final decoration =
          tester
                  .widget<Container>(
                    find.descendant(
                      of: find.byType(ActivityDot),
                      matching: find.byType(Container),
                    ).first,
                  )
                  .decoration
              as BoxDecoration;
      expect(decoration.color, const Color(0xFF112233));
    });

    testActivityStatusWidget('offline is hollow, not a filled colour', (tester) async {
      await pumpActivityStatusWidget(
        tester,
        const ActivityDot(status: ActivityStatus.offline),
      );
      await tester.pumpAndSettle();

      // Two containers: the outer ring and the inner hollow marker.
      expect(
        find.descendant(
          of: find.byType(ActivityDot),
          matching: find.byType(Container),
        ),
        findsNWidgets(2),
      );
    });

    testActivityStatusWidget('is labelled for screen readers', (tester) async {
      await pumpActivityStatusWidget(
        tester,
        const ActivityDot(status: ActivityStatus.dnd),
      );
      await tester.pumpAndSettle();

      expect(
        tester.getSemantics(find.byType(ActivityDot)).label,
        'Do Not Disturb',
      );
    });
  });

  group('ActivityAvatar', () {
    testActivityStatusWidget('draws a dot when the status is known', (tester) async {
      await pumpActivityStatusWidget(
        tester,
        ActivityAvatar(
          imageUrl: 'https://example.com/a.jpg',
          status: ActivityStatus.dnd,
          radius: UiSizes.size_25,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ActivityDot), findsOneWidget);
      expect(
        tester.widget<ActivityDot>(find.byType(ActivityDot)).status,
        ActivityStatus.dnd,
      );
    });

    testActivityStatusWidget('draws no dot for an unknown status', (tester) async {
      await pumpActivityStatusWidget(
        tester,
        ActivityAvatar(
          imageUrl: 'https://example.com/a.jpg',
          status: null,
          radius: UiSizes.size_25,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ActivityDot), findsNothing);
    });

    testActivityStatusWidget('falls back to a person icon without an image', (
      tester,
    ) async {
      await pumpActivityStatusWidget(
        tester,
        ActivityAvatar(
          imageUrl: null,
          status: ActivityStatus.online,
          radius: UiSizes.size_25,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });
  });

  group('ActivityStatusSheet', () {
    testActivityStatusWidget('offers exactly the user-selectable statuses', (
      tester,
    ) async {
      await pumpActivityStatusWidget(
        tester,
        const ActivityStatusSheet(),
        overrides: activityStatusOverrides(),
      );
      await tester.pumpAndSettle();

      expect(find.text('Online'), findsOneWidget);
      expect(find.text('Do Not Disturb'), findsOneWidget);
      expect(find.text('Invisible'), findsOneWidget);
      // System-driven, and not the current status here, so absent entirely.
      expect(find.text('In a session'), findsNothing);
      expect(find.text('Offline'), findsNothing);
    });

    testActivityStatusWidget('picking a status routes through the notifier', (
      tester,
    ) async {
      final fake = FakeMyActivityStatus();
      await pumpActivityStatusWidget(
        tester,
        const ActivityStatusSheet(),
        overrides: [myActivityStatusProvider.overrideWith(() => fake)],
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Do Not Disturb'));
      await tester.pumpAndSettle();

      expect(fake.setStatusCalls, [ActivityStatus.dnd]);
    });

    testActivityStatusWidget('marks the current choice with a check', (tester) async {
      await pumpActivityStatusWidget(
        tester,
        const ActivityStatusSheet(),
        overrides: activityStatusOverrides(myStatus: ActivityStatus.invisible),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      final checkedTile = find.ancestor(
        of: find.byIcon(Icons.check_rounded),
        matching: find.byType(ListTile),
      );
      expect(
        find.descendant(of: checkedTile, matching: find.text('Invisible')),
        findsOneWidget,
      );
    });

    testActivityStatusWidget('shows a system-driven status as read-only context', (
      tester,
    ) async {
      await pumpActivityStatusWidget(
        tester,
        const ActivityStatusSheet(),
        overrides: activityStatusOverrides(myStatus: ActivityStatus.inRoom),
      );
      await tester.pumpAndSettle();

      // Present as context, but not offered as one of the four choices.
      expect(find.text('In a session'), findsOneWidget);
      final tile = tester.widget<ListTile>(
        find.ancestor(
          of: find.text('In a session'),
          matching: find.byType(ListTile),
        ),
      );
      expect(tile.enabled, isFalse);
    });
  });
}
