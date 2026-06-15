import 'dart:async';

import 'package:livekit_client/livekit_client.dart';
import 'package:resonate/features/rooms/data/services/livekit_session.dart';
import 'package:resonate/features/rooms/model/livekit_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/livekit_notifier.g.dart';

@Riverpod(keepAlive: true)
class LiveKitNotifier extends _$LiveKitNotifier {
  LiveKitSession? _session;
  StreamSubscription<bool>? _connectionSub;
  StreamSubscription<RoomEvent>? _eventsSub;

  @override
  LiveKitState build() {
    ref.onDispose(_cleanup);
    return const LiveKitState();
  }

  LiveKitSession? get session => _session;
  Room? get currentRoom => _session?.room;

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
      }
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

  Future<void> _cleanup() async {
    await _connectionSub?.cancel();
    await _eventsSub?.cancel();
    _connectionSub = null;
    _eventsSub = null;
    await _session?.dispose();
    _session = null;
    if (ref.mounted) state = const LiveKitState();
  }
}
