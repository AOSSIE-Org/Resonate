#pragma once
#include <juce_audio_basics/juce_audio_basics.h>

class VoiceProcessor
{
public:
    void process(juce::AudioBuffer<float> &buffer);
};