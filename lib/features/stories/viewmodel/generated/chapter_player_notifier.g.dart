// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../chapter_player_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChapterPlayer)
final chapterPlayerProvider = ChapterPlayerFamily._();

final class ChapterPlayerProvider
    extends $NotifierProvider<ChapterPlayer, ChapterPlayerState> {
  ChapterPlayerProvider._({
    required ChapterPlayerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chapterPlayerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chapterPlayerHash();

  @override
  String toString() {
    return r'chapterPlayerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChapterPlayer create() => ChapterPlayer();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChapterPlayerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChapterPlayerState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterPlayerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chapterPlayerHash() => r'008282749b0b5c29c6ef79c69caace9603946db0';

final class ChapterPlayerFamily extends $Family
    with
        $ClassFamilyOverride<
          ChapterPlayer,
          ChapterPlayerState,
          ChapterPlayerState,
          ChapterPlayerState,
          String
        > {
  ChapterPlayerFamily._()
    : super(
        retry: null,
        name: r'chapterPlayerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChapterPlayerProvider call(String chapterId) =>
      ChapterPlayerProvider._(argument: chapterId, from: this);

  @override
  String toString() => r'chapterPlayerProvider';
}

abstract class _$ChapterPlayer extends $Notifier<ChapterPlayerState> {
  late final _$args = ref.$arg as String;
  String get chapterId => _$args;

  ChapterPlayerState build(String chapterId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ChapterPlayerState, ChapterPlayerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChapterPlayerState, ChapterPlayerState>,
              ChapterPlayerState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
