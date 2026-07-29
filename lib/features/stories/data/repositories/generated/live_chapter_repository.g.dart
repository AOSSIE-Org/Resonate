// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../live_chapter_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(liveChapterRepository)
final liveChapterRepositoryProvider = LiveChapterRepositoryProvider._();

final class LiveChapterRepositoryProvider
    extends
        $FunctionalProvider<
          LiveChapterRepository,
          LiveChapterRepository,
          LiveChapterRepository
        >
    with $Provider<LiveChapterRepository> {
  LiveChapterRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'liveChapterRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$liveChapterRepositoryHash();

  @$internal
  @override
  $ProviderElement<LiveChapterRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LiveChapterRepository create(Ref ref) {
    return liveChapterRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LiveChapterRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LiveChapterRepository>(value),
    );
  }
}

String _$liveChapterRepositoryHash() =>
    r'bafcab8148f6c4b1a9bf6b1856a45103f9577e9f';
