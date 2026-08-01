// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../livekit_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LiveKitController)
final liveKitControllerProvider = LiveKitControllerProvider._();

final class LiveKitControllerProvider
    extends $NotifierProvider<LiveKitController, LiveKitState> {
  LiveKitControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'liveKitControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$liveKitControllerHash();

  @$internal
  @override
  LiveKitController create() => LiveKitController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LiveKitState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LiveKitState>(value),
    );
  }
}

String _$liveKitControllerHash() => r'bc8a118a4e72fba141ff68992cacc3d1a2730335';

abstract class _$LiveKitController extends $Notifier<LiveKitState> {
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
