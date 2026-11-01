// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../about_app_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(upgrader)
final upgraderProvider = UpgraderProvider._();

final class UpgraderProvider
    extends $FunctionalProvider<Upgrader, Upgrader, Upgrader>
    with $Provider<Upgrader> {
  UpgraderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'upgraderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$upgraderHash();

  @$internal
  @override
  $ProviderElement<Upgrader> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Upgrader create(Ref ref) {
    return upgrader(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Upgrader value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Upgrader>(value),
    );
  }
}

String _$upgraderHash() => r'7d3db6120c1a02bb3755ebe03bff26b5e77de46f';

@ProviderFor(AboutApp)
final aboutAppProvider = AboutAppProvider._();

final class AboutAppProvider
    extends $NotifierProvider<AboutApp, AboutAppState> {
  AboutAppProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aboutAppProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aboutAppHash();

  @$internal
  @override
  AboutApp create() => AboutApp();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AboutAppState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AboutAppState>(value),
    );
  }
}

String _$aboutAppHash() => r'6ebea31ff47362a895a030b074e02d5d091822c0';

abstract class _$AboutApp extends $Notifier<AboutAppState> {
  AboutAppState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AboutAppState, AboutAppState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AboutAppState, AboutAppState>,
              AboutAppState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
