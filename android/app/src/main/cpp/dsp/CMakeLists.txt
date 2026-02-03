cmake_minimum_required(VERSION 3.18)

project(resonance_dsp LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# JUCE
set(JUCE_ROOT ${CMAKE_CURRENT_LIST_DIR}/juce)
add_subdirectory(${JUCE_ROOT})

# DSP sources
file(GLOB DSP_SOURCES
    ${CMAKE_CURRENT_LIST_DIR}/src/*.cpp
)

file(GLOB DSP_HEADERS
    ${CMAKE_CURRENT_LIST_DIR}/include/*.h
)

# Build DSP as static library
add_library(resonance_dsp STATIC
    ${DSP_SOURCES}
    ${DSP_HEADERS}
)

# Include paths
target_include_directories(resonance_dsp
    PUBLIC
        ${CMAKE_CURRENT_LIST_DIR}/include
)

# Link required JUCE modules ONLY
target_link_libraries(resonance_dsp
    PRIVATE
        juce::juce_core
        juce::juce_audio_basics
        juce::juce_dsp
)

# Android / performance flags
target_compile_definitions(resonance_dsp
    PRIVATE
        JUCE_DISABLE_ASSERTIONS=1
        JUCE_WEB_BROWSER=0
        JUCE_USE_CURL=0
)

target_compile_options(resonance_dsp
    PRIVATE
        -ffast-math
        -fno-exceptions
        -fno-rtti
)