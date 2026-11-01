// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../stories_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(storiesRepository)
final storiesRepositoryProvider = StoriesRepositoryProvider._();

final class StoriesRepositoryProvider
    extends
        $FunctionalProvider<
          StoriesRepository,
          StoriesRepository,
          StoriesRepository
        >
    with $Provider<StoriesRepository> {
  StoriesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storiesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storiesRepositoryHash();

  @$internal
  @override
  $ProviderElement<StoriesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StoriesRepository create(Ref ref) {
    return storiesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StoriesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StoriesRepository>(value),
    );
  }
}

String _$storiesRepositoryHash() => r'30d80f1ac904c9c9714e66d6f37aaacb65dddc9f';
