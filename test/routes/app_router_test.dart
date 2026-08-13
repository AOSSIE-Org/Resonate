import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/model/auth_user.dart';
import 'package:resonate/features/settings/model/app_feature.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/routes/route_paths.dart';

AuthUser _user() => AuthUser(
      uid: 'u1',
      email: 'u@e.com',
      displayName: 'U',
      isEmailVerified: true,
      isProfileComplete: true,
    );

void main() {
  group('authRedirect — splash is always permitted', () {
    test('splash returns null regardless of auth state', () {
      for (final state in <AuthState>[
        const AuthState.unauthenticated(),
        AuthState.needsOnboarding(_user()),
        AuthState.blocked(_user()),
        AuthState.authenticated(_user()),
      ]) {
        expect(authRedirect(state, RoutePaths.splash), isNull);
      }
    });
  });

  group('authRedirect — auth still loading', () {
    test('returns null for any path', () {
      expect(authRedirect(null, RoutePaths.tabview), isNull);
      expect(authRedirect(null, RoutePaths.login), isNull);
    });
  });

  group('authRedirect — blocked user', () {
    test('all routes redirect to userBlocked', () {
      final s = AuthState.blocked(_user());
      expect(authRedirect(s, RoutePaths.tabview), RoutePaths.userBlocked);
      expect(authRedirect(s, RoutePaths.profile), RoutePaths.userBlocked);
      expect(authRedirect(s, RoutePaths.welcome), RoutePaths.userBlocked);
    });

    test('userBlocked itself returns null (no further redirect)', () {
      final s = AuthState.blocked(_user());
      expect(authRedirect(s, RoutePaths.userBlocked), isNull);
    });
  });

  group('authRedirect — needs onboarding', () {
    test('all routes redirect to onboarding', () {
      final s = AuthState.needsOnboarding(_user());
      expect(authRedirect(s, RoutePaths.tabview), RoutePaths.onboarding);
      expect(authRedirect(s, RoutePaths.welcome), RoutePaths.onboarding);
      expect(authRedirect(s, RoutePaths.login), RoutePaths.onboarding);
    });

    test('onboarding itself returns null', () {
      final s = AuthState.needsOnboarding(_user());
      expect(authRedirect(s, RoutePaths.onboarding), isNull);
    });
  });

  group('authRedirect — authenticated', () {
    test('auth-only routes bounce to tabview', () {
      final s = AuthState.authenticated(_user());
      expect(authRedirect(s, RoutePaths.login), RoutePaths.tabview);
      expect(authRedirect(s, RoutePaths.signup), RoutePaths.tabview);
      expect(authRedirect(s, RoutePaths.welcome), RoutePaths.tabview);
      expect(authRedirect(s, RoutePaths.landing), RoutePaths.tabview);
      expect(
        authRedirect(s, RoutePaths.forgotPassword),
        RoutePaths.tabview,
      );
    });

    test('protected routes are allowed', () {
      final s = AuthState.authenticated(_user());
      expect(authRedirect(s, RoutePaths.tabview), isNull);
      expect(authRedirect(s, RoutePaths.profile), isNull);
      expect(authRedirect(s, RoutePaths.settings), isNull);
    });
  });

  group('authRedirect — unauthenticated', () {
    test('protected routes bounce to welcome', () {
      const s = AuthState.unauthenticated();
      expect(authRedirect(s, RoutePaths.tabview), RoutePaths.welcome);
      expect(authRedirect(s, RoutePaths.profile), RoutePaths.welcome);
      expect(authRedirect(s, RoutePaths.editProfile), RoutePaths.welcome);
    });

    test('public auth routes are allowed', () {
      const s = AuthState.unauthenticated();
      expect(authRedirect(s, RoutePaths.login), isNull);
      expect(authRedirect(s, RoutePaths.signup), isNull);
      expect(authRedirect(s, RoutePaths.welcome), isNull);
      expect(authRedirect(s, RoutePaths.landing), isNull);
    });
  });

  group('authRedirect — emailVerification is protected', () {
    test('unauthenticated visitors bounce to welcome', () {
      const s = AuthState.unauthenticated();
      expect(
        authRedirect(s, RoutePaths.emailVerification),
        RoutePaths.welcome,
      );
    });

    test('authenticated users can access (no-op for already-verified)', () {
      final s = AuthState.authenticated(_user());
      expect(authRedirect(s, RoutePaths.emailVerification), isNull);
    });
  });

  group('redirectForAsyncAuth — AsyncError handling', () {
    test('error on a protected route falls back to unauthenticated → welcome',
        () {
      final asyncErr = AsyncValue<AuthState>.error(
        Exception('network down'),
        StackTrace.empty,
      );
      expect(
        redirectForAsyncAuth(asyncErr, RoutePaths.tabview),
        RoutePaths.welcome,
      );
    });

    test('error on a public route is a no-op (already unauthenticated)', () {
      final asyncErr = AsyncValue<AuthState>.error(
        Exception('boom'),
        StackTrace.empty,
      );
      expect(redirectForAsyncAuth(asyncErr, RoutePaths.login), isNull);
      expect(redirectForAsyncAuth(asyncErr, RoutePaths.welcome), isNull);
    });

    test('loading (no error, no value) does not redirect', () {
      const asyncLoading = AsyncValue<AuthState>.loading();
      expect(
        redirectForAsyncAuth(asyncLoading, RoutePaths.tabview),
        isNull,
      );
    });

    test('data branch delegates to authRedirect', () {
      final asyncOk = AsyncValue<AuthState>.data(
        AuthState.authenticated(_user()),
      );
      expect(
        redirectForAsyncAuth(asyncOk, RoutePaths.login),
        RoutePaths.tabview,
      );
      expect(redirectForAsyncAuth(asyncOk, RoutePaths.tabview), isNull);
    });
  });

  group('disabledFeatureRedirect', () {
    test('lets every route through while all features are on', () {
      final all = AppFeature.values.toSet();
      for (final path in RoutePaths.protected) {
        expect(disabledFeatureRedirect(all, path), isNull, reason: path);
      }
    });

    test('sends every route of a disabled feature to tabview', () {
      const enabled = <AppFeature>{};
      for (final path in AppFeature.pairChat.routes) {
        expect(disabledFeatureRedirect(enabled, path), RoutePaths.tabview);
      }
    });

    test('leaves routes of other features alone', () {
      const enabled = <AppFeature>{};
      expect(disabledFeatureRedirect(enabled, RoutePaths.tabview), isNull);
      expect(disabledFeatureRedirect(enabled, RoutePaths.settings), isNull);
      expect(
        disabledFeatureRedirect(enabled, RoutePaths.friendCallScreen),
        isNull,
      );
    });
  });
}
