// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../audio_device_service.dart';

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
