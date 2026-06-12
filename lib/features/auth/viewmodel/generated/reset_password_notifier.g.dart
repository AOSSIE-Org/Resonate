// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../reset_password_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ResetPassword)
final resetPasswordProvider = ResetPasswordProvider._();

final class ResetPasswordProvider
    extends $NotifierProvider<ResetPassword, AsyncValue<bool>> {
  ResetPasswordProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resetPasswordProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resetPasswordHash();

  @$internal
  @override
  ResetPassword create() => ResetPassword();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<bool> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<bool>>(value),
    );
  }
}

String _$resetPasswordHash() => r'689b3651e519b7ef425ca21d838019aae73f1007';

abstract class _$ResetPassword extends $Notifier<AsyncValue<bool>> {
  AsyncValue<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, AsyncValue<bool>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, AsyncValue<bool>>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
