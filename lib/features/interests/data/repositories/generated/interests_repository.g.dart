// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../interests_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(interestsRepository)
final interestsRepositoryProvider = InterestsRepositoryProvider._();

final class InterestsRepositoryProvider
    extends
        $FunctionalProvider<
          InterestsRepository,
          InterestsRepository,
          InterestsRepository
        >
    with $Provider<InterestsRepository> {
  InterestsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interestsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interestsRepositoryHash();

  @$internal
  @override
  $ProviderElement<InterestsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InterestsRepository create(Ref ref) {
    return interestsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InterestsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InterestsRepository>(value),
    );
  }
}

String _$interestsRepositoryHash() =>
    r'18625086a5c81fd2ac4bd189dd4e1ba04fb15d6c';
