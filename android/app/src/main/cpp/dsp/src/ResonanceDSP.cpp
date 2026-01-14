#include "ResonanceDSP.h"

void ResonanceDSP::prepare(double sampleRate, int blockSize)
{
    juce::dsp::ProcessSpec spec;
    spec.sampleRate = sampleRate;
    spec.maximumBlockSize = static_cast<juce::uint32>(blockSize);
    spec.numChannels = 1; // mono for now

    gainProcessor.prepare(spec);
    gainProcessor.setGainLinear(gain.load());
}

void ResonanceDSP::process(juce::AudioBuffer<float> &buffer)
{
    if (bypass.load())
        return;

    gainProcessor.setGainLinear(gain.load());

    juce::dsp::AudioBlock<float> block(buffer);
    juce::dsp::ProcessContextReplacing<float> context(block);

    gainProcessor.process(context);
}

void ResonanceDSP::reset()
{
    gainProcessor.reset();
}

void ResonanceDSP::setGain(float newGain)
{
    gain.store(newGain);
}

void ResonanceDSP::setBypass(bool shouldBypass)
{
    bypass.store(shouldBypass);
}