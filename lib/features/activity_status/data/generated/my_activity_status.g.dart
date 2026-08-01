// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../my_activity_status.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The signed-in user's own activity status, and the single writer of their `status`
/// attribute.
///
/// State is derived, not stored: [_chosen] is what the user picked, and the
/// live audio session and app lifecycle layer on top of it. That keeps the
/// transitions event-driven — a status is written only when the derived value
/// actually changes, never on a timer.
///
///   chosen=dnd + joins a room  -> inroom, and back to dnd on leaving
///   chosen=online + backgrounded -> idle, and back to online on resume
///   chosen=dnd + backgrounded  -> stays dnd

@ProviderFor(MyActivityStatus)
final myActivityStatusProvider = MyActivityStatusProvider._();

/// The signed-in user's own activity status, and the single writer of their `status`
/// attribute.
///
/// State is derived, not stored: [_chosen] is what the user picked, and the
/// live audio session and app lifecycle layer on top of it. That keeps the
/// transitions event-driven — a status is written only when the derived value
/// actually changes, never on a timer.
///
///   chosen=dnd + joins a room  -> inroom, and back to dnd on leaving
///   chosen=online + backgrounded -> idle, and back to online on resume
///   chosen=dnd + backgrounded  -> stays dnd
final class MyActivityStatusProvider
    extends $NotifierProvider<MyActivityStatus, ActivityStatus> {
  /// The signed-in user's own activity status, and the single writer of their `status`
  /// attribute.
  ///
  /// State is derived, not stored: [_chosen] is what the user picked, and the
  /// live audio session and app lifecycle layer on top of it. That keeps the
  /// transitions event-driven — a status is written only when the derived value
  /// actually changes, never on a timer.
  ///
  ///   chosen=dnd + joins a room  -> inroom, and back to dnd on leaving
  ///   chosen=online + backgrounded -> idle, and back to online on resume
  ///   chosen=dnd + backgrounded  -> stays dnd
  MyActivityStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myActivityStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myActivityStatusHash();

  @$internal
  @override
  MyActivityStatus create() => MyActivityStatus();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActivityStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActivityStatus>(value),
    );
  }
}

String _$myActivityStatusHash() => r'21e415cec68a7c018c7332586c39bca39123a383';

/// The signed-in user's own activity status, and the single writer of their `status`
/// attribute.
///
/// State is derived, not stored: [_chosen] is what the user picked, and the
/// live audio session and app lifecycle layer on top of it. That keeps the
/// transitions event-driven — a status is written only when the derived value
/// actually changes, never on a timer.
///
///   chosen=dnd + joins a room  -> inroom, and back to dnd on leaving
///   chosen=online + backgrounded -> idle, and back to online on resume
///   chosen=dnd + backgrounded  -> stays dnd

abstract class _$MyActivityStatus extends $Notifier<ActivityStatus> {
  ActivityStatus build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ActivityStatus, ActivityStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ActivityStatus, ActivityStatus>,
              ActivityStatus,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
