// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../live_rooms.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LiveRooms)
final liveRoomsProvider = LiveRoomsProvider._();

final class LiveRoomsProvider
    extends $AsyncNotifierProvider<LiveRooms, List<AppwriteRoom>> {
  LiveRoomsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'liveRoomsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$liveRoomsHash();

  @$internal
  @override
  LiveRooms create() => LiveRooms();
}

String _$liveRoomsHash() => r'8a4dacfaa8ab74cb5d99c4901cde4f4154cbb528';

abstract class _$LiveRooms extends $AsyncNotifier<List<AppwriteRoom>> {
  FutureOr<List<AppwriteRoom>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<AppwriteRoom>>, List<AppwriteRoom>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<AppwriteRoom>>, List<AppwriteRoom>>,
              AsyncValue<List<AppwriteRoom>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
