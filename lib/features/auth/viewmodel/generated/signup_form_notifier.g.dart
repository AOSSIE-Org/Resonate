// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../signup_form_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SignupForm)
final signupFormProvider = SignupFormProvider._();

final class SignupFormProvider
    extends $NotifierProvider<SignupForm, SignupFormState> {
  SignupFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signupFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signupFormHash();

  @$internal
  @override
  SignupForm create() => SignupForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignupFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignupFormState>(value),
    );
  }
}

String _$signupFormHash() => r'25bb0304e03610100fb38ad2efc353f64c336df7';

abstract class _$SignupForm extends $Notifier<SignupFormState> {
  SignupFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SignupFormState, SignupFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SignupFormState, SignupFormState>,
              SignupFormState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
