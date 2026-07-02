// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../tabview_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TabView)
final tabViewProvider = TabViewProvider._();

final class TabViewProvider extends $NotifierProvider<TabView, int> {
  TabViewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tabViewProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tabViewHash();

  @$internal
  @override
  TabView create() => TabView();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$tabViewHash() => r'be06fa825c35b85454bbe7abc544f7816ac14968';

abstract class _$TabView extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
