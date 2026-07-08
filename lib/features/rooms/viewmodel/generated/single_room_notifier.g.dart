// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../single_room_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SingleRoomNotifier)
final singleRoomProvider = SingleRoomNotifierFamily._();

final class SingleRoomNotifierProvider
    extends $AsyncNotifierProvider<SingleRoomNotifier, SingleRoomState> {
  SingleRoomNotifierProvider._({
    required SingleRoomNotifierFamily super.from,
    required AppwriteRoom super.argument,
  }) : super(
         retry: null,
         name: r'singleRoomProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$singleRoomNotifierHash();

  @override
  String toString() {
    return r'singleRoomProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SingleRoomNotifier create() => SingleRoomNotifier();

  @override
  bool operator ==(Object other) {
    return other is SingleRoomNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$singleRoomNotifierHash() =>
    r'1c432c41111b39fc6baad2683a5dc408950128a6';

final class SingleRoomNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          SingleRoomNotifier,
          AsyncValue<SingleRoomState>,
          SingleRoomState,
          FutureOr<SingleRoomState>,
          AppwriteRoom
        > {
  SingleRoomNotifierFamily._()
    : super(
        retry: null,
        name: r'singleRoomProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SingleRoomNotifierProvider call(AppwriteRoom appwriteRoom) =>
      SingleRoomNotifierProvider._(argument: appwriteRoom, from: this);

  @override
  String toString() => r'singleRoomProvider';
}

abstract class _$SingleRoomNotifier extends $AsyncNotifier<SingleRoomState> {
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
