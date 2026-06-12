import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/viewmodel/forgot_password_notifier.dart';

class _FakeRepo extends FakeAuthRepositoryBase {
  bool fail = false;
  int sendCount = 0;
  String? lastEmail;
  String? lastRedirect;

  @override
  Future<void> sendPasswordRecovery({
    required String email,
    required String redirectUrl,
  }) async {
    sendCount++;
    lastEmail = email;
    lastRedirect = redirectUrl;
    if (fail) throw Exception('boom');
  }
}

// Minimal base so the fake doesn't have to implement every method.
class FakeAuthRepositoryBase implements AuthRepository {
  @override
  Future<AuthState> loadCurrentUser() async =>
      const AuthState.unauthenticated();

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} not stubbed');
}

void main() {
  group('ForgotPassword', () {
    test('initial state is AsyncData(false)', () {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(_FakeRepo()),
        ],
      );
      addTearDown(container.dispose);
      final state = container.read(forgotPasswordProvider);
      expect(state, isA<AsyncData<bool>>());
      expect(state.value, false);
    });

    test('sendRecoveryEmail success → state becomes AsyncData(true)',
        () async {
      final repo = _FakeRepo();
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      final ok = await container
          .read(forgotPasswordProvider.notifier)
          .sendRecoveryEmail(
            email: 'x@y.z',
            redirectUrl: 'https://app/reset',
          );

      expect(ok, true);
      expect(repo.sendCount, 1);
      expect(repo.lastEmail, 'x@y.z');
      expect(repo.lastRedirect, 'https://app/reset');
      expect(container.read(forgotPasswordProvider).value, true);
    });

    test('sendRecoveryEmail error → state becomes AsyncError', () async {
      final repo = _FakeRepo()..fail = true;
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      final ok = await container
          .read(forgotPasswordProvider.notifier)
          .sendRecoveryEmail(email: 'x@y.z', redirectUrl: 'u');

      expect(ok, false);
      expect(container.read(forgotPasswordProvider).hasError, true);
    });
  });
}
