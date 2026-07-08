// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../story_search_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StorySearch)
final storySearchProvider = StorySearchProvider._();

final class StorySearchProvider
    extends $NotifierProvider<StorySearch, StorySearchState> {
  StorySearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storySearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storySearchHash();

  @$internal
  @override
  StorySearch create() => StorySearch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StorySearchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StorySearchState>(value),
    );
  }
}

String _$storySearchHash() => r'95627b26b5c41684477416354cb7c5e000ec846d';

abstract class _$StorySearch extends $Notifier<StorySearchState> {
  StorySearchState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<StorySearchState, StorySearchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StorySearchState, StorySearchState>,
              StorySearchState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
