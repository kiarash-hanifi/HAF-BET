# HAF-BET Code
This repository contains all the code and data required to reproduce the results presented in the paper:
“Application of the Alinaghipour–Falamaki-BET Theory to Mesoporous Materials of Any Nature: Algorithm and Computational Code.”

The algorithms and computational framework were originally developed by Kiarash Hanifi and Cavus Falamaki.
The HAF-BET code can be run in both Octave and MATLAB to calculate the specific surface areas (SSA) and surface energy parameters of mesoporous materials.

## Inputs and Outputs 
Input:  desorption isotherm <br>
Outputs: specific surface area (SSA), surface energy parameter (C) 

## How to Run
1. Get a real desorption Isotherm (mesoporous material) with at least one pressure ratio data below 0.08 and one in the range of 0.08 to 1.6, and one larger than 0.965.
2. Save the desorption isotherm data in an Excel file like the Isotherm data presented in this repository (in the "Isotherm_Data" folder).
3. Choose the code suitable for your sample. The "HAF_BET_main_code.m" is for materials with concave curvature (porous materials like SBA-15, KIT-6, or MCM-48), while the "HAF_BET_convex_version.m" is for materials with convex curvature (dense materials like spherical or rod-like particles).
### In MATLAB
4. Run the code. The code will ask you to enter the desorption isotherm. First, open and close a hook ( [ ] ) in the command window. Copy the isotherm saved in the Excel file in step 2, and paste it in the middle of the hooks. Press Enter.

### In Octave
4. Run the code. The code will ask you to enter the desorption isotherm. 
