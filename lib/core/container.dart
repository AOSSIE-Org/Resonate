import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/model/auth_user.dart';
import 'package:resonate/features/auth/viewmodel/auth_notifier.dart';

// Single root ProviderContainer for the app.
ProviderContainer _rootContainer = ProviderContainer();
ProviderContainer get rootContainer => _rootContainer;

@visibleForTesting
void setRootContainerForTesting(ProviderContainer container) {
  _rootContainer = container;
}

// Auth bridge accessors

AuthUser? get currentAuthUser =>
    rootContainer.read(authProvider).value?.userOrNull;

AuthUser get requireCurrentAuthUser =>
    currentAuthUser ??
    (throw StateError(
      'requireCurrentAuthUser called with no authenticated user',
    ));

ProviderSubscription<AsyncValue<AuthState>> listenAuthState(
  void Function(AsyncValue<AuthState>? previous, AsyncValue<AuthState> next)
      onChange,
) {
  return rootContainer.listen<AsyncValue<AuthState>>(
    authProvider,
    onChange,
    fireImmediately: true,
  );
}
