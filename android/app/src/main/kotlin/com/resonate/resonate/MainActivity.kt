package com.resonate.resonate

import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channelName = "voice_control_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "setVoiceProfile" -> {
                    val selectedVoice = call.argument<String>("selectedVoice")
                    if (selectedVoice != null) {
                        applyVoiceProfile(selectedVoice)
                        result.success(null)
                    } else {
                        result.error(
                            "INVALID_ARGUMENT",
                            "selectedVoice must not be null",
                            null
                        )
                    }
                }
                "setPreviewEnabled" -> {
                    val isPreviewEnabled = call.argument<Boolean>("isPreviewEnabled")
                    if (isPreviewEnabled != null) {
                        setVoicePreviewEnabled(isPreviewEnabled)
                        result.success(null)
                    } else {
                        result.error(
                            "INVALID_ARGUMENT",
                            "isPreviewEnabled must not be null",
                            null
                        )
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    /**
     * Apply the selected voice profile in the native audio processing layer.
     * Replace the log statement with real DSP / audio-engine calls.
     */
    private fun applyVoiceProfile(profile: String) {
        // TODO: forward to native audio engine
        Log.d("VoiceControl", "Voice profile set: $profile")
    }

    /**
     * Start or stop audio preview in the native audio processing layer.
     * Replace the log statement with real DSP / audio-engine calls.
     */
    private fun setVoicePreviewEnabled(enabled: Boolean) {
        // TODO: forward to native audio engine
        Log.d("VoiceControl", "Preview enabled: $enabled")
    }
}
