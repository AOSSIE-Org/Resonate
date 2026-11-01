import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/profile/viewmodel/delete_account_notifier.dart';

import '../../../helpers/test_root_container.dart';

class _DeletingRepo extends FakeAuthRepository {
  _DeletingRepo({this.throws = false}) : super(const AuthState.unauthenticated());

  final bool throws;
  int deleteCount = 0;

  @override
  Future<void> deleteAccount() async {
    deleteCount++;
    if (throws) throw Exception('server said no');
  }
}

ProviderContainer _container(_DeletingRepo repo) {
  final container = ProviderContainer(
    overrides: [authRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('does nothing until the username has been confirmed', () async {
    final repo = _DeletingRepo();
    final container = _container(repo);
    final notifier = container.read(deleteAccountProvider.notifier);

    expect(await notifier.deleteAccount(), isFalse);
    expect(repo.deleteCount, 0);
  });

  test('deletes once confirmed and reports success', () async {
    final repo = _DeletingRepo();
    final container = _container(repo);
    final notifier = container.read(deleteAccountProvider.notifier);

    notifier.setButtonActive(true);
    expect(container.read(deleteAccountProvider).canDelete, isTrue);

    expect(await notifier.deleteAccount(), isTrue);
    expect(repo.deleteCount, 1);
  });

  test('a second tap while deleting does not delete twice', () async {
    final repo = _DeletingRepo();
    final container = _container(repo);
    final notifier = container.read(deleteAccountProvider.notifier);
    notifier.setButtonActive(true);

    await Future.wait<bool>([
      notifier.deleteAccount(),
      notifier.deleteAccount(),
    ]);

    expect(repo.deleteCount, 1);
  });

  test('a failure reports false and leaves the button armed', () async {
    final repo = _DeletingRepo(throws: true);
    final container = _container(repo);
    final notifier = container.read(deleteAccountProvider.notifier);
    notifier.setButtonActive(true);

    expect(await notifier.deleteAccount(), isFalse);
    expect(repo.deleteCount, 1);
    // Armed again, so the user can retry without retyping their username.
    final state = container.read(deleteAccountProvider);
    expect(state.isDeleting, isFalse);
    expect(state.canDelete, isTrue);
  });
}
