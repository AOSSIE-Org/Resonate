import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/core/container.dart';
import 'package:resonate/features/auth/auth_routes.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/viewmodel/auth_notifier.dart';
import 'package:resonate/features/friends/friends_routes.dart';
import 'package:resonate/features/profile/profile_routes.dart';
import 'package:resonate/features/rooms/rooms_routes.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/themes/theme_screen.dart';
import 'package:resonate/views/screens/about_app_screen.dart';
import 'package:resonate/views/screens/app_preferences_screen.dart';
import 'package:resonate/views/screens/contribute_screen.dart';
import 'package:resonate/views/screens/create_story_screen.dart';
import 'package:resonate/views/screens/explore_screen.dart';
import 'package:resonate/views/screens/home_screen.dart';
import 'package:resonate/views/screens/live_chapter_screen.dart';
import 'package:resonate/views/screens/notifications_screen.dart';
import 'package:resonate/views/screens/verify_chapter_details_screen.dart';
import 'package:resonate/views/screens/settings_screen.dart';
import 'package:resonate/views/screens/tabview_screen.dart';
import 'package:resonate/views/screens/user_account_screen.dart';

// Global navigator key
final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'rootNav');

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _AuthRouterRefresh(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: refresh,
    redirect: (context, state) => _redirect(ref, state),
    routes: [
      ...authRoutes,
      ...profileRoutes,

      // Main app shell
      GoRoute(
        path: RoutePaths.tabview,
        builder: (_, _) => const TabViewScreen(),
      ),
      GoRoute(
        path: RoutePaths.homeScreen,
        builder: (_, _) => const HomeScreen(),
      ),
      ...roomsRoutes,

      // Account (settings remains GetX-backed)
      GoRoute(
        path: RoutePaths.settings,
        builder: (_, _) => SettingsScreen(),
      ),
      GoRoute(
        path: RoutePaths.themeScreen,
        builder: (_, _) => ThemeScreen(),
      ),
      GoRoute(
        path: RoutePaths.userAccountScreen,
        builder: (_, _) => const UserAccountScreen(),
      ),
      GoRoute(
        path: RoutePaths.notificationsScreen,
        builder: (_, _) => NotificationsScreen(),
      ),
      GoRoute(
        path: RoutePaths.aboutApp,
        builder: (_, _) => AboutAppScreen(),
      ),
      GoRoute(
        path: RoutePaths.contributeScreen,
        builder: (_, _) => const ContributeScreen(),
      ),
      GoRoute(
        path: RoutePaths.appPreferencesScreen,
        builder: (_, _) => const AppPreferencesScreen(),
      ),

      // Pair chat / friend calls
      ...friendsRoutes,

      // Stories
      GoRoute(
        path: RoutePaths.exploreScreen,
        builder: (_, _) => const ExploreScreen(),
      ),
      GoRoute(
        path: RoutePaths.createStoryScreen,
        builder: (_, _) => const CreateStoryPage(),
      ),
      GoRoute(
        path: RoutePaths.liveChapterScreen,
        builder: (_, _) => LiveChapterScreen(),
      ),
      GoRoute(
        path: RoutePaths.verifyChapterDetails,
        builder: (_, state) => VerifyChapterDetailsScreen(
          lyricsString: state.extra as String? ?? '',
        ),
      ),
    ],
  );
});

GoRouter get appRouter => rootContainer.read(routerProvider);

String? _redirect(Ref ref, GoRouterState state) =>
    redirectForAsyncAuth(ref.read(authProvider), state.uri.path);

String? redirectForAsyncAuth(AsyncValue<AuthState> asyncAuth, String path) {
  final auth = asyncAuth.hasError
      ? const AuthState.unauthenticated()
      : asyncAuth.value;
  return authRedirect(auth, path);
}

String? authRedirect(AuthState? auth, String path) {
  if (path == RoutePaths.splash) return null;
  if (auth == null) return null;

  return switch (auth) {
    AuthStateBlocked() =>
      path == RoutePaths.userBlocked ? null : RoutePaths.userBlocked,
    AuthStateNeedsOnboarding() =>
      path == RoutePaths.onboarding ? null : RoutePaths.onboarding,
    AuthStateAuthenticated() =>
      RoutePaths.authOnly.contains(path) ? RoutePaths.tabview : null,
    AuthStateUnauthenticated() =>
      RoutePaths.protected.contains(path) ? RoutePaths.welcome : null,
  };
}

class _AuthRouterRefresh extends ChangeNotifier {
  _AuthRouterRefresh(Ref ref) {
    _sub = ref.listen<AsyncValue<AuthState>>(
      authProvider,
      (_, _) => notifyListeners(),
      fireImmediately: false,
    );
  }

  late final ProviderSubscription _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}
