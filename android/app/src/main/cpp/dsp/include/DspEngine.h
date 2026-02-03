#pragma once

#include "Compressor.h"
#include "NoiseGate.h"
#include "ResonanceDSP.h"
#include "VoiceProcessor.h"
#include "VoiceProfile.h"
#include <atomic>
#include <juce_audio_basics/juce_audio_basics.h>
#include <juce_dsp/juce_dsp.h>

class DspEngine {
public:
  DspEngine() = default;

  void prepare(double sampleRate, int blockSize);

  void process(juce::AudioBuffer<float> &buffer);

  void reset();

  void setVoiceProfile(VoiceProfile profile);

  VoiceProfile getVoiceProfile() const;
  void setOutputGain(float gainDb);

  void setBypass(bool shouldBypass);

  bool isBypassed() const;

  void setNoiseGateEnabled(bool enabled);
  void setCompressorEnabled(bool enabled);
  void setAnonymizationStrength(float strength);

private:
  // Processing modules
  NoiseGate noiseGate;
  VoiceProcessor voiceProcessor;
  Compressor compressor;
  ResonanceDSP outputStage;

  // State
  std::atomic<VoiceProfile> currentProfile{VoiceProfile::Natural};
  std::atomic<bool> bypass{false};
  std::atomic<bool> noiseGateEnabled{true};
  std::atomic<bool> compressorEnabled{true};

  double sampleRate = 44100.0;
  int maxBlockSize = 512;

  void applyProfileConfig(const VoiceProfileConfig &config);
};
