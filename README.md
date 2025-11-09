# 🧮 HAF-BET Code

This repository contains all the code and data required to reproduce the results presented in the paper:
“Application of the Alinaghipour–Falamaki-BET Theory to Mesoporous Materials of Any Nature: Algorithm and Computational Code.”

The algorithms and computational framework were originally developed by Kiarash Hanifi and Cavus Falamaki.
The HAF-BET code can be run in both Octave and MATLAB to calculate the specific surface areas (SSA) and surface energy parameters of mesoporous materials.

## **Inputs and Outputs** 
Input:  desorption isotherm <br>
Outputs: specific surface area (SSA), surface energy parameter (C) 

## **How to Run**

1. **Prepare the Desorption Isotherm Data**  
   Obtain a **real desorption isotherm** of a mesoporous material.  
   Your data must include:  
   - at least **one pressure ratio** (`P/P₀`) **below 0.08**,  
   - at least one **within 0.08–0.16**, and  
   - at least one **above 0.965**.  

2. **Format the Data**  
   Save the desorption isotherm data in an Excel file named **`Isotherm.xlsx`**.  
   - You can use the provided **`Isotherm.xlsx`** file as a **template**.  
   - The file should contain two columns:  
     **(1)** relative pressure (`P/P₀`), and **(2)** adsorbed volume (cm³/g).  

3. **Select the Appropriate Code**  
   - For **porous materials** with **concave curvature** (e.g., *SBA-15*, *KIT-6*, *MCM-48*), use  
     **`HAF_BET_main_code.m`**.  
   - For **dense materials** with **convex curvature** (e.g., *spherical* or *rod-like* particles), use  
     **`HAF_BET_convex_version.m`**.  

4. **Place Files Correctly**  
   Inside the **`Codes`** folder, navigate to either the **`MATLAB`** or **`Octave`** subfolder (depending on your software) and download the `.m` code file.  
   Save your **`Isotherm.xlsx`** file **in the same directory** as the selected `.m` code file.  

5. **Run the Code**  
   - Open the desired version of the code in **MATLAB** or **GNU Octave**.  
   - Execute the script.  
   - The code will automatically read the input file, process the data, and output the **HAF-BET specific surface area (SSA)** and **surface energy parameter (C)**.


## **Notes**
Please note that the code is based on using Nitrogen as an adsorbate at 77 K, and the physical properties of Nitrogen are specified at the beginning of the code. If any other gas is used, such as argon, the physical properties and temperature should be tailored to the experimental conditions of the isotherm derivation.




