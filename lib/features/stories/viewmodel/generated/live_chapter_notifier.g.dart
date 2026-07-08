// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../live_chapter_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LiveChapter)
final liveChapterProvider = LiveChapterProvider._();

final class LiveChapterProvider
    extends $NotifierProvider<LiveChapter, LiveChapterState> {
  LiveChapterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'liveChapterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$liveChapterHash();

  @$internal
  @override
  LiveChapter create() => LiveChapter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LiveChapterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LiveChapterState>(value),
    );
  }
}

String _$liveChapterHash() => r'e1509cd6f0cb12e6bce0641894dba8104e206e9c';

abstract class _$LiveChapter extends $Notifier<LiveChapterState> {
  LiveChapterState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<LiveChapterState, LiveChapterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LiveChapterState, LiveChapterState>,
              LiveChapterState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
