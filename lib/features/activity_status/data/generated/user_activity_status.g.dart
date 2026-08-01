// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../user_activity_status.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserActivityStatus)
final userActivityStatusProvider = UserActivityStatusProvider._();

final class UserActivityStatusProvider
    extends $NotifierProvider<UserActivityStatus, Map<String, ActivityStatus>> {
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
