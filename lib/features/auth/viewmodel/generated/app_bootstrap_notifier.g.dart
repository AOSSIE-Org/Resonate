// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../app_bootstrap_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppBootstrap)
final appBootstrapProvider = AppBootstrapProvider._();

final class AppBootstrapProvider
    extends $AsyncNotifierProvider<AppBootstrap, void> {
  AppBootstrapProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appBootstrapProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appBootstrapHash();

  @$internal
  @override
  AppBootstrap create() => AppBootstrap();
}

String _$appBootstrapHash() => r'fd289d66500cd5fec89ffc7e98aa5f378131fe6a';

abstract class _$AppBootstrap extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
