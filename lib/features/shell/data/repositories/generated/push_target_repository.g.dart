// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../push_target_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(apnsTokenService)
final apnsTokenServiceProvider = ApnsTokenServiceProvider._();

final class ApnsTokenServiceProvider
    extends
        $FunctionalProvider<
          ApnsTokenService,
          ApnsTokenService,
          ApnsTokenService
        >
    with $Provider<ApnsTokenService> {
  ApnsTokenServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apnsTokenServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apnsTokenServiceHash();

  @$internal
  @override
  $ProviderElement<ApnsTokenService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApnsTokenService create(Ref ref) {
    return apnsTokenService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApnsTokenService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApnsTokenService>(value),
    );
  }
}

String _$apnsTokenServiceHash() => r'036919733c55ddbf97a761a5661e8acac91a2d62';

@ProviderFor(pushTargetRepository)
final pushTargetRepositoryProvider = PushTargetRepositoryProvider._();

final class PushTargetRepositoryProvider
    extends
        $FunctionalProvider<
          PushTargetRepository,
          PushTargetRepository,
          PushTargetRepository
        >
    with $Provider<PushTargetRepository> {
  PushTargetRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushTargetRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushTargetRepositoryHash();

  @$internal
  @override
  $ProviderElement<PushTargetRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PushTargetRepository create(Ref ref) {
    return pushTargetRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushTargetRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushTargetRepository>(value),
    );
  }
}

String _$pushTargetRepositoryHash() =>
    r'0c87b9558b722dffe7df9c18f3e513fb05da8e4e';
