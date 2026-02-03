#include "DspEngine.h"

void DspEngine::prepare(double sr, int blockSize) {
  sampleRate = sr;
  maxBlockSize = blockSize;

  noiseGate.prepare(sampleRate, blockSize);
  voiceProcessor.prepare(sampleRate, blockSize);
  compressor.prepare(sampleRate, blockSize);
  outputStage.prepare(sampleRate, blockSize);

  // Apply default profile
  setVoiceProfile(VoiceProfile::Natural);
}

void DspEngine::process(juce::AudioBuffer<float> &buffer) {
  if (bypass.load())
    return;

  // DSP Chain: NoiseGate -> VoiceProcessor -> Compressor -> Output
  if (noiseGateEnabled.load()) {
    noiseGate.process(buffer);
  }

  voiceProcessor.process(buffer);

  if (compressorEnabled.load()) {
    compressor.process(buffer);
  }

  outputStage.process(buffer);
}

void DspEngine::reset() {
  noiseGate.reset();
  compressor.reset();
  outputStage.reset();
}

void DspEngine::setVoiceProfile(VoiceProfile profile) {
  currentProfile.store(profile);
  VoiceProfileConfig config = getVoiceProfileConfig(profile);
  applyProfileConfig(config);
}

VoiceProfile DspEngine::getVoiceProfile() const {
  return currentProfile.load();
}

void DspEngine::setOutputGain(float gainDb) {
  float linearGain = std::pow(10.0f, gainDb / 20.0f);
  outputStage.setGain(linearGain);
}

void DspEngine::setBypass(bool shouldBypass) { bypass.store(shouldBypass); }

bool DspEngine::isBypassed() const { return bypass.load(); }

void DspEngine::setNoiseGateEnabled(bool enabled) {
  noiseGateEnabled.store(enabled);
}

void DspEngine::setCompressorEnabled(bool enabled) {
  compressorEnabled.store(enabled);
}

void DspEngine::setAnonymizationStrength(float strength) {
  voiceProcessor.setAnonymizationStrength(strength);
}

void DspEngine::applyProfileConfig(const VoiceProfileConfig &config) {
  // Apply to VoiceProcessor
  voiceProcessor.setAnonymizationStrength(config.anonymizationStrength);

  // Apply to Compressor
  compressor.setThreshold(config.compressorThresholdDb);
  compressor.setRatio(config.compressorRatio);
  compressor.setAttack(config.compressorAttackMs);
  compressor.setRelease(config.compressorReleaseMs);

  // Apply to NoiseGate
  noiseGate.setThreshold(config.noiseGateThresholdDb);
  noiseGate.setRatio(config.noiseGateRatio);

  // Apply to output stage
  outputStage.setGain(config.outputGain);
}
