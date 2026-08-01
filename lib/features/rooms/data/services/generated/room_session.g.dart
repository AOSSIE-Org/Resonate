// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../room_session.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RoomSession)
final roomSessionProvider = RoomSessionFamily._();

final class RoomSessionProvider
    extends $AsyncNotifierProvider<RoomSession, SingleRoomState> {
  RoomSessionProvider._({
    required RoomSessionFamily super.from,
    required AppwriteRoom super.argument,
  }) : super(
         retry: null,
         name: r'roomSessionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$roomSessionHash();

  @override
  String toString() {
    return r'roomSessionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RoomSession create() => RoomSession();

  @override
  bool operator ==(Object other) {
    return other is RoomSessionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$roomSessionHash() => r'9925e0d11184d7b0c4bd338d94e341d8053b87de';

final class RoomSessionFamily extends $Family
    with
        $ClassFamilyOverride<
          RoomSession,
          AsyncValue<SingleRoomState>,
          SingleRoomState,
          FutureOr<SingleRoomState>,
          AppwriteRoom
        > {
  RoomSessionFamily._()
    : super(
        retry: null,
        name: r'roomSessionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RoomSessionProvider call(AppwriteRoom appwriteRoom) =>
      RoomSessionProvider._(argument: appwriteRoom, from: this);

  @override
  String toString() => r'roomSessionProvider';
}

abstract class _$RoomSession extends $AsyncNotifier<SingleRoomState> {
  late final _$args = ref.$arg as AppwriteRoom;
  AppwriteRoom get appwriteRoom => _$args;

  FutureOr<SingleRoomState> build(AppwriteRoom appwriteRoom);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SingleRoomState>, SingleRoomState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SingleRoomState>, SingleRoomState>,
              AsyncValue<SingleRoomState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
