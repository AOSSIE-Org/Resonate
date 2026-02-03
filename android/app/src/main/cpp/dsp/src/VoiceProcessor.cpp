#include "VoiceProcessor.h"
#include <cmath>

void VoiceProcessor::prepare(double sr, int blockSize)
{
    sampleRate = sr;

    juce::dsp::ProcessSpec spec;
    spec.sampleRate = sampleRate;
    spec.maximumBlockSize = blockSize;
    spec.numChannels = 1;

    pitchDelay.prepare(spec);

    // Formant bands (speech-critical regions)
    lowFormant.state = juce::dsp::IIR::Coefficients<float>::makeBandPass(sampleRate, 600.0f, 0.8f);
    midFormant.state = juce::dsp::IIR::Coefficients<float>::makeBandPass(sampleRate, 1600.0f, 1.0f);
    highFormant.state = juce::dsp::IIR::Coefficients<float>::makeBandPass(sampleRate, 3200.0f, 1.2f);

    smoothingFilter.state =
        juce::dsp::IIR::Coefficients<float>::makeLowPass(sampleRate, 3800.0f);
}

void VoiceProcessor::setAnonymizationStrength(float s)
{
    strength = juce::jlimit(0.0f, 1.0f, s);
}

void VoiceProcessor::process(juce::AudioBuffer<float> &buffer)
{
    if (strength <= 0.01f)
        return;

    processPitch(buffer);
    processFormants(buffer);
    processSmoothing(buffer);
}

void VoiceProcessor::processPitch(juce::AudioBuffer<float> &buffer)
{
    const float semitoneShift = juce::jmap(strength, -4.0f, 4.0f);
    const float ratio = std::pow(2.0f, semitoneShift / 12.0f);

    auto *data = buffer.getWritePointer(0);
    const int n = buffer.getNumSamples();

    for (int i = 0; i < n; ++i)
    {
        pitchDelay.pushSample(0, data[i]);
        data[i] = pitchDelay.popSample(0, ratio);
    }
}

void VoiceProcessor::processFormants(juce::AudioBuffer<float> &buffer)
{
    juce::dsp::AudioBlock<float> block(buffer);
    juce::dsp::ProcessContextReplacing<float> ctx(block);

    lowFormant.process(ctx);
    midFormant.process(ctx);
    highFormant.process(ctx);

    auto *data = buffer.getWritePointer(0);
    for (int i = 0; i < buffer.getNumSamples(); ++i)
    {
        data[i] *= juce::jmap(strength, 0.9f, 0.6f);
    }
}

void VoiceProcessor::processSmoothing(juce::AudioBuffer<float> &buffer)
{
    juce::dsp::AudioBlock<float> block(buffer);
    juce::dsp::ProcessContextReplacing<float> ctx(block);
    smoothingFilter.process(ctx);
}