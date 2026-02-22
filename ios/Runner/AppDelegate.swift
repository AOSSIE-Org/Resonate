import UIKit
import Flutter
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {

  private let voiceControlChannelName = "voice_control_channel"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    GeneratedPluginRegistrant.register(with: self)

    // ── Voice control channel ────────────────────────────────────────────────
    guard let controller = window?.rootViewController as? FlutterViewController else {
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    let voiceChannel = FlutterMethodChannel(
      name: voiceControlChannelName,
      binaryMessenger: controller.binaryMessenger
    )

    voiceChannel.setMethodCallHandler { [weak self] call, result in
      switch call.method {
      case "setVoiceProfile":
        guard
          let args = call.arguments as? [String: Any],
          let selectedVoice = args["selectedVoice"] as? String
        else {
          result(FlutterError(
            code: "INVALID_ARGUMENT",
            message: "selectedVoice must not be nil",
            details: nil
          ))
          return
        }
        self?.applyVoiceProfile(selectedVoice)
        result(nil)

      case "setPreviewEnabled":
        guard
          let args = call.arguments as? [String: Any],
          let isPreviewEnabled = args["isPreviewEnabled"] as? Bool
        else {
          result(FlutterError(
            code: "INVALID_ARGUMENT",
            message: "isPreviewEnabled must not be nil",
            details: nil
          ))
          return
        }
        self?.setVoicePreviewEnabled(isPreviewEnabled)
        result(nil)

      default:
        result(FlutterMethodNotImplemented)
      }
    }
    // ────────────────────────────────────────────────────────────────────────

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// Apply the selected voice profile in the native audio processing layer.
  /// Replace the print with real AVAudioEngine / DSP calls.
  private func applyVoiceProfile(_ profile: String) {
    // TODO: forward to native audio engine
    print("VoiceControl: voice profile set: \(profile)")
  }

  /// Start or stop audio preview in the native audio processing layer.
  /// Replace the print with real AVAudioEngine / DSP calls.
  private func setVoicePreviewEnabled(_ enabled: Bool) {
    // TODO: forward to native audio engine
    print("VoiceControl: preview enabled: \(enabled)")
  }
}
