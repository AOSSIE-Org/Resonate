import 'package:flutter_webrtc/flutter_webrtc.dart';

class AudioDevice {
  final String deviceId;
  final String label;
  final String kind;
  final String groupId;

  AudioDevice({
    required this.deviceId,
    required this.label,
    required this.kind,
    required this.groupId,
  });

  factory AudioDevice.fromMediaDeviceInfo(MediaDeviceInfo deviceInfo) {
    return AudioDevice(
      deviceId: deviceInfo.deviceId,
      label: deviceInfo.label,
      kind: deviceInfo.kind ?? '',
      groupId: deviceInfo.groupId ?? '',
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
