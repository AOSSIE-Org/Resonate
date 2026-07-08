import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/features/auth/viewmodel/current_user.dart';
import 'package:resonate/features/friends/model/pair_chat_state.dart';
import 'package:resonate/features/friends/view/pages/pair_chat_users_page.dart';
import 'package:resonate/features/friends/viewmodel/pair_chat_notifier.dart';
import 'package:resonate/features/rooms/viewmodel/livekit_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../friends_test_helpers.dart';

List<Override> baseOverrides(FakePairChatNotifier fake) => [
  currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
  requireUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
  liveKitProvider.overrideWith(FakeLiveKitNotifier.new),
  pairChatProvider.overrideWith(() => fake),
];

void main() {
  group('PairChatUsersPage', () {
    testFriendsWidget('shows a loader while the user list is loading', (
      tester,
    ) async {
      final fake = FakePairChatNotifier(
        const PairChatState(isUserListLoading: true),
      );
      await pumpFriendsPage(
        tester,
        const PairChatUsersPage(),
        overrides: baseOverrides(fake),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testFriendsWidget('shows the empty state when no users are online', (
      tester,
    ) async {
      final fake = FakePairChatNotifier(
        const PairChatState(isUserListLoading: false, onlineUsers: []),
      );
      await pumpFriendsPage(
        tester,
        const PairChatUsersPage(),
        overrides: baseOverrides(fake),
      );
      await tester.pumpAndSettle();

      expect(find.text('No users currently online'), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
    });

    testFriendsWidget('renders a ListTile per online user', (tester) async {
      final fake = FakePairChatNotifier(
        PairChatState(
          isUserListLoading: false,
          onlineUsers: [
            fakeResonateUser(
              uid: 'u1',
              userName: 'alice',
              name: 'Alice A',
              userRating: 4.5,
            ),
            fakeResonateUser(
              uid: 'u2',
              userName: 'bob',
              name: 'Bob B',
              userRating: 3.0,
            ),
          ],
        ),
      );
      await pumpFriendsPage(
        tester,
        const PairChatUsersPage(),
        overrides: baseOverrides(fake),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsNWidgets(2));
      // username -> title, name -> subtitle, rating -> trailing.
      expect(find.text('alice'), findsOneWidget);
      expect(find.text('Alice A'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
      expect(find.text('bob'), findsOneWidget);
      expect(find.text('Bob B'), findsOneWidget);
      expect(find.text('3.0'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsNWidgets(2));
    });

    testFriendsWidget('tapping a user calls pairWithSelectedUser', (
      tester,
    ) async {
      final user = fakeResonateUser(uid: 'u1', userName: 'alice');
      final fake = FakePairChatNotifier(
        PairChatState(isUserListLoading: false, onlineUsers: [user]),
      );
      await pumpFriendsPage(
        tester,
        const PairChatUsersPage(),
        overrides: baseOverrides(fake),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();

      expect(fake.pairedWith, hasLength(1));
      expect(fake.pairedWith.single.uid, 'u1');
    });

    testFriendsWidget('initState calls loadUsers', (tester) async {
      final fake = FakePairChatNotifier(
        const PairChatState(isUserListLoading: true),
      );
      await pumpFriendsPage(
        tester,
        const PairChatUsersPage(),
        overrides: baseOverrides(fake),
      );
      await tester.pump();

      expect(fake.loadUsersCount, 1);
    });

    testFriendsWidget('dispose calls cancelRequest', (tester) async {
      final fake = FakePairChatNotifier(
        const PairChatState(isUserListLoading: true),
      );
      await pumpFriendsPage(
        tester,
        const PairChatUsersPage(),
        overrides: baseOverrides(fake),
      );
      await tester.pump();
      expect(fake.cancelRequestCount, 0);

      // Replace the page so its State is disposed.
      await tester.pumpWidget(const SizedBox());
      expect(fake.cancelRequestCount, 1);
    });

    testFriendsWidget(
      'casino action calls convertToRandom then routes to pairing',
      (tester) async {
        final fake = FakePairChatNotifier(
          const PairChatState(isUserListLoading: false, onlineUsers: []),
        );
        final router = GoRouter(
          initialLocation: RoutePaths.pairChatUsers,
          routes: [
            GoRoute(
              path: RoutePaths.pairChatUsers,
              builder: (_, _) => const PairChatUsersPage(),
            ),
            GoRoute(
              path: RoutePaths.pairing,
              builder: (_, _) =>
                  const Scaffold(body: Text('pairing-destination')),
            ),
          ],
        );
        addTearDown(router.dispose);

        tester.view.physicalSize = const Size(1080, 2340);
        tester.view.devicePixelRatio = 3.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          ProviderScope(
            overrides: baseOverrides(fake),
            child: MaterialApp.router(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en')],
              routerConfig: router,
              builder: (context, child) {
                UiSizes.init(context);
                return child!;
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.casino_outlined));
        await tester.pumpAndSettle();

        expect(fake.convertToRandomCount, 1);
        expect(find.text('pairing-destination'), findsOneWidget);
      },
    );
  });
}
