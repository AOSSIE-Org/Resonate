// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../current_user.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(currentUser)
final currentUserProvider = CurrentUserProvider._();

final class CurrentUserProvider
    extends $FunctionalProvider<AuthUser?, AuthUser?, AuthUser?>
    with $Provider<AuthUser?> {
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $ProviderElement<AuthUser?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthUser? create(Ref ref) {
    return currentUser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthUser? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthUser?>(value),
    );
  }
}

String _$currentUserHash() => r'c6c9da8f2296ec9bc3a477f5fcc553a052c2504a';

@ProviderFor(requireUser)
final requireUserProvider = RequireUserProvider._();

final class RequireUserProvider
    extends $FunctionalProvider<AuthUser, AuthUser, AuthUser>
    with $Provider<AuthUser> {
  RequireUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requireUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requireUserHash();

  @$internal
  @override
  $ProviderElement<AuthUser> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthUser create(Ref ref) {
    return requireUser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthUser value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthUser>(value),
    );
  }
}

String _$requireUserHash() => r'36b285d25df5eb5621c6fa520541f66db00b6ace';
