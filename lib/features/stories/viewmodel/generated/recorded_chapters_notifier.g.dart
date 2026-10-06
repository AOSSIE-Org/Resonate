// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../recorded_chapters_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RecordedChapters)
final recordedChaptersProvider = RecordedChaptersProvider._();

final class RecordedChaptersProvider
    extends $AsyncNotifierProvider<RecordedChapters, List<RecordedChapter>> {
  RecordedChaptersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordedChaptersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordedChaptersHash();

  @$internal
  @override
  RecordedChapters create() => RecordedChapters();
}

String _$recordedChaptersHash() => r'b2b20ea85b95606306da9a553364bd863f63da01';

abstract class _$RecordedChapters
    extends $AsyncNotifier<List<RecordedChapter>> {
  FutureOr<List<RecordedChapter>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<RecordedChapter>>, List<RecordedChapter>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<RecordedChapter>>,
                List<RecordedChapter>
              >,
              AsyncValue<List<RecordedChapter>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
