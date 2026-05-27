import 'package:resonate/features/auth/data/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/auth_notifier.g.dart';

// source of truth for the user's auth status.
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<AuthState> build() {
    return ref.watch(authRepositoryProvider).loadCurrentUser();
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading<AuthState>();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.login(email: email, password: password);
      final next = await repo.loadCurrentUser();
      final user = next.userOrNull;
      if (user != null) {
        await repo.addRegistrationToken(uid: user.uid);
      }
      return next;
    });
  }

  Future<void> signup({required String email, required String password}) async {
    state = const AsyncLoading<AuthState>();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.signup(email: email, password: password);
      return repo.loadCurrentUser();
    });
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncLoading<AuthState>();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.loginWithGoogle();
      return repo.loadCurrentUser();
    });
  }

  Future<void> loginWithGithub() async {
    state = const AsyncLoading<AuthState>();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.loginWithGithub();
      return repo.loadCurrentUser();
    });
  }

  Future<void> logout() async {
    final user = state.value?.userOrNull;
    state = const AsyncLoading<AuthState>();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      if (user != null) {
        await repo.removeRegistrationToken(uid: user.uid);
      }
      await repo.logout();
      return const AuthState.unauthenticated();
    });
  }

  Future<void> refresh() async {
    state = const AsyncLoading<AuthState>();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).loadCurrentUser(),
    );
  }
}
