// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../email_verify_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EmailVerify)
final emailVerifyProvider = EmailVerifyProvider._();

final class EmailVerifyProvider
    extends $NotifierProvider<EmailVerify, EmailVerifyState> {
  EmailVerifyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emailVerifyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emailVerifyHash();

  @$internal
  @override
  EmailVerify create() => EmailVerify();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmailVerifyState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmailVerifyState>(value),
    );
  }
}

String _$emailVerifyHash() => r'22ee0a2bb896ea205849b470d0985b734e572769';

abstract class _$EmailVerify extends $Notifier<EmailVerifyState> {
  EmailVerifyState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<EmailVerifyState, EmailVerifyState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EmailVerifyState, EmailVerifyState>,
              EmailVerifyState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
