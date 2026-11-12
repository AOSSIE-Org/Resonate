// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../get_storage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getStorageBox)
final getStorageBoxProvider = GetStorageBoxProvider._();

final class GetStorageBoxProvider
    extends $FunctionalProvider<GetStorage, GetStorage, GetStorage>
    with $Provider<GetStorage> {
  GetStorageBoxProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getStorageBoxProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getStorageBoxHash();

  @$internal
  @override
  $ProviderElement<GetStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetStorage create(Ref ref) {
    return getStorageBox(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetStorage>(value),
    );
  }
}

String _$getStorageBoxHash() => r'df78dedbe3bca91f692e32f31a1c3357f8741934';
