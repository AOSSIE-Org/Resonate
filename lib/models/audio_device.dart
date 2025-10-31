import 'package:flutter_webrtc/flutter_webrtc.dart';

class AudioDevice {
  final String deviceId;
  final String label;
  final String kind; // 'input' or 'output'
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

  factory AudioDevice.fromMap(Map<dynamic, dynamic> map) {
    return AudioDevice(
      deviceId: map['deviceId'] as String? ?? '',
      label: map['label'] as String? ?? 'Unknown Device',
      kind: map['kind'] as String? ?? '',
      groupId: map['groupId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'deviceId': deviceId,
      'label': label,
      'kind': kind,
      'groupId': groupId,
    };
  }

  bool get isAudioInput => kind == 'audioinput';
  bool get isAudioOutput => kind == 'audiooutput';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AudioDevice &&
        other.deviceId == deviceId &&
        other.kind == kind;
  }

  @override
  int get hashCode => deviceId.hashCode ^ kind.hashCode;

  @override
  String toString() {
    return 'AudioDevice(deviceId: $deviceId, label: $label, kind: $kind)';
  }
}
