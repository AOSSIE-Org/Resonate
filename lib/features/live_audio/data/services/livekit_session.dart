import 'dart:async';
import 'package:resonate/utils/dev_log.dart';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resonate/features/live_audio/data/services/audio_band_tracker.dart';

class LiveKitSession {
  LiveKitSession({
    required this.liveKitUri,
    required this.roomToken,
    this.isLiveChapter = false,
    this.maxAttempts = 3,
    this.retryInterval = const Duration(seconds: 2),
  });

  final String liveKitUri;
  final String roomToken;
  final bool isLiveChapter;
  final int maxAttempts;
  final Duration retryInterval;

  Room? _room;
  EventsListener<RoomEvent>? _listener;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;

  AudioBandTracker? _bandTracker;
  StreamSubscription<SpeakerBands>? _bandTrackerSub;

  final _connectionStateController = StreamController<bool>.broadcast();
  final _eventsController = StreamController<RoomEvent>.broadcast();
  final _recordingController = StreamController<bool>.broadcast();
  final _bandsController = StreamController<SpeakerBands>.broadcast();
  final _mediaRecorder = MediaRecorder();

  bool _isConnected = false;
  bool _isRecording = false;
  bool _disposed = false;

  Room? get room => _room;
  bool get isConnected => _isConnected;
  bool get isRecording => _isRecording;
  Stream<bool> get connectionStates => _connectionStateController.stream;
  Stream<RoomEvent> get events => _eventsController.stream;

  Stream<SpeakerBands> get speakerBands => _bandsController.stream;

  Future<bool> connect({bool isReconnect = false}) async {
    if (_disposed) return false;
    if (!isReconnect) _reconnectAttempts = 0;

    while (_reconnectAttempts < maxAttempts) {
      Room? attempt;
      try {
        await _disposeBandTracker();
        attempt = Room(
          roomOptions: const RoomOptions(
            dynacast: false,
            adaptiveStream: false,
            defaultVideoPublishOptions: VideoPublishOptions(simulcast: false),
          ),
        );
        _room = attempt;
        _listener = attempt.createListener();

        await attempt.connect(
          liveKitUri,
          roomToken,
          connectOptions: const ConnectOptions(autoSubscribe: true),
        );
        await Future<void>.delayed(const Duration(milliseconds: 1000));

        _isConnected = true;
        _connectionStateController.add(true);
        _reconnectAttempts = 0;
        _startBandTracker(attempt);
        _setupEventListeners();
        if (isLiveChapter) _listenToRecordingChanges();
        return true;
      } catch (error) {
        _reconnectAttempts++;
        log(
          'LiveKit connect attempt $_reconnectAttempts/$maxAttempts failed: $error',
        );
        if (attempt != null) {
          try {
            await attempt.disconnect();
            await attempt.dispose();
          } catch (e) {
            log('LiveKit cleanup error: $e');
          }
        }
        if (_reconnectAttempts < maxAttempts) {
          await Future<void>.delayed(retryInterval);
        }
      }
    }

    _isConnected = false;
    _connectionStateController.add(false);
    return false;
  }

  Future<void> handleDisconnection() async {
    _isConnected = false;
    _connectionStateController.add(false);

    if (_reconnectAttempts < maxAttempts) {
      _reconnectAttempts++;
      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(retryInterval, () async {
        await connect(isReconnect: true);
      });
    }
  }

  void _setupEventListeners() {
    _listener
      ?..on<RoomDisconnectedEvent>((event) async {
        if (event.reason != null) {
          log('Room disconnected: ${event.reason}');
          _eventsController.add(event);
          await handleDisconnection();
        }
      })
      ..on<RoomMetadataChangedEvent>((event) {
        if (event.metadata == 'disconnected') {
          handleDisconnection();
        }
      })
      ..on<RoomRecordingStatusChanged>((event) {
        log('Recording status changed: ${event.activeRecording}');
        _eventsController.add(event);
      })
      ..on<ActiveSpeakersChangedEvent>((event) {
        _eventsController.add(event);
        _bandTracker?.syncSpeakers({
          for (final speaker in event.speakers) speaker.identity,
        });
      })
      // Keep the FFT warm for every live mic
      ..on<TrackSubscribedEvent>((_) => _syncLiveMics())
      ..on<TrackUnsubscribedEvent>((_) => _syncLiveMics())
      ..on<TrackPublishedEvent>((_) => _syncLiveMics())
      ..on<TrackUnpublishedEvent>((_) => _syncLiveMics())
      ..on<LocalTrackPublishedEvent>((_) => _syncLiveMics())
      ..on<TrackMutedEvent>((_) => _syncLiveMics())
      ..on<TrackUnmutedEvent>((_) => _syncLiveMics())
      ..on<ParticipantConnectedEvent>((_) => _syncLiveMics())
      ..on<ParticipantDisconnectedEvent>((_) => _syncLiveMics());
  }

  void _syncLiveMics() {
    final room = _room;
    final tracker = _bandTracker;
    if (room == null || tracker == null) return;

    final local = room.localParticipant;
    tracker.syncLiveMics({
      if (local != null && local.hasAudio && !local.isMuted) local.identity,
      for (final participant in room.remoteParticipants.values)
        if (participant.hasAudio && !participant.isMuted) participant.identity,
    });
  }

  void _listenToRecordingChanges() async {
    final storagePath = await getApplicationDocumentsDirectory();
    _recordingController.stream.listen((state) async {
      if (state) {
        await _mediaRecorder.start(
          '${storagePath.path}/recordings/${_room?.name}.mp4',
          audioChannel: RecorderAudioChannel.INPUT,
        );
      } else {
        await _mediaRecorder.stop();
      }
    });
  }

  void _startBandTracker(Room room) {
    final tracker = AudioBandTracker(room: room);
    _bandTracker = tracker;
    _bandTrackerSub = tracker.bands.listen((bands) {
      if (!_bandsController.isClosed) _bandsController.add(bands);
    });
    // Mics already live when we joined would otherwise stay cold until their
    // next mute/publish event.
    _syncLiveMics();
  }

  Future<void> _disposeBandTracker() async {
    await _bandTrackerSub?.cancel();
    _bandTrackerSub = null;
    await _bandTracker?.dispose();
    _bandTracker = null;
  }

  Future<void> setMicrophoneEnabled(bool enabled) async {
    await _room?.localParticipant?.setMicrophoneEnabled(enabled);
  }

  Future<void> setRecording(bool recording) async {
    _isRecording = recording;
    _recordingController.add(recording);
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _reconnectTimer?.cancel();
    try {
      await _disposeBandTracker();
      await _listener?.dispose();
      await _room?.dispose();
    } catch (e) {
      log('LiveKit dispose error: $e');
    }
    await _connectionStateController.close();
    await _eventsController.close();
    await _recordingController.close();
    await _bandsController.close();
  }
}
