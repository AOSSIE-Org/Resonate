#pragma once

#include <cstdint>

enum class VoiceProfile : uint8_t {
  Natural = 0, // Default - minimal processing
  Deep,        // Lower pitch, fuller sound
  Bright,      // Higher pitch, enhanced clarity
  Anonymous,   // Privacy masking with pitch randomization
  Robot        // Robotic/synthetic effect
};

struct VoiceProfileConfig {
  // Pitch shifting (-12 to +12 semitones)
  float pitchShiftSemitones = 0.0f;

  // Formant preservation factor (0.0 = none, 1.0 = full preservation)
  float formantPreservation = 0.5f;

  // Anonymization strength (0.0 = off, 1.0 = maximum)
  float anonymizationStrength = 0.0f;

  // Compressor settings
  float compressorThresholdDb = -10.0f;
  float compressorRatio = 2.0f;
  float compressorAttackMs = 10.0f;
  float compressorReleaseMs = 100.0f;

  // Noise gate settings
  float noiseGateThresholdDb = -40.0f;
  float noiseGateRatio = 10.0f;

  // Output gain (linear)
  float outputGain = 1.0f;

  // Bandpass filter for robot effect (Hz)
  float bandpassLowFreq = 200.0f;
  float bandpassHighFreq = 4000.0f;
  bool useBandpass = false;
};

inline VoiceProfileConfig getVoiceProfileConfig(VoiceProfile profile) {
  VoiceProfileConfig config;

  switch (profile) {
  case VoiceProfile::Natural:
    config.pitchShiftSemitones = 0.0f;
    config.formantPreservation = 0.5f;
    config.anonymizationStrength = 0.0f;
    config.compressorThresholdDb = -12.0f;
    config.compressorRatio = 2.0f;
    config.outputGain = 1.0f;
    break;

  case VoiceProfile::Deep:
    config.pitchShiftSemitones = -4.0f;
    config.formantPreservation = 0.6f;
    config.anonymizationStrength = 0.0f;
    config.compressorThresholdDb = -10.0f;
    config.compressorRatio = 3.0f;
    config.outputGain = 1.1f;
    break;

  case VoiceProfile::Bright:
    config.pitchShiftSemitones = 2.0f;
    config.formantPreservation = 0.7f;
    config.anonymizationStrength = 0.0f;
    config.compressorThresholdDb = -12.0f;
    config.compressorRatio = 2.0f;
    config.outputGain = 1.0f;
    break;

  case VoiceProfile::Anonymous:
    config.pitchShiftSemitones = 4.0f; // Will be randomized
    config.formantPreservation = 0.3f;
    config.anonymizationStrength = 0.8f;
    config.compressorThresholdDb = -8.0f;
    config.compressorRatio = 4.0f;
    config.noiseGateThresholdDb = -35.0f;
    config.outputGain = 0.9f;
    break;

  case VoiceProfile::Robot:
    config.pitchShiftSemitones = 0.0f;
    config.formantPreservation = 0.2f;
    config.anonymizationStrength = 0.0f;
    config.compressorThresholdDb = -6.0f;
    config.compressorRatio = 6.0f;
    config.useBandpass = true;
    config.bandpassLowFreq = 300.0f;
    config.bandpassHighFreq = 3000.0f;
    config.outputGain = 1.0f;
    break;
  }

  return config;
}
