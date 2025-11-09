# HAF-BET Code
This repository contains all the code and data required to reproduce the results presented in the paper:
“Application of the Alinaghipour–Falamaki-BET Theory to Mesoporous Materials of Any Nature: Algorithm and Computational Code.”

The algorithms and computational framework were originally developed by Kiarash Hanifi and Cavus Falamaki.
The HAF-BET code can be run in both Octave and MATLAB to calculate the specific surface areas (SSA) and surface energy parameters of mesoporous materials.

## Inputs and Outputs 
Input:  desorption isotherm <br>
Outputs: specific surface area (SSA), surface energy parameter (C) 

## How to Run
1. Get a real desorption Isotherm (mesoporous material) with at least one pressure ratio data below 0.08, one in the range of 0.08 to 0.16, and one larger than 0.965.
2. Save the desorption isotherm data in an Excel file like "Isotherm.xlsx" in the "Codes" folder of this repository. You can use the "Isotherm.xlsx" as a template.
3. Choose the code suitable for your sample. The "HAF_BET_main_code.m" is for materials with concave curvature (porous materials like SBA-15, KIT-6, or MCM-48), while the "HAF_BET_convex_version.m" is for materials with convex curvature (dense materials like spherical or rod-like particles).
4. Save the "Isotherm.xlsx" in the same folder as the code is saved. 
5. Run the code. (based on using MATLAB or Octave choose the code from that folder)
