// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../activity_recorder.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ActivityRecorder)
final activityRecorderProvider = ActivityRecorderProvider._();

final class ActivityRecorderProvider
    extends $NotifierProvider<ActivityRecorder, void> {
  ActivityRecorderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityRecorderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityRecorderHash();

  @$internal
  @override
  ActivityRecorder create() => ActivityRecorder();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$activityRecorderHash() => r'67c24781aea6658b4c4f95bb990683b6af4827b6';

abstract class _$ActivityRecorder extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
