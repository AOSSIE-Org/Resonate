#include "Compressor.h"

void Compressor::prepare(double sampleRate, int blockSize) {
  currentSampleRate = sampleRate;

  juce::dsp::ProcessSpec spec;
  spec.sampleRate = sampleRate;
  spec.maximumBlockSize = static_cast<juce::uint32>(blockSize);
  spec.numChannels = 1;

  compressor.prepare(spec);
  compressor.setThreshold(threshold.load());
  compressor.setRatio(ratio.load());
  compressor.setAttack(attack.load());
  compressor.setRelease(release.load());
}

void Compressor::process(juce::AudioBuffer<float> &buffer) {
  // Update parameters (thread-safe reads)
  compressor.setThreshold(threshold.load());
  compressor.setRatio(ratio.load());
  compressor.setAttack(attack.load());
  compressor.setRelease(release.load());

  juce::dsp::AudioBlock<float> block(buffer);
  juce::dsp::ProcessContextReplacing<float> context(block);
  compressor.process(context);
}

void Compressor::reset() { compressor.reset(); }

void Compressor::setThreshold(float thresholdDb) {
  threshold.store(thresholdDb);
}

void Compressor::setRatio(float newRatio) {
  ratio.store(juce::jmax(1.0f, newRatio));
}

void Compressor::setAttack(float attackMs) {
  attack.store(juce::jmax(0.1f, attackMs));
}

void Compressor::setRelease(float releaseMs) {
  release.store(juce::jmax(1.0f, releaseMs));
}
