// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../audio_device_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(audioDeviceService)
final audioDeviceServiceProvider = AudioDeviceServiceProvider._();

final class AudioDeviceServiceProvider
    extends
        $FunctionalProvider<
          AudioDeviceService,
          AudioDeviceService,
          AudioDeviceService
        >
    with $Provider<AudioDeviceService> {
  AudioDeviceServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioDeviceServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioDeviceServiceHash();

  @$internal
  @override
  $ProviderElement<AudioDeviceService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AudioDeviceService create(Ref ref) {
    return audioDeviceService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AudioDeviceService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AudioDeviceService>(value),
    );
  }
}

String _$audioDeviceServiceHash() =>
    r'560f7e3d1bb2e75c230e87d296dffced539026ec';

@ProviderFor(AudioDeviceNotifier)
final audioDeviceProvider = AudioDeviceNotifierProvider._();

final class AudioDeviceNotifierProvider
    extends $NotifierProvider<AudioDeviceNotifier, AudioDeviceState> {
  AudioDeviceNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioDeviceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioDeviceNotifierHash();

  @$internal
  @override
  AudioDeviceNotifier create() => AudioDeviceNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AudioDeviceState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AudioDeviceState>(value),
    );
  }
}

String _$audioDeviceNotifierHash() =>
    r'3e223129e69515997e533c56fae6eb0e786ec735';

abstract class _$AudioDeviceNotifier extends $Notifier<AudioDeviceState> {
  AudioDeviceState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AudioDeviceState, AudioDeviceState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AudioDeviceState, AudioDeviceState>,
              AudioDeviceState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
