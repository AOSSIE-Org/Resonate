// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../room_chat_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// View state for the chat screen. The message list itself is long-lived,
/// realtime-backed state and lives in the data layer ([roomChatMessagesProvider]);
/// the only thing the view owns is which message the composer is replying to.
///
/// Actions are delegated with `ref.read` rather than `ref.watch` on purpose: a
/// watch would rebuild this notifier on every incoming message and silently
/// clear the composer's reply.

@ProviderFor(RoomChatComposer)
final roomChatComposerProvider = RoomChatComposerFamily._();

/// View state for the chat screen. The message list itself is long-lived,
/// realtime-backed state and lives in the data layer ([roomChatMessagesProvider]);
/// the only thing the view owns is which message the composer is replying to.
///
/// Actions are delegated with `ref.read` rather than `ref.watch` on purpose: a
/// watch would rebuild this notifier on every incoming message and silently
/// clear the composer's reply.
final class RoomChatComposerProvider
    extends $NotifierProvider<RoomChatComposer, ReplyTo?> {
  /// View state for the chat screen. The message list itself is long-lived,
  /// realtime-backed state and lives in the data layer ([roomChatMessagesProvider]);
  /// the only thing the view owns is which message the composer is replying to.
  ///
  /// Actions are delegated with `ref.read` rather than `ref.watch` on purpose: a
  /// watch would rebuild this notifier on every incoming message and silently
  /// clear the composer's reply.
  RoomChatComposerProvider._({
    required RoomChatComposerFamily super.from,
    required (String, String, bool) super.argument,
  }) : super(
         retry: null,
         name: r'roomChatComposerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$roomChatComposerHash();

  @override
  String toString() {
    return r'roomChatComposerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  RoomChatComposer create() => RoomChatComposer();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReplyTo? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReplyTo?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RoomChatComposerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$roomChatComposerHash() => r'ce356b40ea37f9d3f94fefe7ce642376bc66ed8e';

/// View state for the chat screen. The message list itself is long-lived,
/// realtime-backed state and lives in the data layer ([roomChatMessagesProvider]);
/// the only thing the view owns is which message the composer is replying to.
///
/// Actions are delegated with `ref.read` rather than `ref.watch` on purpose: a
/// watch would rebuild this notifier on every incoming message and silently
/// clear the composer's reply.

final class RoomChatComposerFamily extends $Family
    with
        $ClassFamilyOverride<
          RoomChatComposer,
          ReplyTo?,
          ReplyTo?,
          ReplyTo?,
          (String, String, bool)
        > {
  RoomChatComposerFamily._()
    : super(
        retry: null,
        name: r'roomChatComposerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// View state for the chat screen. The message list itself is long-lived,
  /// realtime-backed state and lives in the data layer ([roomChatMessagesProvider]);
  /// the only thing the view owns is which message the composer is replying to.
  ///
  /// Actions are delegated with `ref.read` rather than `ref.watch` on purpose: a
  /// watch would rebuild this notifier on every incoming message and silently
  /// clear the composer's reply.

  RoomChatComposerProvider call(
    String roomId,
    String roomName,
    bool isUpcoming,
  ) => RoomChatComposerProvider._(
    argument: (roomId, roomName, isUpcoming),
    from: this,
  );

  @override
  String toString() => r'roomChatComposerProvider';
}

/// View state for the chat screen. The message list itself is long-lived,
/// realtime-backed state and lives in the data layer ([roomChatMessagesProvider]);
/// the only thing the view owns is which message the composer is replying to.
///
/// Actions are delegated with `ref.read` rather than `ref.watch` on purpose: a
/// watch would rebuild this notifier on every incoming message and silently
/// clear the composer's reply.

abstract class _$RoomChatComposer extends $Notifier<ReplyTo?> {
  late final _$args = ref.$arg as (String, String, bool);
  String get roomId => _$args.$1;
  String get roomName => _$args.$2;
  bool get isUpcoming => _$args.$3;

  ReplyTo? build(String roomId, String roomName, bool isUpcoming);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ReplyTo?, ReplyTo?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReplyTo?, ReplyTo?>,
              ReplyTo?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args.$1, _$args.$2, _$args.$3));
  }
}
