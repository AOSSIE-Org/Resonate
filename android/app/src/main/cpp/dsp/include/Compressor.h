#pragma once

#include <atomic>
#include <juce_audio_basics/juce_audio_basics.h>
#include <juce_dsp/juce_dsp.h>

class Compressor {
public:
  Compressor() = default;

  void prepare(double sampleRate, int blockSize);

  void process(juce::AudioBuffer<float> &buffer);

  void reset();

  void setThreshold(float thresholdDb);

  void setRatio(float ratio);

  void setAttack(float attackMs);

  void setRelease(float releaseMs);

private:
  juce::dsp::Compressor<float> compressor;
  std::atomic<float> threshold{-10.0f};
  std::atomic<float> ratio{2.0f};
  std::atomic<float> attack{10.0f};
  std::atomic<float> release{100.0f};
  double currentSampleRate = 44100.0;
};
