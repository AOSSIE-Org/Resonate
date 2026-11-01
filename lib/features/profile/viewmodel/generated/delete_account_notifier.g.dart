// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../delete_account_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DeleteAccount)
final deleteAccountProvider = DeleteAccountProvider._();

final class DeleteAccountProvider
    extends $NotifierProvider<DeleteAccount, bool> {
  DeleteAccountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteAccountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteAccountHash();

  @$internal
  @override
  DeleteAccount create() => DeleteAccount();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$deleteAccountHash() => r'a6ce4a8d69441aa8936b19ebfca553e964496ef3';

abstract class _$DeleteAccount extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
