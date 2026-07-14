import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/features/auth/auth_routes.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/friends/friends_routes.dart';
import 'package:resonate/features/profile/profile_routes.dart';
import 'package:resonate/features/rooms/rooms_routes.dart';
import 'package:resonate/features/settings/settings_routes.dart';
import 'package:resonate/features/shell/shell_routes.dart';
import 'package:resonate/features/stories/stories_routes.dart';
import 'package:resonate/features/theme/theme_routes.dart';
import 'package:resonate/routes/route_paths.dart';

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

      // Main app shell (tabview, home, notifications)
      ...shellRoutes,
      ...roomsRoutes,

      // Account / settings (settings, account, about, contribute, preferences)
      ...settingsRoutes,
      ...themeRoutes,

      // Pair chat / friend calls
      ...friendsRoutes,

      // Stories / live chapters
      ...storiesRoutes,
    ],
  );
});

String? _redirect(Ref ref, GoRouterState state) =>
    redirectForAsyncAuth(ref.read(authSessionProvider), state.uri.path);

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
      authSessionProvider,
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
