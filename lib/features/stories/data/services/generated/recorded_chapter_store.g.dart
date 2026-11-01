// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../recorded_chapter_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recordedChapterStore)
final recordedChapterStoreProvider = RecordedChapterStoreProvider._();

final class RecordedChapterStoreProvider
    extends
        $FunctionalProvider<
          RecordedChapterStore,
          RecordedChapterStore,
          RecordedChapterStore
        >
    with $Provider<RecordedChapterStore> {
  RecordedChapterStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordedChapterStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordedChapterStoreHash();

  @$internal
  @override
  $ProviderElement<RecordedChapterStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecordedChapterStore create(Ref ref) {
    return recordedChapterStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecordedChapterStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecordedChapterStore>(value),
    );
  }
}

String _$recordedChapterStoreHash() =>
    r'71b3bea5a38e336a3687b69fa60f9a305ddab929';
