// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../category_stories_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CategoryStories)
final categoryStoriesProvider = CategoryStoriesFamily._();

final class CategoryStoriesProvider
    extends $AsyncNotifierProvider<CategoryStories, List<Story>> {
  CategoryStoriesProvider._({
    required CategoryStoriesFamily super.from,
    required StoryCategory super.argument,
  }) : super(
         retry: null,
         name: r'categoryStoriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$categoryStoriesHash();

  @override
  String toString() {
    return r'categoryStoriesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CategoryStories create() => CategoryStories();

  @override
  bool operator ==(Object other) {
    return other is CategoryStoriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$categoryStoriesHash() => r'2bf3c8fc6341c1d4cabc1a2ed82ef0b81546da95';

final class CategoryStoriesFamily extends $Family
    with
        $ClassFamilyOverride<
          CategoryStories,
          AsyncValue<List<Story>>,
          List<Story>,
          FutureOr<List<Story>>,
          StoryCategory
        > {
  CategoryStoriesFamily._()
    : super(
        retry: null,
        name: r'categoryStoriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CategoryStoriesProvider call(StoryCategory category) =>
      CategoryStoriesProvider._(argument: category, from: this);

  @override
  String toString() => r'categoryStoriesProvider';
}

abstract class _$CategoryStories extends $AsyncNotifier<List<Story>> {
  late final _$args = ref.$arg as StoryCategory;
  StoryCategory get category => _$args;

  FutureOr<List<Story>> build(StoryCategory category);
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
    element.handleCreate(ref, () => build(_$args));
  }
}
