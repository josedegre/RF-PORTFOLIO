# LNA Design – Minimum Noise Figure Amplifier

Design, simulation and optimization of a low-noise RF amplifier at 2 GHz, focusing on achieving minimum noise figure while meeting gain specifications.

---

## 📡 Project Overview

This project consists of the complete design of a microwave amplifier using the MGF4921AM transistor, targeting:

- Gain: 16.3 dB
- Frequency: 2 GHz
- Minimum Noise Figure

The design flow includes:
- Unilateral approximation
- Bilateral design using S-parameters
- Non-linear simulation
- Microstrip implementation

---

## 🧪 Key Technical Work

### 1. Stability Analysis
- Evaluation using K-Δ and μ criteria
- Identification of conditional stability regions

### 2. Noise vs Gain Trade-off
- Design based on noise circles and gain circles
- Optimization of source and load impedances

### 3. Bilateral Design
- Full S-parameter modeling
- Determination of ΓS and ΓL
- Matching network synthesis using transmission lines and open stubs

### 4. Non-linear Analysis
- Bias point optimization
- Harmonic balance simulation
- 1 dB compression point determination

### 5. Microstrip Implementation
- Conversion to physical layout (FR4 substrate)
- LineCalc-based dimensioning
- Optimization considering losses

---

## 📊 Results

- Gain: ~16.3 dB
- Noise Figure: ~0.37 dB
- P1dB: ~ -3.4 dBm (input)

---
