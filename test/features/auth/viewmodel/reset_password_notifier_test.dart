import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/viewmodel/reset_password_notifier.dart';

class _FakeRepo implements AuthRepository {
  bool fail = false;
  int completeCount = 0;
  String? lastUserId;
  String? lastSecret;
  String? lastNewPassword;

  @override
  Future<AuthState> loadCurrentUser() async =>
      const AuthState.unauthenticated();

  @override
  Future<void> completePasswordRecovery({
    required String userId,
    required String secret,
    required String newPassword,
  }) async {
    completeCount++;
    lastUserId = userId;
    lastSecret = secret;
    lastNewPassword = newPassword;
    if (fail) throw Exception('boom');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} not stubbed');
}

void main() {
  group('ResetPassword', () {
    test('initial state is AsyncData(false)', () {
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(_FakeRepo())],
      );
      addTearDown(container.dispose);
      expect(container.read(resetPasswordProvider).value, false);
    });

    test('resetPassword success → state becomes AsyncData(true)', () async {
      final repo = _FakeRepo();
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      final ok = await container
          .read(resetPasswordProvider.notifier)
          .resetPassword(
            userId: 'u1',
            secret: 's1',
            newPassword: 'NewPass1!',
          );

      expect(ok, true);
      expect(repo.completeCount, 1);
      expect(repo.lastUserId, 'u1');
      expect(repo.lastSecret, 's1');
      expect(repo.lastNewPassword, 'NewPass1!');
      expect(container.read(resetPasswordProvider).value, true);
    });

    test('resetPassword error → state becomes AsyncError', () async {
      final repo = _FakeRepo()..fail = true;
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      final ok = await container
          .read(resetPasswordProvider.notifier)
          .resetPassword(userId: 'u', secret: 's', newPassword: 'p');

      expect(ok, false);
      expect(container.read(resetPasswordProvider).hasError, true);
    });
  });
}
