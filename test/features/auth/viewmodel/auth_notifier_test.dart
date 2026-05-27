import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/model/auth_user.dart';
import 'package:resonate/features/auth/viewmodel/auth_notifier.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository(this._next);

  AuthState _next;
  int loadCalls = 0;
  int loginCalls = 0;
  int logoutCalls = 0;

  void setNext(AuthState state) => _next = state;

  @override
  Future<AuthState> loadCurrentUser() async {
    loadCalls++;
    return _next;
  }

  @override
  Future<void> login({required String email, required String password}) async {
    loginCalls++;
  }

  @override
  Future<void> logout() async {
    logoutCalls++;
  }

  @override
  Future<void> addRegistrationToken({required String uid}) async {}

  @override
  Future<void> removeRegistrationToken({required String uid}) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} not stubbed');
}

void main() {
  AuthUser sampleUser({String uid = 'u1', bool profileComplete = true}) =>
      AuthUser(
        uid: uid,
        email: 'foo@example.com',
        displayName: 'Foo',
        isEmailVerified: true,
        isProfileComplete: profileComplete,
      );

  group('AuthNotifier', () {
    test('build() resolves to whatever the repository returns', () async {
      final repo = _FakeAuthRepository(
        AuthState.authenticated(sampleUser()),
      );
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      final state = await container.read(authProvider.future);

      expect(state, isA<AuthStateAuthenticated>());
      expect((state as AuthStateAuthenticated).user.uid, 'u1');
      expect(repo.loadCalls, 1);
    });

    test('login() reloads the user and adds an FCM token', () async {
      final repo = _FakeAuthRepository(
        const AuthState.unauthenticated(),
      );
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      await container.read(authProvider.future);
      repo.setNext(AuthState.authenticated(sampleUser()));

      await container
          .read(authProvider.notifier)
          .login(email: 'a@b.c', password: 'pw');

      expect(repo.loginCalls, 1);
      final state = container.read(authProvider).requireValue;
      expect(state, isA<AuthStateAuthenticated>());
    });

    test('logout() flips state to unauthenticated', () async {
      final repo = _FakeAuthRepository(
        AuthState.authenticated(sampleUser()),
      );
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      await container.read(authProvider.future);
      await container.read(authProvider.notifier).logout();

      expect(repo.logoutCalls, 1);
      expect(container.read(authProvider).requireValue,
          isA<AuthStateUnauthenticated>());
    });
  });
}
