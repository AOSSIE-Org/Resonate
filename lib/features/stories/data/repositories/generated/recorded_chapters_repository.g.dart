// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../recorded_chapters_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recordedChaptersRepository)
final recordedChaptersRepositoryProvider =
    RecordedChaptersRepositoryProvider._();

final class RecordedChaptersRepositoryProvider
    extends
        $FunctionalProvider<
          RecordedChaptersRepository,
          RecordedChaptersRepository,
          RecordedChaptersRepository
        >
    with $Provider<RecordedChaptersRepository> {
  RecordedChaptersRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordedChaptersRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordedChaptersRepositoryHash();

  @$internal
  @override
  $ProviderElement<RecordedChaptersRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecordedChaptersRepository create(Ref ref) {
    return recordedChaptersRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecordedChaptersRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecordedChaptersRepository>(value),
    );
  }
}

String _$recordedChaptersRepositoryHash() =>
    r'9f86f41ece3058aa8a6080e8d807bcabe9dba478';
