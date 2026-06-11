// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../change_email_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChangeEmail)
final changeEmailProvider = ChangeEmailProvider._();

final class ChangeEmailProvider
    extends $NotifierProvider<ChangeEmail, ChangeEmailState> {
  ChangeEmailProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'changeEmailProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$changeEmailHash();

  @$internal
  @override
  ChangeEmail create() => ChangeEmail();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChangeEmailState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChangeEmailState>(value),
    );
  }
}

String _$changeEmailHash() => r'a98535b66fb6f4551f2f7ff64c51c54478d49d37';

abstract class _$ChangeEmail extends $Notifier<ChangeEmailState> {
  ChangeEmailState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ChangeEmailState, ChangeEmailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChangeEmailState, ChangeEmailState>,
              ChangeEmailState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
