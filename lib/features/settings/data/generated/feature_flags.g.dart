// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../feature_flags.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The features the user currently wants to see, read from and written to
/// local storage.
///
/// A feature is enabled unless it was explicitly turned off, so shipping a new
/// flag never hides anything by surprise. Storage is synchronous (`GetStorage`
/// is initialised in `main`), which keeps the first frame and the router
/// redirect free of an async gap.

@ProviderFor(FeatureFlags)
final featureFlagsProvider = FeatureFlagsProvider._();

/// The features the user currently wants to see, read from and written to
/// local storage.
///
/// A feature is enabled unless it was explicitly turned off, so shipping a new
/// flag never hides anything by surprise. Storage is synchronous (`GetStorage`
/// is initialised in `main`), which keeps the first frame and the router
/// redirect free of an async gap.
final class FeatureFlagsProvider
    extends $NotifierProvider<FeatureFlags, Set<AppFeature>> {
  /// The features the user currently wants to see, read from and written to
  /// local storage.
  ///
  /// A feature is enabled unless it was explicitly turned off, so shipping a new
  /// flag never hides anything by surprise. Storage is synchronous (`GetStorage`
  /// is initialised in `main`), which keeps the first frame and the router
  /// redirect free of an async gap.
  FeatureFlagsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'featureFlagsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$featureFlagsHash();

  @$internal
  @override
  FeatureFlags create() => FeatureFlags();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<AppFeature> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<AppFeature>>(value),
    );
  }
}

String _$featureFlagsHash() => r'7db6b7495fdfe85eca2a883382dd0e21a466f2ae';

/// The features the user currently wants to see, read from and written to
/// local storage.
///
/// A feature is enabled unless it was explicitly turned off, so shipping a new
/// flag never hides anything by surprise. Storage is synchronous (`GetStorage`
/// is initialised in `main`), which keeps the first frame and the router
/// redirect free of an async gap.

abstract class _$FeatureFlags extends $Notifier<Set<AppFeature>> {
  Set<AppFeature> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<AppFeature>, Set<AppFeature>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<AppFeature>, Set<AppFeature>>,
              Set<AppFeature>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Whether a single feature is on — the read side call sites should watch, so
/// toggling one flag only rebuilds the widgets that care about that flag.

@ProviderFor(featureEnabled)
final featureEnabledProvider = FeatureEnabledFamily._();

/// Whether a single feature is on — the read side call sites should watch, so
/// toggling one flag only rebuilds the widgets that care about that flag.

final class FeatureEnabledProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether a single feature is on — the read side call sites should watch, so
  /// toggling one flag only rebuilds the widgets that care about that flag.
  FeatureEnabledProvider._({
    required FeatureEnabledFamily super.from,
    required AppFeature super.argument,
  }) : super(
         retry: null,
         name: r'featureEnabledProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$featureEnabledHash();

  @override
  String toString() {
    return r'featureEnabledProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as AppFeature;
    return featureEnabled(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FeatureEnabledProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$featureEnabledHash() => r'3e15f079ba36f1036aa0357025175464f73bee84';

/// Whether a single feature is on — the read side call sites should watch, so
/// toggling one flag only rebuilds the widgets that care about that flag.

final class FeatureEnabledFamily extends $Family
    with $FunctionalFamilyOverride<bool, AppFeature> {
  FeatureEnabledFamily._()
    : super(
        retry: null,
        name: r'featureEnabledProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// Whether a single feature is on — the read side call sites should watch, so
  /// toggling one flag only rebuilds the widgets that care about that flag.

  FeatureEnabledProvider call(AppFeature feature) =>
      FeatureEnabledProvider._(argument: feature, from: this);

  @override
  String toString() => r'featureEnabledProvider';
}
