// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../chapter_audio.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chapterAudioFactory)
final chapterAudioFactoryProvider = ChapterAudioFactoryProvider._();

final class ChapterAudioFactoryProvider
    extends
        $FunctionalProvider<
          ChapterAudioFactory,
          ChapterAudioFactory,
          ChapterAudioFactory
        >
    with $Provider<ChapterAudioFactory> {
  ChapterAudioFactoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chapterAudioFactoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chapterAudioFactoryHash();

  @$internal
  @override
  $ProviderElement<ChapterAudioFactory> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChapterAudioFactory create(Ref ref) {
    return chapterAudioFactory(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChapterAudioFactory value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChapterAudioFactory>(value),
    );
  }
}

String _$chapterAudioFactoryHash() =>
    r'41e17227ce163b31766e05ca79deb28cceee1a04';
