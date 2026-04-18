# Circularly Polarized Microstrip Patch Antenna (RHCP)

Design and simulation of a square microstrip patch antenna with right-hand circular polarization (RHCP) at 2.5 GHz using CST Studio Suite.

## Overview

This project focuses on the design of a circularly polarized antenna using dual-feed excitation with a 90° phase shift.

Two configurations were analyzed:

- Ideal design using discrete ports
- Realistic design including coaxial connectors and finite ground plane

## Design specifications

- Frequency: 2.5 GHz
- Substrate: εr = 2.33
- Height: 0.7 mm
- Patch size ≈ 38 mm

## Methodology

### 1. Analytical design

Initial dimensions obtained from closed-form expressions:

- Effective permittivity
- Patch length and width
- Fringing field correction
- Feed point for 50 Ω matching

### 2. Circular polarization generation

RHCP achieved by:

- Two orthogonal feeds
- Equal amplitude
- +90° phase shift

This creates two orthogonal modes with quadrature phase.

### 3. CST simulation

#### Design 1 (ideal)
- Infinite ground plane
- Discrete ports
- Excellent matching: S11 ≈ -43 dB

#### Design 2 (realistic)
- Finite ground plane
- Coaxial connectors
- Slight degradation: S11 ≈ -35 dB

## Results

### Impedance matching
- Zin ≈ 50 Ω at resonance
- Narrow bandwidth ≈ 13 MHz (~0.5%)

### Radiation

- Broadside radiation
- Directivity ≈ 7 dBi (ideal)
- Slight reduction with real feeding

### Circular polarization

- Axial Ratio (AR) ≈ 0 dB at broadside (ideal)
- AR ≈ 0.7 dB with connectors

- AR < 3 dB for |θ| < 60°

## Key insights

- Dual-feed excitation enables high-quality circular polarization
- Real feeding structures introduce asymmetries and coupling
- Finite ground planes affect radiation and polarization purity
- Patch antennas inherently have narrow bandwidth

## Tools
- CST Studio Suite