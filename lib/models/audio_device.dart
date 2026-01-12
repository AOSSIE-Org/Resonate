import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:resonate/utils/enums/audio_device_enum.dart';

class AudioDevice {
  final String deviceId;
  final String label;
  final String kind;
  final String groupId;
  final AudioDeviceType deviceType;

  AudioDevice({
    required this.deviceId,
    required this.label,
    required this.kind,
    required this.groupId,
    required this.deviceType,
  });

  factory AudioDevice.fromMediaDeviceInfo(MediaDeviceInfo deviceInfo) {
    final label = deviceInfo.label;
    return AudioDevice(
      deviceId: deviceInfo.deviceId,
      label: label,
      kind: deviceInfo.kind ?? '',
      groupId: deviceInfo.groupId ?? '',
      deviceType: AudioDeviceType.fromLabel(label),
    );
  }

  bool get isAudioOutput => kind == 'audiooutput';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AudioDevice && other.deviceId == deviceId;
  }

  @override
  int get hashCode => deviceId.hashCode;

  @override
  String toString() {
    return 'AudioDevice(deviceId: $deviceId, label: $label, kind: $kind)';
  }
}
