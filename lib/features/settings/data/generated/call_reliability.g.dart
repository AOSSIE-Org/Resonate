// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../call_reliability.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(callDeliveryDegraded)
final callDeliveryDegradedProvider = CallDeliveryDegradedProvider._();

final class CallDeliveryDegradedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  CallDeliveryDegradedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'callDeliveryDegradedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$callDeliveryDegradedHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return callDeliveryDegraded(ref);
  }
}

String _$callDeliveryDegradedHash() =>
    r'f9ced3d013c04a33cfb0f1f94b8aa57070ac51a8';

@ProviderFor(requestCallReliability)
final requestCallReliabilityProvider = RequestCallReliabilityProvider._();

final class RequestCallReliabilityProvider
    extends
        $FunctionalProvider<
          Future<bool> Function(),
          Future<bool> Function(),
          Future<bool> Function()
        >
    with $Provider<Future<bool> Function()> {
  RequestCallReliabilityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requestCallReliabilityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requestCallReliabilityHash();

  @$internal
  @override
  $ProviderElement<Future<bool> Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<bool> Function() create(Ref ref) {
    return requestCallReliability(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<bool> Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Future<bool> Function()>(value),
    );
  }
}

String _$requestCallReliabilityHash() =>
    r'e7a4151c784a861e544c480febfe17f7960c8f4d';
