import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:resonate/features/achievements/model/known_badge.dart';
import 'package:resonate/features/achievements/model/user_stats.dart';
import 'package:resonate/features/achievements/view/widgets/badge_pill.dart';
import 'package:resonate/features/achievements/view/widgets/badge_visuals.dart';
import 'package:resonate/features/activity_status/view/widgets/activity_dot.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/friends/data/friends.dart';
import 'package:resonate/features/profile/view/pages/profile_page.dart';
import 'package:resonate/shared/model/resonate_user.dart';
import 'package:resonate/utils/enums/activity_status.dart';

import '../../friends/friends_test_helpers.dart' show FakeFriendsNotifier;
import '../profile_test_helpers.dart';

void main() {
  final me = fakeAuthUser(uid: 'me', profileImageUrl: 'https://x/me.jpg');

  List<Override> withFriends() => [
    currentUserProvider.overrideWithValue(me),
    friendsProvider.overrideWith(FakeFriendsNotifier.new),
  ];

  void usePhoneViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1600, 2600);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  ActivityDot? dot(WidgetTester tester) {
    final found = find.byType(ActivityDot);
    return found.evaluate().isEmpty ? null : tester.widget<ActivityDot>(found);
  }

  testWidgets('own profile shows your own activity status', (tester) async {
    await mockNetworkImagesFor(() async {
      usePhoneViewport(tester);
      await pumpProfilePage(
        tester,
        ProfilePage(),
        authState: AuthState.authenticated(me),
        myStatus: ActivityStatus.dnd,
        overrides: withFriends(),
      );

      expect(dot(tester)?.status, ActivityStatus.dnd);
    });
  });

  group('someone else\'s profile', () {
    final creator = ResonateUser(uid: 'creator-1', name: 'Creator');

    testWidgets('shows their status when they are a friend', (tester) async {
      await mockNetworkImagesFor(() async {
        usePhoneViewport(tester);
        await pumpProfilePage(
          tester,
          ProfilePage(isCreatorProfile: true, creator: creator),
          authState: AuthState.authenticated(me),
          activityStatuses: const {'creator-1': ActivityStatus.online},
          overrides: withFriends(),
        );

        expect(dot(tester)?.status, ActivityStatus.online);
      });
    });

    testWidgets('shows no dot when their status is unknown', (tester) async {
      await mockNetworkImagesFor(() async {
        usePhoneViewport(tester);
        await pumpProfilePage(
          tester,
          ProfilePage(isCreatorProfile: true, creator: creator),
          authState: AuthState.authenticated(me),
          overrides: withFriends(),
        );

        // Statuses are only tracked for friends, so a non-friend gets no dot
        // rather than a wrong one.
        expect(dot(tester), isNull);
      });
    });
  });

  group('achievements', () {
    const decorated = UserStats(
      roomsHosted: 12,
      roomsModerated: 3,
      activeDays: 22,
      badges: ['welcomer', 'echo'],
      displayedBadges: ['welcomer'],
      avatarBadge: 'echo',
    );

    testWidgets('own profile shows the pills and the worn badge', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        usePhoneViewport(tester);
        await pumpProfilePage(
          tester,
          ProfilePage(),
          authState: AuthState.authenticated(me),
          myStats: decorated,
          overrides: withFriends(),
        );

        expect(find.byType(BadgePill), findsOneWidget);
        expect(find.text('Welcomer'), findsOneWidget);
        expect(dot(tester)?.glyph, KnownBadge.echo.icon);
      });
    });

    testWidgets('a user with nothing earned shows no pills', (tester) async {
      await mockNetworkImagesFor(() async {
        usePhoneViewport(tester);
        await pumpProfilePage(
          tester,
          ProfilePage(),
          authState: AuthState.authenticated(me),
          overrides: withFriends(),
        );

        expect(find.byType(BadgePill), findsNothing);
        expect(dot(tester)?.glyph, isNull);
      });
    });

    testWidgets("another user's badges come from their own stats", (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        usePhoneViewport(tester);
        const creatorId = 'creator-1';
        await pumpProfilePage(
          tester,
          ProfilePage(
            isCreatorProfile: true,
            creator: const ResonateUser(
              uid: creatorId,
              name: 'Creator',
              userName: 'creator',
              profileImageUrl: 'https://x/c.jpg',
            ),
          ),
          authState: AuthState.authenticated(me),
          myStats: decorated,
          otherStats: const {
            creatorId: UserStats(
              roomsModerated: 30,
              badges: ['warden'],
              displayedBadges: ['warden'],
            ),
          },
          overrides: withFriends(),
        );

        expect(find.text('Warden'), findsOneWidget);
        // Not the viewer's own badge.
        expect(find.text('Welcomer'), findsNothing);
      });
    });
  });
}
