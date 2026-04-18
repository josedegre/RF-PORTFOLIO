# Microstrip Patch Array Antenna: Design, Simulation and Measurement

End-to-end design, simulation, fabrication, and experimental characterization of a microstrip patch array antenna at 4.85 GHz.

## Overview

This project covers the full antenna engineering workflow:

- Analytical modeling of array radiation patterns using MATLAB
- Study of array factor and element pattern combination
- Design of linear patch arrays with different configurations
- CST electromagnetic simulations (ideal and full-wave)
- Integration with microstrip feeding network
- Fabrication of the antenna prototype
- Experimental validation in an anechoic chamber

## Design frequency
- 4.85 GHz

## Methodology

### 1. Theoretical modeling

The total radiated field is modeled as:

|E_total| = |E_element| · AF

- Element pattern approximated as cos(θ)
- Array factor implemented in MATLAB
- Parametric study:
  - Number of elements (N)
  - Element spacing (d)
  - Progressive phase (α)
  - Amplitude tapering

### 2. Case studies

Three configurations were analyzed:

#### Case 1 – High directivity array
- N = 36
- d = λ/2
- Uniform excitation
- Directivity ≈ 20 dBi
- Beamwidth ≈ 2.8°

#### Case 2 – Beam steering
- N = 8
- d = 0.75λ
- Steering angle ≈ 25°
- Appearance of grating lobes

#### Case 3 – Taylor tapering
- N = 8
- d = λ/2
- SLL ≈ -25 dB
- Trade-off: wider beamwidth

### 3. Full-wave simulation (CST)

- Real patch array modeled including mutual coupling
- Individual port excitation
- Improved accuracy vs analytical model

### 4. Feeding network integration

- Microstrip corporate feed network
- Full antenna simulated
- Bandwidth ≈ 550 MHz (~11.3%)

### 5. Fabrication and measurement

- Prototype manufactured and tested in anechoic chamber
- Measured S11 ≈ -17 dB at 4.85 GHz
- Measured bandwidth ≈ 480 MHz (~9.9%)

### 6. Results comparison

| Parameter | Simulation | Measurement |
|----------|------------|------------|
| Gain | ~7.2 dB | ~6.6 dB |
| Beamwidth | ~22° | ~19.5° |
| SLL | ~-11 dB | ~-10 dB |

## Key insights

- MATLAB provides accurate prediction of array behavior trends
- Mutual coupling significantly affects performance
- Feeding network introduces losses and phase errors
- Measurements validate the overall design methodology
- Small phase mismatches cause beam pointing errors (~1°)

## Tools
- MATLAB
- CST Microwave Studio
- VNA measurements
- Anechoic chamber testing