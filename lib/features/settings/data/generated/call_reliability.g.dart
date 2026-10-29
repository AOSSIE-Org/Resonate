// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../call_reliability.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether Android is currently allowed to deliver a call push promptly while
/// the app is closed.
///
/// `bestEffort` means it is not: Android may hold the push alarms, jobs and
/// even the foreground service, so a call that arrives after a long idle shows
/// up as a plain notification instead of ringing. The battery-optimisation
/// exemption lets the alarms and jobs run again.

@ProviderFor(callDeliveryDegraded)
final callDeliveryDegradedProvider = CallDeliveryDegradedProvider._();

/// Whether Android is currently allowed to deliver a call push promptly while
/// the app is closed.
///
/// `bestEffort` means it is not: Android may hold the push alarms, jobs and
/// even the foreground service, so a call that arrives after a long idle shows
/// up as a plain notification instead of ringing. The battery-optimisation
/// exemption lets the alarms and jobs run again.

final class CallDeliveryDegradedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether Android is currently allowed to deliver a call push promptly while
  /// the app is closed.
  ///
  /// `bestEffort` means it is not: Android may hold the push alarms, jobs and
  /// even the foreground service, so a call that arrives after a long idle shows
  /// up as a plain notification instead of ringing. The battery-optimisation
  /// exemption lets the alarms and jobs run again.
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
    r'bce011413ac5285accab6b24762581ea587d28b2';

/// Opens the system exemption prompt. Resolves false when there is nothing to
/// ask: already exempt, the permission is not declared, or not Android.

@ProviderFor(requestCallReliability)
final requestCallReliabilityProvider = RequestCallReliabilityProvider._();

/// Opens the system exemption prompt. Resolves false when there is nothing to
/// ask: already exempt, the permission is not declared, or not Android.

final class RequestCallReliabilityProvider
    extends
        $FunctionalProvider<
          Future<bool> Function(),
          Future<bool> Function(),
          Future<bool> Function()
        >
    with $Provider<Future<bool> Function()> {
  /// Opens the system exemption prompt. Resolves false when there is nothing to
  /// ask: already exempt, the permission is not declared, or not Android.
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
