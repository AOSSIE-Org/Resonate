import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/achievements/model/user_stats.dart';
import 'package:resonate/features/achievements/view/widgets/badge_pill.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/profile/data/repositories/profile_repository.dart';
import 'package:resonate/features/profile/model/user_profile_summary.dart';
import 'package:resonate/features/profile/view/widgets/user_profile_card.dart';

import '../../../helpers/pump_widget.dart';
import '../../../helpers/test_root_container.dart';
import '../fake_profile_repository.dart';

class SlowProfileRepository extends FakeProfileRepository {
  final Completer<UserProfileSummary> gate = Completer<UserProfileSummary>();

  @override
  Future<UserProfileSummary> fetchProfileSummary(String uid) => gate.future;
}

UserProfileSummary summary({
  String uid = 'bob',
  String name = 'Bob Marley',
  String username = 'bobby',
  double rating = 4.5,
  int followerCount = 12,
}) => UserProfileSummary(
  uid: uid,
  name: name,
  username: username,
  avatarUrl: 'https://example.com/bob.jpg',
  rating: rating,
  followerCount: followerCount,
);

Future<void> pumpCard(
  WidgetTester tester, {
  required FakeProfileRepository repo,
  Map<String, UserStats> otherStats = const {},
}) async {
  await pumpTestApp(
    tester,
    const UserProfileCard(
      uid: 'bob',
      name: 'Bob Marley',
      avatarUrl: 'https://example.com/bob.jpg',
    ),
    otherStats: otherStats,
    overrides: [
      currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
      profileRepositoryProvider.overrideWithValue(repo),
    ],
  );
}

void main() {
  group('UserProfileCard', () {
    testAppWidget('shows the name it was given before the profile lands', (
      tester,
    ) async {
      final repo = SlowProfileRepository();
      await pumpCard(tester, repo: repo);
      await tester.pump();

      expect(find.text('Bob Marley'), findsOneWidget);
      expect(find.text('@bobby'), findsNothing);
      // Both counters stand in until the numbers arrive.
      expect(find.text('—'), findsNWidgets(2));

      repo.gate.complete(summary());
      await tester.pumpAndSettle();
      expect(find.text('@bobby'), findsOneWidget);
    });

    testAppWidget('fills in the handle, followers and stars', (tester) async {
      final repo = FakeProfileRepository()..profileSummary = summary();
      await pumpCard(tester, repo: repo);
      await tester.pumpAndSettle();

      expect(repo.fetchProfileSummaryArg, 'bob');
      expect(find.text('Bob Marley'), findsOneWidget);
      expect(find.text('@bobby'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.text('Followers'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
      expect(find.text('Stars'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('—'), findsNothing);
    });

    testAppWidget('abbreviates a large follower count', (tester) async {
      final repo = FakeProfileRepository()
        ..profileSummary = summary(followerCount: 1200);
      await pumpCard(tester, repo: repo);
      await tester.pumpAndSettle();

      expect(find.text('1.2K'), findsOneWidget);
    });

    testAppWidget('keeps the caller\'s name when the lookup fails', (
      tester,
    ) async {
      final repo = FakeProfileRepository()
        ..profileSummaryError = Exception('offline');
      await pumpCard(tester, repo: repo);
      await tester.pumpAndSettle();

      expect(find.text('Bob Marley'), findsOneWidget);
      expect(find.text('—'), findsNWidgets(2));
    });

    testAppWidget('shows the badges the user has put on show', (tester) async {
      final repo = FakeProfileRepository()..profileSummary = summary();
      await pumpCard(
        tester,
        repo: repo,
        otherStats: {
          'bob': const UserStats(
            badges: ['welcomer', 'echo'],
            displayedBadges: ['welcomer', 'echo'],
          ),
        },
      );
      await tester.pumpAndSettle();

      expect(find.byType(BadgePill), findsNWidgets(2));
    });

    testAppWidget('the close button dismisses the card', (tester) async {
      final repo = FakeProfileRepository()..profileSummary = summary();
      await pumpTestApp(
        tester,
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showUserProfileCard(
              context,
              uid: 'bob',
              name: 'Bob Marley',
              avatarUrl: 'https://example.com/bob.jpg',
            ),
            child: const Text('open'),
          ),
        ),
        overrides: [
          currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
          profileRepositoryProvider.overrideWithValue(repo),
        ],
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.byType(UserProfileCard), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.byType(UserProfileCard), findsNothing);
    });
  });
}
