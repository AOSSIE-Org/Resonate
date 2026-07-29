// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../room_chat.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RoomChatMessages)
final roomChatMessagesProvider = RoomChatMessagesFamily._();

final class RoomChatMessagesProvider
    extends $AsyncNotifierProvider<RoomChatMessages, List<RoomMessage>> {
  RoomChatMessagesProvider._({
    required RoomChatMessagesFamily super.from,
    required (String, String, bool) super.argument,
  }) : super(
         retry: null,
         name: r'roomChatMessagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$roomChatMessagesHash();

  @override
  String toString() {
    return r'roomChatMessagesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  RoomChatMessages create() => RoomChatMessages();

  @override
  bool operator ==(Object other) {
    return other is RoomChatMessagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$roomChatMessagesHash() => r'2941d24be6c0d75060de5b13ad4c26a8adcb37be';

final class RoomChatMessagesFamily extends $Family
    with
        $ClassFamilyOverride<
          RoomChatMessages,
          AsyncValue<List<RoomMessage>>,
          List<RoomMessage>,
          FutureOr<List<RoomMessage>>,
          (String, String, bool)
        > {
  RoomChatMessagesFamily._()
    : super(
        retry: null,
        name: r'roomChatMessagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RoomChatMessagesProvider call(
    String roomId,
    String roomName,
    bool isUpcoming,
  ) => RoomChatMessagesProvider._(
    argument: (roomId, roomName, isUpcoming),
    from: this,
  );

  @override
  String toString() => r'roomChatMessagesProvider';
}

abstract class _$RoomChatMessages extends $AsyncNotifier<List<RoomMessage>> {
  late final _$args = ref.$arg as (String, String, bool);
  String get roomId => _$args.$1;
  String get roomName => _$args.$2;
  bool get isUpcoming => _$args.$3;

  FutureOr<List<RoomMessage>> build(
    String roomId,
    String roomName,
    bool isUpcoming,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<RoomMessage>>, List<RoomMessage>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<RoomMessage>>, List<RoomMessage>>,
              AsyncValue<List<RoomMessage>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args.$1, _$args.$2, _$args.$3));
  }
}
