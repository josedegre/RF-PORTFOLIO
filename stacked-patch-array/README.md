# 4-Element Stacked Patch Antenna Array with Feeding Network

Design, simulation, fabrication, and measurement of a 4-element microstrip patch antenna array at 4.7 GHz.

## Overview

This project covers the full RF design chain:

- Radiating element design (stacked patch)
- Array synthesis and beam steering
- Feeding network design in microstrip (ADS)
- Full-wave EM simulation (CST)
- Prototype fabrication and anechoic chamber measurements

## Specifications

- Frequency: 4.7 GHz
- Bandwidth: > 10%
- Target directivity: > 12 dBi
- Beam steering: 5°
- Polarization: Linear (x-axis)

## Radiating Element

Stacked patch configuration used to enhance bandwidth:

- Substrate: FR4
- Dual resonance behavior
- Achieved bandwidth: ~23%

## Array Design

### Geometry
- Linear array (4 elements)
- Spacing: 0.7λ

### Beam steering

Progressive phase applied:

α = -k₀ d sin(θ₀)

### Amplitude distributions

Two configurations analyzed:

#### 1. Uniform
- Maximum directivity (~14.5 dBi)
- SLL ≈ -13 dB

#### 2. Binomial
- Reduced sidelobes (< -15 dB)
- Lower directivity

## Feeding Network (ADS)

- Microstrip implementation
- T-junction power dividers
- Double λ/4 impedance transformers
- Designed for wideband matching (< -25 dB)

## Integration Effects

- Mutual coupling analyzed (Sij ≈ -25 dB worst case)
- Ground plane impact evaluated (finite vs infinite)
- Bandwidth increase after integration (~37%)

## Measurements

Prototype fabricated and measured in anechoic chamber:

- S11 matches simulation closely
- Beam steering error ≈ 1°
- Directivity error ≈ 0.1 dB

## Key Engineering Insights

- Bandwidth defined by radiation, not only S11
- Feeding network strongly affects beam steering
- Mutual coupling must be considered in arrays
- Real materials (FR4, copper) degrade performance vs simulation

## Tools

- CST Studio Suite
- Keysight ADS
- MATLAB (post-processing)