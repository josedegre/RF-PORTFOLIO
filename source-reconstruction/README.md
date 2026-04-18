# Phased Array Analysis and Source Reconstruction

Advanced analysis of planar phased arrays including beamforming, tapering techniques, failure analysis, and electromagnetic source reconstruction.

## Overview

This project implements a full analytical and numerical framework for phased array antennas:

- Array factor modeling in u–v domain
- Beam steering via phase gradients
- Amplitude tapering techniques
- Failure analysis
- Source reconstruction from far-field patterns

## System Design

- Frequency: 30 GHz
- Array: 11 × 11 elements
- Spacing: λ/2
- Directivity: ~25 dBi

## Key Features

### Array Modeling
- Element pattern: cos²(θ)
- Full radiation pattern synthesis

### Beam Steering
- Steering in arbitrary directions (θ, φ)
- Phase gradient implementation

### Amplitude Tapering
- Triangular
- Binomial
- Taylor (-25 dB)

Trade-offs analyzed:
- Sidelobe level vs beamwidth vs gain

### Failure Analysis
- Single element failure
- Row failure
- Impact on radiation pattern

### Source Reconstruction (Key Contribution)

Reconstruction of aperture fields from far-field radiation:

- Plane wave spectrum computation
- 2D FFT-based reconstruction
- Retrieval of amplitude and phase distributions

## Advanced Cases

- Reconstruction of CST-based array (stacked patch)
- Reconstruction of Cassegrain reflector aperture
- Detection of element failures from far-field data

## Key Insights

- Far-field patterns contain sufficient information to reconstruct aperture fields
- Phase gradients directly control beam steering
- Amplitude tapering reduces sidelobes at the cost of gain
- Source reconstruction enables array diagnostics

## Tools

- MATLAB
- CST Studio Suite (data source)