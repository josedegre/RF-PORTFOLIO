# Gysel Power Combiner

## Description
Design and analysis of a 5-port Gysel power combiner operating at 2.5 GHz, including ideal transmission-line analysis, ADS/MATLAB validation and microstrip implementation.

## Project scope
This project covers:
- Analytical derivation of S-parameters at the design frequency
- Even/odd mode analysis using circuit symmetry
- Ideal transmission-line simulation in MATLAB
- Comparison of MATLAB and ADS results
- Evaluation under ideal and fault conditions
- Microstrip implementation on RO4350B substrate

## Specifications
- Central frequency: 2.5 GHz
- Technology: Microstrip
- Substrate: RO4350B
- Frequency sweep: 1.5–3.5 GHz

## Methodology
- Modal decomposition using even and odd excitations
- S-parameter derivation from transmission matrices
- Ideal circuit validation with ADS and MATLAB
- Analysis of power combining losses and isolation
- Microstrip layout implementation and performance evaluation

## Main results
- MATLAB and ADS show strong agreement for the modal and full-network responses
- The ideal Gysel combiner provides efficient power combining at the central frequency
- The design maintains good behaviour under imbalance/fault conditions
- The microstrip implementation preserves the expected combining performance with low loss around 2.5 GHz

## Tools
- MATLAB
- Keysight ADS