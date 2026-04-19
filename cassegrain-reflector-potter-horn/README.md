# Cassegrain Reflector Antenna with Potter Horn Feed (10 GHz)

Design and simulation of a high-gain Cassegrain reflector antenna system fed by a Potter horn.

## Overview

This project covers the full electromagnetic design of a high-directivity antenna system:

- Potter horn design (mode conversion to HE11)
- Modal analysis in circular waveguides
- Phase and amplitude control
- Cassegrain reflector synthesis
- Full-wave EM simulation in CST

## Specifications

- Frequency: 10 GHz
- Bandwidth: 9.75 – 10.25 GHz
- Target directivity: 40 dBi
- Polarization: Linear

## Potter Horn Design

- Hybrid mode HE11 generation
- TE11 / TM11 power ratio: ~ -7.5 dB
- Phase alignment across sections
- Optimized aperture field distribution

### Key results:
- Directivity: ~17.8 dBi
- Cross-polarization: < -30 dB
- Beamwidth: ~45°

## Cassegrain Reflector Design

### Geometry:
- Main reflector diameter: 1.305 m
- Focal length: 0.80 m
- Subreflector: hyperbolic

### Design considerations:
- Edge illumination: -20 dB
- Spillover efficiency
- Aperture efficiency
- Blockage effects

## Results

- Directivity: ~39.9 dBi
- Efficiency: ~93%
- Close agreement with theoretical models

## Key Engineering Insights

- Mode purity strongly affects reflector performance
- Edge illumination defines efficiency vs sidelobes trade-off
- Real systems deviate from theory due to spillover and blockage
- Accurate phase center positioning is critical

## Tools

- CST Studio Suite (full-wave EM)
- Analytical EM design methods