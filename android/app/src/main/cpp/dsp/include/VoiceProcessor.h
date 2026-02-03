#pragma once

#include <juce_audio_basics/juce_audio_basics.h>
#include <juce_dsp/juce_dsp.h>

class VoiceProcessor {
public:
  void prepare(double sampleRate, int blockSize);
  void process(juce::AudioBuffer<float> &buffer);

  // Strength: 0.0 = off, 1.0 = strong anonymization
  void setAnonymizationStrength(float strength);

private:
  double sampleRate = 44100.0;
  float strength = 0.5f;

  // --- Pitch ---
  juce::dsp::DelayLine<float> pitchDelay{2048};

  // --- Formant shaping ---
  juce::dsp::IIR::Filter<float> lowFormant;
  juce::dsp::IIR::Filter<float> midFormant;
  juce::dsp::IIR::Filter<float> highFormant;

  // --- Spectral smoothing ---
  juce::dsp::IIR::Filter<float> smoothingFilter;

  void processPitch(juce::AudioBuffer<float> &buffer);
  void processFormants(juce::AudioBuffer<float> &buffer);
  void processSmoothing(juce::AudioBuffer<float> &buffer);
};