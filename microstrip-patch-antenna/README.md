# Microstrip Patch Antenna

Design and electromagnetic simulation of a rectangular inset-fed microstrip patch antenna in CST Microwave Studio on FR-4 substrate.

## Overview

This project covers the full design workflow of a microstrip patch antenna at 4.85 GHz:

- Analytical calculation of patch dimensions
- Feed point positioning for impedance matching
- CST-based geometry optimization
- Reflection coefficient (S11) analysis
- Input impedance verification using Smith chart
- 3D radiation pattern evaluation
- Polarization, directivity, gain and beamwidth analysis

## Design frequency
- 4.85 GHz

## Main results

- Patch width (W): 15.464 mm  
- Patch length (L): 15.062 mm  
- Feed position (x0): 4.686 mm  

- Minimum S11: -68.71 dB  
- Bandwidth (S11 < -10 dB): 199 MHz (~4.1%)  
- Input impedance at resonance: 71.048 + j0.004 Ω  

- Maximum directivity: 5.265 dBi  
- Maximum gain: 2.108 dB  
- Radiation efficiency: ~48%  
- Beamwidth (-3 dB): ~91° (E-plane), ~99° (H-plane)

## Main conclusions

- The antenna achieves excellent impedance matching close to the target 70 Ω.
- The obtained bandwidth (~4%) is consistent with typical microstrip patch behaviour.
- Radiation patterns and directivity values agree with theoretical expectations.
- The antenna exhibits linear polarization, with copolar component depending on the observation plane.

## Tools
- CST Microwave Studio