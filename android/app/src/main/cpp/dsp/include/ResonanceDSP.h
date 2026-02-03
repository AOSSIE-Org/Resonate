#pragma once

#include <juce_audio_basics/juce_audio_basics.h>
#include <juce_dsp/juce_dsp.h>
#include <atomic>

class ResonanceDSP
{
public:
    ResonanceDSP() = default;

    void prepare(double sampleRate, int blockSize);
    void process(juce::AudioBuffer<float> &buffer);
    void reset();

    void setGain(float newGain);
    void setBypass(bool shouldBypass);

private:
    std::atomic<float> gain{1.0f};
    std::atomic<bool> bypass{false};

    juce::dsp::Gain<float> gainProcessor;
};