import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/friends/model/pair_chat_state.dart';
import 'package:resonate/features/friends/view/pages/pairing_page.dart';
import 'package:resonate/features/friends/data/services/pair_chat_session.dart';
import 'package:resonate/features/theme/viewmodel/theme_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../friends_test_helpers.dart';

const _placeholderUrl = 'https://example.com/placeholder.jpg';

// Builds the current-user, placeholder and pair-chat overrides.
List<Override> _overrides(
  FakePairChat fake, {
  String? profileImageUrl = 'https://example.com/me.jpg',
}) {
  final me = fakeAuthUser(uid: 'me', profileImageUrl: profileImageUrl);
  return [
    requireUserProvider.overrideWithValue(me),
    currentUserProvider.overrideWithValue(me),
    userProfileImagePlaceholderUrlProvider.overrideWithValue(_placeholderUrl),
    pairChatProvider.overrideWith(() => fake),
  ];
}

Future<void> pumpRouterApp(
  WidgetTester tester,
  List<Override> overrides,
) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final router = GoRouter(
    initialLocation: RoutePaths.pairing,
    routes: [
      GoRoute(
        path: RoutePaths.pairing,
        builder: (context, state) {
          UiSizes.init(context);
          return const PairingPage();
        },
      ),
      GoRoute(
        path: RoutePaths.tabview,
        builder: (context, state) => const Text('TABVIEW'),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
      ),
    ),
  );
}

void main() {
  group('PairingPage render', () {
    testFriendsWidget('authenticated uses the user profile image', (
      tester,
    ) async {
      final fake = FakePairChat(const PairChatState(isAnonymous: false));
      await pumpFriendsPage(
        tester,
        const PairingPage(),
        overrides: _overrides(fake, profileImageUrl: 'https://example.com/me.jpg'),
      );
      await tester.pump();

      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      final image = avatar.backgroundImage as NetworkImage;
      expect(image.url, 'https://example.com/me.jpg');
    });

    testFriendsWidget('anonymous uses the placeholder image', (tester) async {
      final fake = FakePairChat(const PairChatState(isAnonymous: true));
      await pumpFriendsPage(
        tester,
        const PairingPage(),
        overrides: _overrides(fake),
      );
      await tester.pump();

      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      final image = avatar.backgroundImage as NetworkImage;
      expect(image.url, _placeholderUrl);
    });
  });

  group('PairingPage cancel', () {
    testFriendsWidget('Cancel calls cancelRequest then routes to tabview', (
      tester,
    ) async {
      final fake = FakePairChat(const PairChatState(isAnonymous: false));
      await pumpRouterApp(tester, _overrides(fake));
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Cancel'));
      await tester.pump(); // run the async onPressed + settle nav
      await tester.pump(const Duration(milliseconds: 50));

      expect(fake.cancelRequestCount, 1);
      expect(find.text('TABVIEW'), findsOneWidget);
    });
  });
}
