// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../friend_call_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(friendCallRepository)
final friendCallRepositoryProvider = FriendCallRepositoryProvider._();

final class FriendCallRepositoryProvider
    extends
        $FunctionalProvider<
          FriendCallRepository,
          FriendCallRepository,
          FriendCallRepository
        >
    with $Provider<FriendCallRepository> {
  FriendCallRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'friendCallRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$friendCallRepositoryHash();

  @$internal
  @override
  $ProviderElement<FriendCallRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FriendCallRepository create(Ref ref) {
    return friendCallRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FriendCallRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FriendCallRepository>(value),
    );
  }
}

String _$friendCallRepositoryHash() =>
    r'bd4642d294c1216a2c8b83c2ba9c7c3fd326f7f9';
