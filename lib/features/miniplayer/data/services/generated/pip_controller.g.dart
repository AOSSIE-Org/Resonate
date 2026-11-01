// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../pip_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PipMode)
final pipModeProvider = PipModeProvider._();

final class PipModeProvider extends $NotifierProvider<PipMode, bool> {
  PipModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pipModeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pipModeHash();

  @$internal
  @override
  PipMode create() => PipMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$pipModeHash() => r'6767ec197ecfda4ca20befcb1aa6b67d42907aeb';

abstract class _$PipMode extends $Notifier<bool> {
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
