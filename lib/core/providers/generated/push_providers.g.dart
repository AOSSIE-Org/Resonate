// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../push_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appwritePush)
final appwritePushProvider = AppwritePushProvider._();

final class AppwritePushProvider extends $FunctionalProvider<Push, Push, Push>
    with $Provider<Push> {
  AppwritePushProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appwritePushProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appwritePushHash();

  @$internal
  @override
  $ProviderElement<Push> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Push create(Ref ref) {
    return appwritePush(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Push value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Push>(value),
    );
  }
}

String _$appwritePushHash() => r'e02475e944910032247b56a0040d39d7d3e15d2c';
