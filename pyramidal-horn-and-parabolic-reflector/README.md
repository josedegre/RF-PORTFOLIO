# Pyramidal Horn and Parabolic Reflector Antenna

Design and electromagnetic simulation of a high-frequency aperture antenna system, including an optimized pyramidal horn and a centered parabolic reflector in CST Microwave Studio.

## Overview

This project studies a complete high-gain antenna system at millimeter-wave frequencies:

- Design of an optimal pyramidal horn fed by a WR-28 waveguide
- Analytical optimization using aperture theory and phase error constraints
- MATLAB-based solution of horn dimensions
- CST simulation of horn performance
- Integration of the horn as a feed for a parabolic reflector
- High-gain reflector design and radiation analysis

## Design frequency
- 31.5 GHz

## Main results

### Pyramidal horn

- Aperture dimensions:
  - A = 42.794 mm  
  - B = 33.733 mm  
- Designed for ~20 dBi directivity  
- Bandwidth > 10% (wideband behaviour typical of horn antennas)
- Radiation efficiency: ~99.8%  
- Beamwidth:
  - E-plane: ~15°  
  - H-plane: ~17°  

### Parabolic reflector

- Reflector diameter: 303.5 mm  
- Focal length: 513.2 mm  
- Subtended angle: 16.82°  

- Maximum directivity: ~37.4 dBi  
- Gain: ~37 dB  
- Beamwidth:
  - E-plane: ~2.1°  
  - H-plane: ~2.0°  

- Total efficiency: ~95%  
- Global efficiency: ~60%

## Main conclusions

- The pyramidal horn achieves the expected wideband behaviour and high efficiency typical of waveguide-fed antennas.
- The reflector significantly increases directivity, reducing beamwidth from ~15° to ~2°.
- The final system demonstrates typical high-gain antenna behaviour used in radar and satellite applications.
- Polarization is preserved from the horn to the reflector, remaining linear.

## Tools
- CST Microwave Studio  
- MATLAB