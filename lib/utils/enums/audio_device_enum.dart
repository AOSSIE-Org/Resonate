enum AudioDeviceType {
  phone('phone', 'Phone Earpiece'),
  bluetoothAudio('bluetooth_audio', 'Bluetooth'),
  headset('headset', 'Wired Headset'),
  speaker('speaker', 'Loudspeaker'),
  usb('volume_up', 'USB Audio'),
  unknown('volume_up', 'Unknown Device');

  final String iconName;
  final String displayName;

  const AudioDeviceType(this.iconName, this.displayName);

  static AudioDeviceType fromLabel(String label) {
    final lowerLabel = label.toLowerCase();

    if (lowerLabel.contains('bluetooth') || lowerLabel.contains('bt')) {
      return AudioDeviceType.bluetoothAudio;
    } else if (lowerLabel.contains('earpiece') ||
        lowerLabel.contains('receiver')) {
      return AudioDeviceType.phone;
    } else if (lowerLabel.contains('wired') ||
        lowerLabel.contains('headset') ||
        lowerLabel.contains('headphone')) {
      return AudioDeviceType.headset;
    } else if (lowerLabel.contains('speaker')) {
      return AudioDeviceType.speaker;
    } else if (lowerLabel.contains('usb')) {
      return AudioDeviceType.usb;
    }

    return AudioDeviceType.unknown;
  }
}
