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

String _$storiesRepositoryHash() => r'f15b1bf7232d7b46f8667acd431259046b8cfba0';
