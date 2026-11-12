import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:resonate/features/activity_status/view/widgets/activity_dot.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/shell/view/widgets/profile_avatar.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/enums/activity_status.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../../helpers/test_root_container.dart';

void main() {
  late GoRouter router;

  setUp(() {
    router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) =>
              Scaffold(appBar: AppBar(actions: [profileAvatar(context)])),
        ),
        GoRoute(
          path: RoutePaths.profile,
          builder: (_, _) => const Scaffold(body: Text('profile page')),
        ),
      ],
    );
  });

  tearDown(() => router.dispose());

  Future<void> pumpAvatar(
    WidgetTester tester, {
    String? profileImageUrl = 'https://example.com/me.jpg',
    ActivityStatus status = ActivityStatus.online,
  }) async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          FakeAuthRepository(
            AuthState.authenticated(
              fakeAuthUser(uid: 'me', profileImageUrl: profileImageUrl),
            ),
          ),
        ),
        ...activityStatusOverrides(myStatus: status),
        ...achievementOverrides(),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authSessionProvider.future);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          builder: (context, child) {
            UiSizes.init(context);
            return child!;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders the signed-in user as a labelled avatar', (
    tester,
  ) async {
    await mockNetworkImagesFor(() => pumpAvatar(tester));

    final labels = tester
        .widgetList<Semantics>(find.byType(Semantics))
        .map((s) => s.properties.label);
    expect(labels, contains('User profile'));
    expect(find.byType(CircleAvatar), findsOneWidget);
  });

  testWidgets('uses the user picture when there is one', (tester) async {
    await mockNetworkImagesFor(
      () => pumpAvatar(tester, profileImageUrl: 'https://example.com/me.jpg'),
    );

    final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
    expect(
      (avatar.backgroundImage! as NetworkImage).url,
      'https://example.com/me.jpg',
    );
  });

  // A user who never set one still needs something round to tap.
  testWidgets('falls back to the placeholder with no picture', (tester) async {
    await mockNetworkImagesFor(() => pumpAvatar(tester, profileImageUrl: null));

    final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
    expect(avatar.backgroundImage, isA<NetworkImage>());
    expect(
      (avatar.backgroundImage! as NetworkImage).url,
      isNot('https://example.com/me.jpg'),
    );
  });

  testWidgets('an empty picture url also falls back', (tester) async {
    await mockNetworkImagesFor(() => pumpAvatar(tester, profileImageUrl: ''));

    final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
    expect((avatar.backgroundImage! as NetworkImage).url, isNotEmpty);
  });

  testWidgets('carries the activity dot', (tester) async {
    await mockNetworkImagesFor(
      () => pumpAvatar(tester, status: ActivityStatus.dnd),
    );

    expect(
      tester.widget<ActivityDot>(find.byType(ActivityDot)).status,
      ActivityStatus.dnd,
    );
  });

  testWidgets('tapping it opens the profile', (tester) async {
    await mockNetworkImagesFor(() async {
      await pumpAvatar(tester);

      await tester.tap(find.byType(CircleAvatar));
      await tester.pumpAndSettle();
    });

    // push, not go: assert on what is rendered rather than the reported
    // location, which push does not rewrite.
    expect(find.text('profile page'), findsOneWidget);
  });
}
