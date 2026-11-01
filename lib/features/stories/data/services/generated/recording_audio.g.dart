// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../recording_audio.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recordingAudioPlayer)
final recordingAudioPlayerProvider = RecordingAudioPlayerProvider._();

final class RecordingAudioPlayerProvider
    extends $FunctionalProvider<AudioPlayer, AudioPlayer, AudioPlayer>
    with $Provider<AudioPlayer> {
  RecordingAudioPlayerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordingAudioPlayerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordingAudioPlayerHash();

  @$internal
  @override
  $ProviderElement<AudioPlayer> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AudioPlayer create(Ref ref) {
    return recordingAudioPlayer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AudioPlayer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AudioPlayer>(value),
    );
  }
}

String _$recordingAudioPlayerHash() =>
    r'3609c0f2720bd1f9fcc3168d833ca9f33eb5034e';
