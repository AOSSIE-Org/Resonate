// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../recording_playback.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RecordingPlayback)
final recordingPlaybackProvider = RecordingPlaybackProvider._();

final class RecordingPlaybackProvider
    extends $NotifierProvider<RecordingPlayback, RecordingPlaybackState> {
  RecordingPlaybackProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordingPlaybackProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordingPlaybackHash();

  @$internal
  @override
  RecordingPlayback create() => RecordingPlayback();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecordingPlaybackState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecordingPlaybackState>(value),
    );
  }
}

String _$recordingPlaybackHash() => r'2e0e9f7f10e2fbe8acd197f5a257723ba6b284f7';

abstract class _$RecordingPlayback extends $Notifier<RecordingPlaybackState> {
  RecordingPlaybackState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<RecordingPlaybackState, RecordingPlaybackState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RecordingPlaybackState, RecordingPlaybackState>,
              RecordingPlaybackState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
