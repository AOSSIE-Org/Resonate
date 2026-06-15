import 'dart:developer' as developer;

import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/model/auth_user.dart';
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
      await _tryRegisterToken(next.userOrNull);
      return next;
    });
  }

  Future<void> signup({required String email, required String password}) async {
    state = const AsyncLoading<AuthState>();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.signup(email: email, password: password);
      final next = await repo.loadCurrentUser();
      await _tryRegisterToken(next.userOrNull);
      return next;
    });
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncLoading<AuthState>();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.loginWithGoogle();
      final next = await repo.loadCurrentUser();
      await _tryRegisterToken(next.userOrNull);
      return next;
    });
  }

  Future<void> loginWithGithub() async {
    state = const AsyncLoading<AuthState>();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.loginWithGithub();
      final next = await repo.loadCurrentUser();
      await _tryRegisterToken(next.userOrNull);
      return next;
    });
  }

  Future<void> logout() async {
    final user = state.value?.userOrNull;
    state = const AsyncLoading<AuthState>();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      if (user != null) {
        try {
          await repo.removeRegistrationToken(uid: user.uid);
        } catch (e, st) {
          developer.log(
            'removeRegistrationToken failed during logout (non-fatal)',
            error: e,
            stackTrace: st,
          );
        }
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

  Future<void> _tryRegisterToken(AuthUser? user) async {
    if (user == null) return;
    try {
      await ref.read(authRepositoryProvider).addRegistrationToken(uid: user.uid);
    } catch (e, st) {
      developer.log(
        'addRegistrationToken failed after login (non-fatal)',
        error: e,
        stackTrace: st,
      );
    }
  }
}
