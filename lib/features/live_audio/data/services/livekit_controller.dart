import 'dart:async';

import 'package:livekit_client/livekit_client.dart';
import 'package:resonate/features/live_audio/data/services/audio_band_tracker.dart';
import 'package:resonate/features/live_audio/data/services/livekit_session.dart';
import 'package:resonate/features/live_audio/model/livekit_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/livekit_controller.g.dart';

// Data-layer controller for the app's single live audio session.
@Riverpod(keepAlive: true)
class LiveKitController extends _$LiveKitController {
  LiveKitSession? _session;
  StreamSubscription<bool>? _connectionSub;
  StreamSubscription<RoomEvent>? _eventsSub;

  StreamSubscription<SpeakerBands>? _bandsSub;

  final _speakerLevelsController =
      StreamController<Map<String, double>>.broadcast();
  final _speakerBandsController = StreamController<SpeakerBands>.broadcast();

  final _bandUids = <String>{};

  @override
  LiveKitState build() {
    ref.onDispose(_dispose);
    return const LiveKitState();
  }

  Stream<Map<String, double>> get speakerLevels =>
      _speakerLevelsController.stream;

  Stream<SpeakerBands> get speakerBands => _speakerBandsController.stream;

  Future<bool> connect({
    required String liveKitUri,
    required String roomToken,
    bool isLiveChapter = false,
  }) async {
    await _cleanup();

    final session = LiveKitSession(
      liveKitUri: liveKitUri,
      roomToken: roomToken,
      isLiveChapter: isLiveChapter,
    );
    _session = session;
    if (ref.mounted) state = state.copyWith(hasSession: true);

    _connectionSub = session.connectionStates.listen((connected) {
      if (ref.mounted) state = state.copyWith(isConnected: connected);
    });

    _eventsSub = session.events.listen((event) {
      if (event is RoomRecordingStatusChanged && ref.mounted) {
        state = state.copyWith(isRecording: event.activeRecording);
      } else if (event is ActiveSpeakersChangedEvent) {
        _emitSpeakerLevels(event.speakers);
      }
    });

    _bandsSub = session.speakerBands.listen((bands) {
      if (_speakerBandsController.isClosed) return;
      if (bands.bands.isEmpty) {
        _bandUids.remove(bands.uid);
      } else {
        _bandUids.add(bands.uid);
      }
      _speakerBandsController.add(bands);
    });

    final ok = await session.connect();
    if (!ok) {
      await _cleanup();
    }
    return ok;
  }

  Future<void> setMicrophoneEnabled(bool enabled) =>
      _session?.setMicrophoneEnabled(enabled) ?? Future.value();

  Future<void> setSpeakerphoneOn(bool enabled) =>
      Hardware.instance.setSpeakerphoneOn(enabled);

  Future<void> setRecording(bool recording) async {
    await _session?.setRecording(recording);
    state = state.copyWith(isRecording: recording);
  }

  Future<void> disconnect() => _cleanup();

  void _emitSpeakerLevels(List<Participant> speakers) {
    if (_speakerLevelsController.isClosed) return;
    _speakerLevelsController.add({
      for (final speaker in speakers)
        speaker.identity: speaker.audioLevel.clamp(0.0, 1.0),
    });
  }

  Future<void> _cleanup() async {
    await _connectionSub?.cancel();
    await _eventsSub?.cancel();
    await _bandsSub?.cancel();
    _connectionSub = null;
    _eventsSub = null;
    _bandsSub = null;
    await _session?.dispose();
    _session = null;

    _emitSpeakerLevels(const []);
    _clearSpeakerBands();
    if (ref.mounted) state = const LiveKitState();
  }

  void _clearSpeakerBands() {
    if (_speakerBandsController.isClosed) return;
    for (final uid in _bandUids) {
      _speakerBandsController.add((uid: uid, bands: const []));
    }
    _bandUids.clear();
  }

  Future<void> _dispose() async {
    await _cleanup();
    await _speakerLevelsController.close();
    await _speakerBandsController.close();
  }
}
