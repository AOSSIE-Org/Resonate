// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../room_chat_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RoomChatNotifier)
final roomChatProvider = RoomChatNotifierFamily._();

final class RoomChatNotifierProvider
    extends $AsyncNotifierProvider<RoomChatNotifier, RoomChatState> {
  RoomChatNotifierProvider._({
    required RoomChatNotifierFamily super.from,
    required (String, String, bool) super.argument,
  }) : super(
         retry: null,
         name: r'roomChatProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$roomChatNotifierHash();

  @override
  String toString() {
    return r'roomChatProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  RoomChatNotifier create() => RoomChatNotifier();

  @override
  bool operator ==(Object other) {
    return other is RoomChatNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$roomChatNotifierHash() => r'1b70ffb57371cb1ee9c044af7a4ae63b5a5d6fed';

final class RoomChatNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          RoomChatNotifier,
          AsyncValue<RoomChatState>,
          RoomChatState,
          FutureOr<RoomChatState>,
          (String, String, bool)
        > {
  RoomChatNotifierFamily._()
    : super(
        retry: null,
        name: r'roomChatProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RoomChatNotifierProvider call(
    String roomId,
    String roomName,
    bool isUpcoming,
  ) => RoomChatNotifierProvider._(
    argument: (roomId, roomName, isUpcoming),
    from: this,
  );

  @override
  String toString() => r'roomChatProvider';
}

abstract class _$RoomChatNotifier extends $AsyncNotifier<RoomChatState> {
  late final _$args = ref.$arg as (String, String, bool);
  String get roomId => _$args.$1;
  String get roomName => _$args.$2;
  bool get isUpcoming => _$args.$3;

  FutureOr<RoomChatState> build(
    String roomId,
    String roomName,
    bool isUpcoming,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<RoomChatState>, RoomChatState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<RoomChatState>, RoomChatState>,
              AsyncValue<RoomChatState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args.$1, _$args.$2, _$args.$3));
  }
}
