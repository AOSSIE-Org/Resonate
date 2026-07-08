// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../explore_stories_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExploreStories)
final exploreStoriesProvider = ExploreStoriesProvider._();

final class ExploreStoriesProvider
    extends $AsyncNotifierProvider<ExploreStories, List<Story>> {
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
}

String _$exploreStoriesHash() => r'6548bf8fa54beba32389992b8b13bca6de6abf7e';

abstract class _$ExploreStories extends $AsyncNotifier<List<Story>> {
  FutureOr<List<Story>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Story>>, List<Story>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Story>>, List<Story>>,
              AsyncValue<List<Story>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
