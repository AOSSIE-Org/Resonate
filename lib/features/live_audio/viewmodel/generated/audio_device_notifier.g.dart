// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../audio_device_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
    r'd29c808db7d77b8d01fc9e574875b03a32c1134c';

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
