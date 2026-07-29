// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../room_join_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(roomJoinService)
final roomJoinServiceProvider = RoomJoinServiceProvider._();

final class RoomJoinServiceProvider
    extends
        $FunctionalProvider<RoomJoinService, RoomJoinService, RoomJoinService>
    with $Provider<RoomJoinService> {
  RoomJoinServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roomJoinServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roomJoinServiceHash();

  @$internal
  @override
  $ProviderElement<RoomJoinService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RoomJoinService create(Ref ref) {
    return roomJoinService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoomJoinService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RoomJoinService>(value),
    );
  }
}

String _$roomJoinServiceHash() => r'181c9c83e1ff4f0b40d7329acb7b5a20d533e1de';
