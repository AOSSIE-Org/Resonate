// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../callkit_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(callKitService)
final callKitServiceProvider = CallKitServiceProvider._();

final class CallKitServiceProvider
    extends $FunctionalProvider<CallKitService, CallKitService, CallKitService>
    with $Provider<CallKitService> {
  CallKitServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'callKitServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$callKitServiceHash();

  @$internal
  @override
  $ProviderElement<CallKitService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CallKitService create(Ref ref) {
    return callKitService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CallKitService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CallKitService>(value),
    );
  }
}

String _$callKitServiceHash() => r'92c38ce82f1b4af12d76e0a87bc8c7c1c08dd888';
