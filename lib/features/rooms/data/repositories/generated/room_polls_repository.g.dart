// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../room_polls_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(roomPollsRepository)
final roomPollsRepositoryProvider = RoomPollsRepositoryProvider._();

final class RoomPollsRepositoryProvider
    extends
        $FunctionalProvider<
          RoomPollsRepository,
          RoomPollsRepository,
          RoomPollsRepository
        >
    with $Provider<RoomPollsRepository> {
  RoomPollsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roomPollsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roomPollsRepositoryHash();

  @$internal
  @override
  $ProviderElement<RoomPollsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RoomPollsRepository create(Ref ref) {
    return roomPollsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoomPollsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RoomPollsRepository>(value),
    );
  }
}

String _$roomPollsRepositoryHash() =>
    r'70456e266afb7986f5519c32c36338f540d8c6d6';
