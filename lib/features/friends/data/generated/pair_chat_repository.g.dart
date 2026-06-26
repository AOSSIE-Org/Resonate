// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../pair_chat_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pairChatRepository)
final pairChatRepositoryProvider = PairChatRepositoryProvider._();

final class PairChatRepositoryProvider
    extends
        $FunctionalProvider<
          PairChatRepository,
          PairChatRepository,
          PairChatRepository
        >
    with $Provider<PairChatRepository> {
  PairChatRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pairChatRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pairChatRepositoryHash();

  @$internal
  @override
  $ProviderElement<PairChatRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PairChatRepository create(Ref ref) {
    return pairChatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PairChatRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PairChatRepository>(value),
    );
  }
}

String _$pairChatRepositoryHash() =>
    r'44cb32c7387e34da38c2093352f2ca745271d0f1';
