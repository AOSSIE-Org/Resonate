// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../livekit_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LiveKitNotifier)
final liveKitProvider = LiveKitNotifierProvider._();

final class LiveKitNotifierProvider
    extends $NotifierProvider<LiveKitNotifier, LiveKitState> {
  LiveKitNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'liveKitProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$liveKitNotifierHash();

  @$internal
  @override
  LiveKitNotifier create() => LiveKitNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LiveKitState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LiveKitState>(value),
    );
  }
}

String _$liveKitNotifierHash() => r'1c9f3d5ae76f6d3f489907a4ae669ef405f5247e';

abstract class _$LiveKitNotifier extends $Notifier<LiveKitState> {
  LiveKitState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<LiveKitState, LiveKitState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LiveKitState, LiveKitState>,
              LiveKitState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
