// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../room_launcher.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(roomLauncher)
final roomLauncherProvider = RoomLauncherProvider._();

final class RoomLauncherProvider
    extends $FunctionalProvider<RoomLauncher, RoomLauncher, RoomLauncher>
    with $Provider<RoomLauncher> {
  RoomLauncherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roomLauncherProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roomLauncherHash();

  @$internal
  @override
  $ProviderElement<RoomLauncher> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RoomLauncher create(Ref ref) {
    return roomLauncher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoomLauncher value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RoomLauncher>(value),
    );
  }
}

String _$roomLauncherHash() => r'bfd48d6d20ff5dd63a2e93b6c5714e80b6c6a660';
