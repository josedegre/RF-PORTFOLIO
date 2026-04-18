# PIN Diode Loaded-Line Phase Shifter

Design and analysis of a loaded-line phase shifter based on PIN diodes, targeting a phase shift of 39° at 2.3 GHz.

## Overview

This project studies the progressive design of a loaded-line phase shifter using PIN diodes from ideal models to realistic packaged-device implementations.

The design process includes:
- Ideal transmission-line model
- Simplified diode model
- Equivalent circuit from datasheet
- Packaged-diode parasitic effects
- Redesign with full package model
- Feasibility analysis using dual-diode integrated packages

## Design targets
- Central frequency: 2.3 GHz
- Target phase shift: 39°
- Phase tolerance: ±3°
- Maximum insertion loss: 0.1 dB

## Main work carried out
- Synthesis of the ideal loaded-line phase shifter
- Compensation of reverse-bias parasitic capacitance
- Evaluation of PIN diode bias current effects
- Comparison of SOT-23 and SOT-323 package models
- Compensation of package parasitics using lumped elements
- Analysis of dual-diode integrated package solutions

## Main conclusions
- A forward bias current of 10 mA is required to satisfy both insertion loss and phase-shift specifications.
- Package parasitics have a strong impact on the phase response and bandwidth.
- For single-diode packaging, SOT-23 provides slightly better bandwidth after compensation.
- For dual-diode integrated packages, SOT-323 provides the best bandwidth after compensation.

## Tools
- Keysight ADS