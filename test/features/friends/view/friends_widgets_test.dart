import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/features/achievements/model/user_stats.dart';
import 'package:resonate/features/achievements/view/widgets/badge_mark.dart';
import 'package:resonate/features/friends/view/widgets/call_participant_tile.dart';
import 'package:resonate/features/friends/view/widgets/friends_empty_view.dart';
import 'package:resonate/features/shell/viewmodel/tabview_notifier.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/features/theme/viewmodel/theme_notifier.dart';

import '../friends_test_helpers.dart';

GoRouter recordingRouter(List<String> log) => GoRouter(
  initialLocation: RoutePaths.tabview,
  routes: [
    GoRoute(
      path: RoutePaths.tabview,
      builder: (context, state) {
        log.add(state.uri.path);
        return const SizedBox.shrink();
      },
    ),
  ],
);

void main() {
  group('FriendsEmptyView', () {
    testFriendsWidget('shows friends-empty copy when not requests screen', (
      tester,
    ) async {
      await pumpFriendsPage(
        tester,
        const FriendsEmptyView(isRequestsScreen: false),
        overrides: [tabViewProvider.overrideWith(FakeTabView.new)],
      );
      await tester.pumpAndSettle();

      expect(find.text('No Friends Yet'), findsOneWidget);
      expect(find.text('No Friend Requests'), findsNothing);
      expect(find.byIcon(Icons.people_outline_rounded), findsOneWidget);
    });

    testFriendsWidget('shows requests-empty copy when requests screen', (
      tester,
    ) async {
      await pumpFriendsPage(
        tester,
        const FriendsEmptyView(isRequestsScreen: true),
        overrides: [tabViewProvider.overrideWith(FakeTabView.new)],
      );
      await tester.pumpAndSettle();

      expect(find.text('No Friend Requests'), findsOneWidget);
      expect(find.text('No Friends Yet'), findsNothing);
      expect(find.byIcon(Icons.person_add_outlined), findsWidgets);
    });

    testFriendsWidget('Find Friends button sets tab index to 1', (
      tester,
    ) async {
      final fake = FakeTabView();
      await pumpFriendsPage(
        tester,
        const FriendsEmptyView(isRequestsScreen: false),
        overrides: [
          tabViewProvider.overrideWith(() => fake),
          routerProvider.overrideWithValue(recordingRouter(<String>[])),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text('Find Friends'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(fake.setIndexCalls, [1]);
    });

    testFriendsWidget('Invite button exists and tapping does not throw', (
      tester,
    ) async {
      await pumpFriendsPage(
        tester,
        const FriendsEmptyView(isRequestsScreen: false),
        overrides: [tabViewProvider.overrideWith(FakeTabView.new)],
      );
      await tester.pumpAndSettle();

      expect(find.text('Invite a Friend'), findsOneWidget);
      // Invite is the only person_add_outlined icon on the friends-empty view.
      final invite = find.byIcon(Icons.person_add_outlined);
      expect(invite, findsOneWidget);
      // SharePlus is a native side-effect; just ensure the tap doesn't throw.
      await tester.tap(invite);
      await tester.pump();
    });
  });

  group('CallParticipantTile', () {
    const placeholder = 'https://example.com/placeholder.png';

    Future<void> pumpTile(WidgetTester tester, CallParticipantTile tile) =>
        pumpFriendsPage(
          tester,
          SizedBox(width: 200, child: tile),
          overrides: [
            userProfileImagePlaceholderUrlProvider.overrideWithValue(
              placeholder,
            ),
          ],
          otherStats: const {'u-1': UserStats.empty},
        );

    testFriendsWidget('the stage tile shows the name and a badge slot', (
      tester,
    ) async {
      await pumpTile(
        tester,
        const CallParticipantTile(
          uid: 'u-1',
          name: 'Alice',
          imageUrl: 'https://example.com/a.jpg',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Alice'), findsOneWidget);
      expect(find.byType(BadgeMark), findsOneWidget);
    });

    testFriendsWidget('the compact tile drops the badge', (tester) async {
      await pumpTile(
        tester,
        const CallParticipantTile(
          uid: 'u-1',
          name: 'You',
          imageUrl: 'https://example.com/a.jpg',
          compact: true,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('You'), findsOneWidget);
      expect(find.byType(BadgeMark), findsNothing);
    });

    testFriendsWidget('an empty image url falls back to the placeholder', (
      tester,
    ) async {
      await pumpTile(
        tester,
        const CallParticipantTile(uid: 'u-1', name: 'Alice', imageUrl: ''),
      );
      await tester.pumpAndSettle();

      final avatars = tester
          .widgetList<CircleAvatar>(find.byType(CircleAvatar))
          .where((a) => a.foregroundImage != null);
      expect(
        avatars.every(
          (a) => (a.foregroundImage! as NetworkImage).url == placeholder,
        ),
        isTrue,
      );
    });
  });
}
