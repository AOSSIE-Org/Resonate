// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../explore_stories.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExploreStories)
final exploreStoriesProvider = ExploreStoriesProvider._();

final class ExploreStoriesProvider
    extends $NotifierProvider<ExploreStories, ExploreState> {
  ExploreStoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exploreStoriesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exploreStoriesHash();

  @$internal
  @override
  ExploreStories create() => ExploreStories();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExploreState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExploreState>(value),
    );
  }
}

String _$exploreStoriesHash() => r'0dd7cf87068b382c5fba3879c7a1a774f4bfcc03';

abstract class _$ExploreStories extends $Notifier<ExploreState> {
  ExploreState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ExploreState, ExploreState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ExploreState, ExploreState>,
              ExploreState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
