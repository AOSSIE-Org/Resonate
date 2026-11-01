// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../room_polls.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RoomPollsNotifier)
final roomPollsProvider = RoomPollsNotifierFamily._();

final class RoomPollsNotifierProvider
    extends $AsyncNotifierProvider<RoomPollsNotifier, RoomPollsState> {
  RoomPollsNotifierProvider._({
    required RoomPollsNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'roomPollsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$roomPollsNotifierHash();

  @override
  String toString() {
    return r'roomPollsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RoomPollsNotifier create() => RoomPollsNotifier();

  @override
  bool operator ==(Object other) {
    return other is RoomPollsNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$roomPollsNotifierHash() => r'1c934dd270213bbc8472595380dd483aef520010';

final class RoomPollsNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          RoomPollsNotifier,
          AsyncValue<RoomPollsState>,
          RoomPollsState,
          FutureOr<RoomPollsState>,
          String
        > {
  RoomPollsNotifierFamily._()
    : super(
        retry: null,
        name: r'roomPollsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RoomPollsNotifierProvider call(String roomId) =>
      RoomPollsNotifierProvider._(argument: roomId, from: this);

  @override
  String toString() => r'roomPollsProvider';
}

abstract class _$RoomPollsNotifier extends $AsyncNotifier<RoomPollsState> {
  late final _$args = ref.$arg as String;
  String get roomId => _$args;

  FutureOr<RoomPollsState> build(String roomId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<RoomPollsState>, RoomPollsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<RoomPollsState>, RoomPollsState>,
              AsyncValue<RoomPollsState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
