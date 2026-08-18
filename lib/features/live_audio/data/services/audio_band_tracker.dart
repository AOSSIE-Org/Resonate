import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart';

void _debugLog(String message) {
  if (kDebugMode) log('[waveform] $message');
}

typedef SpeakerBands = ({String uid, List<double> bands});

const int kAudioBandCount = 10;

const Duration _attachLinger = Duration(seconds: 3);

class AudioBandTracker {
  AudioBandTracker({required Room room}) : _room = room;

  final Room _room;

  final _controller = StreamController<SpeakerBands>.broadcast();
  final _attachments = <String, _BandAttachment>{};
  final _lingerTimers = <String, Timer>{};
  final _missingTrackLogged = <String>{};

  bool _disposed = false;

  Stream<SpeakerBands> get bands => _controller.stream;

  void syncSpeakers(Set<String> speaking) {
    if (_disposed) return;

    for (final identity in speaking) {
      _lingerTimers.remove(identity)?.cancel();
      if (!_attachments.containsKey(identity)) _attach(identity);
    }

    for (final identity in _attachments.keys.toList()) {
      if (speaking.contains(identity)) continue;
      _lingerTimers[identity] ??= Timer(_attachLinger, () {
        _lingerTimers.remove(identity);
        _detach(identity);
      });
    }
  }

  Future<void> _attach(String identity) async {
    final track = _audioTrackFor(identity);
    if (track == null) {
      if (_missingTrackLogged.add(identity)) {
        log('[waveform] no audio track for $identity — cannot attach FFT');
      }
      return;
    }
    _missingTrackLogged.remove(identity);

    final attachment = _BandAttachment();
    _attachments[identity] = attachment;

    try {
      final visualizer = createVisualizer(
        track,
        options: const AudioVisualizerOptions(
          barCount: kAudioBandCount,
          centeredBands: false,
          smoothTransition: true,
        ),
      );
      attachment.visualizer = visualizer;

      final listener = visualizer.createListener();
      attachment.listener = listener;
      listener.on<AudioVisualizerEvent>((event) {
        if (!attachment.sawBands) {
          attachment.sawBands = true;
          attachment.silenceProbe?.cancel();
          attachment.silenceProbe = null;
          _debugLog(
            'FFT bands arriving for $identity '
            '(${event.event.length} bands, first sample: ${event.event})',
          );
        }
        _emit(identity, event.event);
      });

      _debugLog('starting FFT for $identity on track ${track.sid}');
      await visualizer.start();
      attachment.silenceProbe = Timer(const Duration(seconds: 2), () {
        if (attachment.sawBands) return;
        log(
          '[waveform] NO FFT bands for $identity after 2s — the native '
          'analyzer is not delivering on this platform/build',
        );
      });

      // Disposed or replaced while start() was in flight.
      if (_disposed || !identical(_attachments[identity], attachment)) {
        await attachment.dispose();
      }
    } catch (error) {
      log('[waveform] visualizer for $identity failed: $error');
      if (identical(_attachments[identity], attachment)) {
        _attachments.remove(identity);
      }
      await attachment.dispose();
    }
  }

  Future<void> _detach(String identity) async {
    final attachment = _attachments.remove(identity);
    if (attachment == null) return;
    _debugLog(
      'detaching FFT for $identity '
      '(ever delivered bands: ${attachment.sawBands})',
    );
    await attachment.dispose();
    if (!_disposed && !_controller.isClosed) {
      // Tell listeners to drop this uid rather than keep stale bands around.
      _controller.add((uid: identity, bands: const []));
    }
  }

  AudioTrack? _audioTrackFor(String identity) {
    Participant<TrackPublication>? participant =
        _room.remoteParticipants[identity];
    final local = _room.localParticipant;
    if (participant == null && local != null && local.identity == identity) {
      participant = local;
    }
    if (participant == null) return null;

    for (final publication in participant.audioTrackPublications) {
      final track = publication.track;
      if (track is AudioTrack) return track;
    }
    return null;
  }

  void _emit(String identity, List<Object?> raw) {
    if (_disposed || _controller.isClosed) return;
    final bands = <double>[];
    for (final value in raw) {
      if (value is num) bands.add(value.toDouble());
    }
    if (bands.isEmpty) return;
    _controller.add((uid: identity, bands: bands));
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;

    for (final timer in _lingerTimers.values) {
      timer.cancel();
    }
    _lingerTimers.clear();

    for (final identity in _attachments.keys.toList()) {
      await _attachments.remove(identity)?.dispose();
    }
    await _controller.close();
  }
}

class _BandAttachment {
  AudioVisualizer? visualizer;
  EventsListener<AudioVisualizerEvent>? listener;

  bool sawBands = false;
  Timer? silenceProbe;

  Future<void> dispose() async {
    silenceProbe?.cancel();
    silenceProbe = null;
    try {
      await listener?.dispose();
      await visualizer?.stop();
      await visualizer?.dispose();
    } catch (error) {
      log('[waveform] visualizer teardown failed: $error');
    }
    listener = null;
    visualizer = null;
  }
}
