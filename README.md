# Monitoring of the Piggott APSM Wind Turbine Generator

Generator failures of the Piggott Wind Turbine can be detected by applying Electrical Signature Analysis (ESA). In my Master thesis I deployed ESA to detect [rotor deviation](./RotorDeviation.md), which is a typical generator failure when the wheel bearing screw becomes loose.
The full text of the master thesis is available on the TU Vienna Library's website: [Link](
https://repositum.tuwien.at/bitstream/20.500.12708/18872/1/Kohler%20Kai-Burkhard%20-%202021%20-%20Analyse%20der%20Generatorspannung%20fuer%20das%20Monitoring...pdf)

Due to the fact, that the language of the master thesis is German I want to give a short summary in English and I want to provide the raw data and analysis scripts for further research.

This repository holds:
- [Simulation of the deviated rotor with FEMM](./FEMM_Simulation.md)
- Measured Oscillograms (open circuit terminal voltage) and the description of the [testbench](./Testbench.md)
- [Voltage RMS and Fourier Analysis](./VoltageAnalysis.md)
- [Voltage Zero-Crossing Time Analysis](./VoltageAnalysis.md)
- [Magnetic Stray Field Analysis](./Magnetic_Stray_Field_Analysis.md)

The outcomes are:
- Rotor deviation is detectable by
  - RMS Voltage
  - Voltage harmonics
  - Magnetic Stray Field Analysis
- the rotation angle can be derived from the voltage Zero-Crossing Times

Many thanks to [Jonathan Schreiber](https://pureselfmade.com/) for all the talks and technical support.