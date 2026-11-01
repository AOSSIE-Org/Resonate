// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../my_activity_status.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MyActivityStatus)
final myActivityStatusProvider = MyActivityStatusProvider._();

final class MyActivityStatusProvider
    extends $NotifierProvider<MyActivityStatus, ActivityStatus> {
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

String _$myActivityStatusHash() => r'd21a3558b95bdfd255161f4804fb24c06e421e18';

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
