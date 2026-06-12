// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../password_strength_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PasswordStrengthChecker)
final passwordStrengthCheckerProvider = PasswordStrengthCheckerProvider._();

final class PasswordStrengthCheckerProvider
    extends $NotifierProvider<PasswordStrengthChecker, PasswordStrength> {
  PasswordStrengthCheckerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'passwordStrengthCheckerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$passwordStrengthCheckerHash();

  @$internal
  @override
  PasswordStrengthChecker create() => PasswordStrengthChecker();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PasswordStrength value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PasswordStrength>(value),
    );
  }
}

String _$passwordStrengthCheckerHash() =>
    r'ba1b69f8083680dee070a6e12a96e761c61ed976';

abstract class _$PasswordStrengthChecker extends $Notifier<PasswordStrength> {
  PasswordStrength build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PasswordStrength, PasswordStrength>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PasswordStrength, PasswordStrength>,
              PasswordStrength,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
