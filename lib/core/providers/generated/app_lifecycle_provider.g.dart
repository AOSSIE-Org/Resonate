// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../app_lifecycle_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app's foreground/background state, as a provider so consumers can react
/// to it without each holding their own `WidgetsBindingObserver`.
///
/// Exposed as a provider rather than an `AppLifecycleListener` created inline
/// by its consumer so tests can override it — building one touches
/// `WidgetsBinding.instance`, which is not available in plain unit tests.

@ProviderFor(AppLifecycle)
final appLifecycleProvider = AppLifecycleProvider._();

/// The app's foreground/background state, as a provider so consumers can react
/// to it without each holding their own `WidgetsBindingObserver`.
///
/// Exposed as a provider rather than an `AppLifecycleListener` created inline
/// by its consumer so tests can override it — building one touches
/// `WidgetsBinding.instance`, which is not available in plain unit tests.
final class AppLifecycleProvider
    extends $NotifierProvider<AppLifecycle, AppLifecycleState> {
  /// The app's foreground/background state, as a provider so consumers can react
  /// to it without each holding their own `WidgetsBindingObserver`.
  ///
  /// Exposed as a provider rather than an `AppLifecycleListener` created inline
  /// by its consumer so tests can override it — building one touches
  /// `WidgetsBinding.instance`, which is not available in plain unit tests.
  AppLifecycleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLifecycleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLifecycleHash();

  @$internal
  @override
  AppLifecycle create() => AppLifecycle();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLifecycleState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLifecycleState>(value),
    );
  }
}

String _$appLifecycleHash() => r'e062174932f88875bf19e391e0caefe9774a96cc';

/// The app's foreground/background state, as a provider so consumers can react
/// to it without each holding their own `WidgetsBindingObserver`.
///
/// Exposed as a provider rather than an `AppLifecycleListener` created inline
/// by its consumer so tests can override it — building one touches
/// `WidgetsBinding.instance`, which is not available in plain unit tests.

abstract class _$AppLifecycle extends $Notifier<AppLifecycleState> {
  AppLifecycleState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AppLifecycleState, AppLifecycleState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppLifecycleState, AppLifecycleState>,
              AppLifecycleState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
