# Dipole and Monopole Antenna Design

Design and electromagnetic simulation of wire antennas in CST Microwave Studio, including a resonant dipole and a monopole over an infinite ground plane.

## Overview

This project studies two classical wire antennas at 2.5 GHz:

- Resonant dipole
- Monopole over infinite ground plane

The work includes:
- Initial theoretical sizing
- Geometry optimization
- Reflection coefficient analysis
- Input impedance from Smith chart
- 3D radiation pattern evaluation
- Polarization, directivity, gain and beamwidth analysis

## Design frequency
- 2.5 GHz

## Main results

### Dipole
- Optimized length: 53.33 mm
- Optimized diameter: 3.54 mm
- Input impedance at resonance: 73.213 + j0.078 Ω
- Relative bandwidth (S11 < -10 dB): 24%
- Maximum directivity at 2.5 GHz: 2.163 dBi

### Monopole
- Optimized length approximately equivalent to 0.2166λ including feed region
- Input impedance at resonance: 34.16 + j3.70 Ω
- Relative bandwidth (S11 < -10 dB): 26.88%
- Maximum directivity at 2.5 GHz: 5.113 dBi

## Main conclusions
- The optimized dipole closely matches the theoretical resonant impedance of 73 Ω.
- The monopole shows the expected behaviour predicted by image theory.
- Radiation patterns, polarization and beamwidth values are consistent with theoretical expectations.
- The monopole provides approximately 3 dB higher directivity than the dipole, as expected.

## Tools
- CST Microwave Studio
