// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../friends_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(friendsRepository)
final friendsRepositoryProvider = FriendsRepositoryProvider._();

final class FriendsRepositoryProvider
    extends
        $FunctionalProvider<
          FriendsRepository,
          FriendsRepository,
          FriendsRepository
        >
    with $Provider<FriendsRepository> {
  FriendsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'friendsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$friendsRepositoryHash();

  @$internal
  @override
  $ProviderElement<FriendsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FriendsRepository create(Ref ref) {
    return friendsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FriendsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FriendsRepository>(value),
    );
  }
}

String _$friendsRepositoryHash() => r'71326fc33aa846a49d5ecc2cdf55ab2ea87ce036';
