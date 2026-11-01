// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../created_stories.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreatedStories)
final createdStoriesProvider = CreatedStoriesFamily._();

final class CreatedStoriesProvider
    extends $AsyncNotifierProvider<CreatedStories, List<Story>> {
  CreatedStoriesProvider._({
    required CreatedStoriesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'createdStoriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$createdStoriesHash();

  @override
  String toString() {
    return r'createdStoriesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CreatedStories create() => CreatedStories();

  @override
  bool operator ==(Object other) {
    return other is CreatedStoriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$createdStoriesHash() => r'82ccc5f47b91395ed05fdd9db965d5604c1bc992';

final class CreatedStoriesFamily extends $Family
    with
        $ClassFamilyOverride<
          CreatedStories,
          AsyncValue<List<Story>>,
          List<Story>,
          FutureOr<List<Story>>,
          String
        > {
  CreatedStoriesFamily._()
    : super(
        retry: null,
        name: r'createdStoriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CreatedStoriesProvider call(String creatorId) =>
      CreatedStoriesProvider._(argument: creatorId, from: this);

  @override
  String toString() => r'createdStoriesProvider';
}

abstract class _$CreatedStories extends $AsyncNotifier<List<Story>> {
  late final _$args = ref.$arg as String;
  String get creatorId => _$args;

  FutureOr<List<Story>> build(String creatorId);
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
