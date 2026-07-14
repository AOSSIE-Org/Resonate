import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/profile/data/repositories/profile_repository.dart';
import 'package:resonate/features/profile/model/change_email_state.dart';
import 'package:resonate/features/profile/viewmodel/change_email_notifier.dart';

import '../../../helpers/test_root_container.dart';
import '../fake_profile_repository.dart';

void main() {
  late FakeProfileRepository repo;
  late FakeAuthRepository auth;
  late ProviderContainer container;

  setUp(() async {
    repo = FakeProfileRepository();
    auth = FakeAuthRepository(
      AuthState.authenticated(
        fakeAuthUser(uid: 'u1', userName: 'TestUser', email: 'old@test.com'),
      ),
    );
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        profileRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authSessionProvider.future);
  });

  ChangeEmail notifier() => container.read(changeEmailProvider.notifier);

  test('togglePasswordVisible flips the flag', () {
    expect(container.read(changeEmailProvider).passwordVisible, false);
    notifier().togglePasswordVisible();
    expect(container.read(changeEmailProvider).passwordVisible, true);
  });

  test('returns emailExists and never touches auth when email is taken',
      () async {
    repo.emailAvailableReturn = false;
    final status = await notifier().changeEmail(
      email: 'new@test.com',
      password: 'pw',
    );
    expect(status, ChangeEmailStatus.emailExists);
    expect(repo.changeEmailInAuthArgs, isNull);
  });

  test('maps invalid-credentials failure', () async {
    repo.changeEmailInAuthError = ChangeEmailFailure.invalidCredentials;
    final status = await notifier().changeEmail(
      email: 'new@test.com',
      password: 'wrong',
    );
    expect(status, ChangeEmailStatus.invalidCredentials);
  });

  test('maps password-too-short failure', () async {
    repo.changeEmailInAuthError = ChangeEmailFailure.passwordTooShort;
    final status = await notifier().changeEmail(
      email: 'new@test.com',
      password: 'x',
    );
    expect(status, ChangeEmailStatus.passwordTooShort);
  });

  test('happy path updates databases, refreshes auth, returns success',
      () async {
    final before = auth.loadCount;
    final status = await notifier().changeEmail(
      email: 'new@test.com',
      password: 'pw',
    );
    expect(status, ChangeEmailStatus.success);
    expect(repo.changeEmailInAuthArgs?.email, 'new@test.com');
    expect(repo.changeEmailInDatabasesArgs?.uid, 'u1');
    expect(repo.changeEmailInDatabasesArgs?.username, 'TestUser');
    expect(repo.changeEmailInDatabasesArgs?.email, 'new@test.com');
    expect(auth.loadCount, before + 1);
    expect(container.read(changeEmailProvider).isLoading, false);
  });

  test('returns failed when the database update throws', () async {
    repo.changeEmailInDatabasesError = Exception('boom');
    final status = await notifier().changeEmail(
      email: 'new@test.com',
      password: 'pw',
    );
    expect(status, ChangeEmailStatus.failed);
    expect(container.read(changeEmailProvider).isLoading, false);
  });
}
