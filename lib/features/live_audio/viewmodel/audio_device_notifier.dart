import 'dart:async';
import 'dart:developer';

import 'package:resonate/features/live_audio/data/services/audio_device_service.dart';
import 'package:resonate/features/live_audio/model/audio_device_state.dart';
import 'package:resonate/features/live_audio/model/audio_device.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/audio_device_notifier.g.dart';

@Riverpod(keepAlive: true)
AudioDeviceService audioDeviceService(Ref ref) => AudioDeviceService();

@Riverpod(keepAlive: true)
class AudioDeviceNotifier extends _$AudioDeviceNotifier {
  Timer? _refreshTimer;

  @override
  Future<AudioDeviceState> build() async {
    ref.onDispose(() => _refreshTimer?.cancel());
    final service = ref.read(audioDeviceServiceProvider);
    final devices = await service.enumerateOutputDevices();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _refresh(),
    );
    return AudioDeviceState(
      devices: devices,
      selected: devices.isEmpty ? null : devices.first,
    );
  }

  Future<void> _refresh() async {
    try {
      final service = ref.read(audioDeviceServiceProvider);
      final devices = await service.enumerateOutputDevices();
      if (!ref.mounted) return;
      final current = state.value;
      state = AsyncData(
        AudioDeviceState(
          devices: devices,
          selected: current?.selected ??
              (devices.isEmpty ? null : devices.first),
        ),
      );
    } catch (e) {
      log('audio device refresh failed: $e');
    }
  }

  Future<void> selectOutput(AudioDevice device) async {
    final service = ref.read(audioDeviceServiceProvider);
    await service.selectOutput(device);
    final current = state.value;
    if (current != null) {
      state = AsyncData(current.copyWith(selected: device));
    }
  }
}
