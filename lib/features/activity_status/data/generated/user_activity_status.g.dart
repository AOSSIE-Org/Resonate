// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../user_activity_status.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Activity status of the people the signed-in user can call, keyed by uid.
///
/// The tracked set is derived from the friends list rather than requested by
/// each widget, so there is exactly one realtime subscription and one batched
/// read for the whole app. Values are already filtered through
/// [ActivityStatus.asSeenByOthers], so an invisible friend reads as offline
/// here and never reaches the UI as invisible.

@ProviderFor(UserActivityStatus)
final userActivityStatusProvider = UserActivityStatusProvider._();

/// Activity status of the people the signed-in user can call, keyed by uid.
///
/// The tracked set is derived from the friends list rather than requested by
/// each widget, so there is exactly one realtime subscription and one batched
/// read for the whole app. Values are already filtered through
/// [ActivityStatus.asSeenByOthers], so an invisible friend reads as offline
/// here and never reaches the UI as invisible.
final class UserActivityStatusProvider
    extends $NotifierProvider<UserActivityStatus, Map<String, ActivityStatus>> {
  /// Activity status of the people the signed-in user can call, keyed by uid.
  ///
  /// The tracked set is derived from the friends list rather than requested by
  /// each widget, so there is exactly one realtime subscription and one batched
  /// read for the whole app. Values are already filtered through
  /// [ActivityStatus.asSeenByOthers], so an invisible friend reads as offline
  /// here and never reaches the UI as invisible.
  UserActivityStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userActivityStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userActivityStatusHash();

  @$internal
  @override
  UserActivityStatus create() => UserActivityStatus();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, ActivityStatus> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, ActivityStatus>>(value),
    );
  }
}

String _$userActivityStatusHash() =>
    r'39b92bc3485dc65497d8a385d247c2718044a5f1';

/// Activity status of the people the signed-in user can call, keyed by uid.
///
/// The tracked set is derived from the friends list rather than requested by
/// each widget, so there is exactly one realtime subscription and one batched
/// read for the whole app. Values are already filtered through
/// [ActivityStatus.asSeenByOthers], so an invisible friend reads as offline
/// here and never reaches the UI as invisible.

abstract class _$UserActivityStatus
    extends $Notifier<Map<String, ActivityStatus>> {
  Map<String, ActivityStatus> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<Map<String, ActivityStatus>, Map<String, ActivityStatus>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, ActivityStatus>,
                Map<String, ActivityStatus>
              >,
              Map<String, ActivityStatus>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
