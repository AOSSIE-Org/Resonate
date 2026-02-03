#pragma once

#include <atomic>
#include <juce_audio_basics/juce_audio_basics.h>
#include <juce_dsp/juce_dsp.h>

class NoiseGate {
public:
  NoiseGate() = default;

  void prepare(double sampleRate, int blockSize);

  void process(juce::AudioBuffer<float> &buffer);
  void reset();

  void setThreshold(float thresholdDb);

  void setRatio(float ratio);

  void setAttack(float attackMs);

  void setRelease(float releaseMs);

private:
  juce::dsp::NoiseGate<float> gate;
  std::atomic<float> threshold{-40.0f};
  std::atomic<float> ratio{10.0f};
  std::atomic<float> attack{5.0f};
  std::atomic<float> release{50.0f};
  double currentSampleRate = 44100.0;
};
