#pragma once

#include "VoiceProfile.h"

struct DspParameters {
  // Overall controls
  float gain = 1.0f;
  bool bypass = false;

  // Voice profile
  VoiceProfile voiceProfile = VoiceProfile::Natural;

  // Individual effect enables
  bool noiseGateEnabled = true;
  bool compressorEnabled = true;
  bool voiceProcessorEnabled = true;

  // Custom overrides (when not using preset)
  float customAnonymizationStrength = 0.0f;
  float customPitchShiftSemitones = 0.0f;

  // Compressor overrides
  float compressorThresholdDb = -10.0f;
  float compressorRatio = 2.0f;

  // Noise gate overrides
  float noiseGateThresholdDb = -40.0f;
  float noiseGateRatio = 10.0f;
};