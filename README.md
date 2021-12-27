# Monitoring of the Piggott Wind Turbine Generator (APSM)

Generator failures of the Piggott Wind Turbine can be detected by applying electrical signature analysis (ESA). In my Master thesis I deployed ESA to detect rotor deviation, which is a typical generator failure when the wheel bearing screw becomes loose.
The Full text of the Master Thesis is available on TU Vienna Library's website: [Link](
https://repositum.tuwien.at/bitstream/20.500.12708/18872/1/Kohler%20Kai-Burkhard%20-%202021%20-%20Analyse%20der%20Generatorspannung%20fuer%20das%20Monitoring...pdf)

Due to the fact, that the language of the master thesis is German I want to give a short summary in English and I want to provide the raw data and analysis scripts for further research.

This repository holds:
- Simulation of the deviated rotor with FEMM
- Measured raw Voltage Signal (open circuit terminal voltage)
- RMS Analysis
- Fourier Analysis
- Zero-Crossing Timing Analysis

The outcomes are:
- Rotor deviation is detectable by
  - RMS Voltage
  - harmonics
- the rotation angle can be derived from the voltage 

Thanks to Jonathan Schreiber for all the talks and technical support.