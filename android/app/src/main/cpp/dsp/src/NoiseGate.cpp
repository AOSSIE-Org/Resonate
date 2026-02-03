#include "NoiseGate.h"

void NoiseGate::prepare(double sampleRate, int blockSize) {
  currentSampleRate = sampleRate;

  juce::dsp::ProcessSpec spec;
  spec.sampleRate = sampleRate;
  spec.maximumBlockSize = static_cast<juce::uint32>(blockSize);
  spec.numChannels = 1;

  gate.prepare(spec);
  gate.setThreshold(threshold.load());
  gate.setRatio(ratio.load());
  gate.setAttack(attack.load());
  gate.setRelease(release.load());
}

void NoiseGate::process(juce::AudioBuffer<float> &buffer) {
  // Update parameters (thread-safe reads)
  gate.setThreshold(threshold.load());
  gate.setRatio(ratio.load());
  gate.setAttack(attack.load());
  gate.setRelease(release.load());

  juce::dsp::AudioBlock<float> block(buffer);
  juce::dsp::ProcessContextReplacing<float> context(block);
  gate.process(context);
}

void NoiseGate::reset() { gate.reset(); }

void NoiseGate::setThreshold(float thresholdDb) {
  threshold.store(thresholdDb);
}

void NoiseGate::setRatio(float newRatio) {
  ratio.store(juce::jmax(1.0f, newRatio));
}

void NoiseGate::setAttack(float attackMs) {
  attack.store(juce::jmax(0.1f, attackMs));
}

void NoiseGate::setRelease(float releaseMs) {
  release.store(juce::jmax(1.0f, releaseMs));
}
