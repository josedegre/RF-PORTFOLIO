# Reflectarray Antenna Design (Unit Cell + System Level)

Design and analysis of a reflectarray antenna system, including both unit cell electromagnetic modeling and full antenna synthesis.

## Overview

This project combines:

1. Full-wave EM simulation of a reflectarray unit cell in CST
2. System-level design of a reflectarray antenna

## Part 1: Unit Cell Design (CST)

- Aperture-coupled patch element
- 4-layer structure
- Microstrip-fed through slot coupling

### Key results:
- S11 < -20 dB at 10 GHz
- Transmission losses ≈ 0.13 dB
- Controlled phase shift via line length
- Low cross-polarization (< -40 dB)

### Analysis performed:
- Mode verification (TEM / quasi-TEM)
- Field distribution (Ex, Ey, Ez)
- Transmission vs reflection behavior
- Floquet analysis

## Part 2: Reflectarray System Design

### Specifications:
- Frequency: 25 GHz
- Gain: ~24 dB
- f/D = 1
- Off-axis feed

### Key aspects:
- Phase distribution synthesis
- Illumination using cos^n(theta)
- Efficiency analysis (realistic ≈ 60–70%)
- Incidence angle effects

### Results:
- Gain ≈ 24 dB
- Efficiency ≈ 70%
- Good agreement with ideal model

## Key Engineering Insights

- Phase control via microstrip length enables reflectarray synthesis
- Incidence angle significantly affects phase response
- Single phase curve introduces design errors
- Illumination taper strongly impacts efficiency

## Tools

- CST Studio Suite (unit cell EM simulation)
- Reflectarray Design Manager (system synthesis)