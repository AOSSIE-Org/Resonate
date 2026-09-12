import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/achievements/model/user_stats.dart';
import 'package:resonate/features/achievements/view/widgets/achievements_sheet.dart';
import 'package:resonate/features/achievements/view/widgets/badge_pill.dart';

import 'package:resonate/features/auth/data/current_user.dart';

import '../../../helpers/pump_widget.dart';
import '../../../helpers/test_root_container.dart';

const busyStats = UserStats(
  roomsHosted: 12,
  roomsModerated: 3,
  interactions: 84,
  activeDays: 22,
  currentStreak: 5,
  longestStreak: 9,
  badges: ['welcomer', 'echo'],
  displayedBadges: ['welcomer'],
  avatarBadge: 'echo',
);

// statsOf reads MyStats only for the signed-in uid, so say who I am.
Future<void> pumpAsMe(
  WidgetTester tester,
  Widget child, {
  UserStats myStats = UserStats.empty,
  FakeMyStats? myStatsNotifier,
  Map<String, UserStats> otherStats = const {},
}) => pumpTestApp(
  tester,
  child,
  myStats: myStats,
  myStatsNotifier: myStatsNotifier,
  otherStats: otherStats,
  overrides: [currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me'))],
);

// The showcase sits below the fold at 360dp, so a tap must scroll to it first.
Future<void> tapIcon(WidgetTester tester, IconData icon) async {
  final finder = find.byIcon(icon);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  group('AchievementsSheet', () {
    testAppWidget('shows every counter', (tester) async {
      await pumpAsMe(
        tester,
        const AchievementsSheet(uid: 'me', isOwnProfile: true),
        myStats: busyStats,
      );
      await tester.pumpAndSettle();

      expect(find.text('Rooms hosted'), findsWidgets);
      expect(find.text('12'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('84'), findsOneWidget);
      expect(find.text('22'), findsOneWidget);
      // The live streak, with the best one alongside it.
      expect(find.text('5'), findsOneWidget);
      expect(find.text('Best 9'), findsOneWidget);
    });

    // The streak chip carries an extra "Best n", which used to make it taller
    // than the other four and leave the grid ragged.
    testAppWidget('every stat chip is the same height', (tester) async {
      await pumpAsMe(
        tester,
        const AchievementsSheet(uid: 'me', isOwnProfile: true),
        myStats: busyStats,
      );
      await tester.pumpAndSettle();

      final chips = find.descendant(
        of: find.byType(StatChipsRow),
        matching: find.byType(Container),
      );
      final heights = chips
          .evaluate()
          .map((e) => (e.renderObject! as RenderBox).size.height)
          .toSet();

      expect(chips, findsNWidgets(5));
      expect(heights, hasLength(1), reason: 'ragged chip heights: $heights');
    });

    testAppWidget('shows a section per category', (tester) async {
      await pumpAsMe(
        tester,
        const AchievementsSheet(uid: 'me', isOwnProfile: true),
        myStats: busyStats,
      );
      await tester.pumpAndSettle();

      for (final category in [
        'Hosting',
        'Moderation',
        'Participation',
        'Consistency',
        'Longevity',
      ]) {
        expect(find.text(category), findsOneWidget, reason: category);
      }
    });

    testAppWidget('names the badge held and the progress to the next', (
      tester,
    ) async {
      // Someone else's sheet: no showcase rows, so the name appears once.
      await pumpAsMe(
        tester,
        const AchievementsSheet(uid: 'other', isOwnProfile: false),
        otherStats: const {'other': busyStats},
      );
      await tester.pumpAndSettle();

      // Held Welcomer at 12 hosted rooms, 25 needed for Icon.
      expect(find.text('Welcomer'), findsOneWidget);
      expect(find.text('12 of 25'), findsOneWidget);
    });

    testAppWidget('marks a category with nothing earned as locked', (
      tester,
    ) async {
      await pumpAsMe(
        tester,
        const AchievementsSheet(uid: 'me', isOwnProfile: true),
        myStats: const UserStats(roomsHosted: 1),
      );
      await tester.pumpAndSettle();

      expect(find.text('Locked'), findsWidgets);
      expect(find.text('1 of 10'), findsOneWidget);
    });

    testAppWidget('a badge kept through a broken streak still shows', (
      tester,
    ) async {
      await pumpAsMe(
        tester,
        const AchievementsSheet(uid: 'other', isOwnProfile: false),
        otherStats: const {
          'other': UserStats(
            currentStreak: 0,
            longestStreak: 9,
            badges: ['rhythm'],
          ),
        },
      );
      await tester.pumpAndSettle();

      expect(find.text('Rhythm'), findsOneWidget);
    });

    testAppWidget(
      'the showcase controls are hidden on someone else\'s profile',
      (tester) async {
        await pumpAsMe(
          tester,
          const AchievementsSheet(uid: 'other', isOwnProfile: false),
          otherStats: const {'other': busyStats},
        );
        await tester.pumpAndSettle();

        expect(find.text('Show on your profile'), findsNothing);
        expect(find.byType(BadgePill), findsNothing);
      },
    );
  });

  group('showcase', () {
    testAppWidget('offers a row per earned badge', (tester) async {
      await pumpAsMe(
        tester,
        const AchievementsSheet(uid: 'me', isOwnProfile: true),
        myStats: busyStats,
      );
      await tester.pumpAndSettle();

      expect(find.text('Show on your profile'), findsOneWidget);
      expect(find.byType(BadgePill), findsNWidgets(2));
    });

    // Flexible + Spacer both default to flex 1 and split the free space, which
    // put the toggles at a different x on every row.
    testAppWidget('the toggles line up whatever the pill width', (
      tester,
    ) async {
      await pumpAsMe(
        tester,
        const AchievementsSheet(uid: 'me', isOwnProfile: true),
        myStats: const UserStats(
          badges: ['welcomer', 'guard', 'echo', 'rhythm'],
        ),
      );
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView), const Offset(0, -2000));
      await tester.pumpAndSettle();

      List<double> leftEdgesOf(List<IconData> icons) => find
          .byWidgetPredicate((w) => w is Icon && icons.contains(w.icon))
          .evaluate()
          .map(
            (e) => (e.renderObject! as RenderBox).localToGlobal(Offset.zero).dx,
          )
          .toList();

      final pillToggles = leftEdgesOf([Icons.label, Icons.label_outline]);
      final avatarToggles = leftEdgesOf([
        Icons.account_circle,
        Icons.account_circle_outlined,
      ]);

      expect(pillToggles.length, greaterThan(1), reason: 'needs several rows');
      expect(pillToggles.toSet(), hasLength(1), reason: 'ragged: $pillToggles');
      expect(
        avatarToggles.toSet(),
        hasLength(1),
        reason: 'ragged: $avatarToggles',
      );
    });

    testAppWidget('adding a pill sends the new selection', (tester) async {
      final stats = FakeMyStats(busyStats);
      await pumpAsMe(
        tester,
        const AchievementsSheet(uid: 'me', isOwnProfile: true),
        myStatsNotifier: stats,
      );
      await tester.pumpAndSettle();

      await tapIcon(tester, Icons.label_outline);

      expect(stats.showcaseCalls.single.displayedBadges, ['welcomer', 'echo']);
    });

    testAppWidget('tapping a shown pill takes it off', (tester) async {
      final stats = FakeMyStats(busyStats);
      await pumpAsMe(
        tester,
        const AchievementsSheet(uid: 'me', isOwnProfile: true),
        myStatsNotifier: stats,
      );
      await tester.pumpAndSettle();

      await tapIcon(tester, Icons.label);

      expect(stats.showcaseCalls.single.displayedBadges, isEmpty);
    });

    testAppWidget('wearing a badge replaces the one on the avatar', (
      tester,
    ) async {
      final stats = FakeMyStats(busyStats);
      await pumpAsMe(
        tester,
        const AchievementsSheet(uid: 'me', isOwnProfile: true),
        myStatsNotifier: stats,
      );
      await tester.pumpAndSettle();

      await tapIcon(tester, Icons.account_circle_outlined);

      expect(stats.showcaseCalls.single.avatarBadge, 'welcomer');
    });

    testAppWidget('taking the avatar badge off clears it', (tester) async {
      final stats = FakeMyStats(busyStats);
      await pumpAsMe(
        tester,
        const AchievementsSheet(uid: 'me', isOwnProfile: true),
        myStatsNotifier: stats,
      );
      await tester.pumpAndSettle();

      await tapIcon(tester, Icons.account_circle);

      expect(stats.showcaseCalls.single.avatarBadge, isNull);
    });

    testAppWidget('a third pill is refused without a round trip', (
      tester,
    ) async {
      final stats = FakeMyStats(
        const UserStats(
          badges: ['welcomer', 'echo', 'core'],
          displayedBadges: ['welcomer', 'echo'],
        ),
      );
      await pumpAsMe(
        tester,
        const AchievementsSheet(uid: 'me', isOwnProfile: true),
        myStatsNotifier: stats,
      );
      await tester.pumpAndSettle();

      await tapIcon(tester, Icons.label_outline);

      expect(stats.showcaseCalls, isEmpty);
    });
  });
}
