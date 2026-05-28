// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../room_chat_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(roomChatRepository)
final roomChatRepositoryProvider = RoomChatRepositoryProvider._();

final class RoomChatRepositoryProvider
    extends
        $FunctionalProvider<
          RoomChatRepository,
          RoomChatRepository,
          RoomChatRepository
        >
    with $Provider<RoomChatRepository> {
  RoomChatRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roomChatRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roomChatRepositoryHash();

  @$internal
  @override
  $ProviderElement<RoomChatRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RoomChatRepository create(Ref ref) {
    return roomChatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoomChatRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RoomChatRepository>(value),
    );
  }
}

String _$roomChatRepositoryHash() =>
    r'15c06a01d6f20e32d4a192db48561e9ac0ee1610';
