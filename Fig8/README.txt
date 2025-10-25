--------------------------------------------------------------------------
MATLAB *.m files
--------------------------------------------------------------------------

stress_analyze_cell_multiplemods.m:  Run this first to compute statistics

Fig8_vary_wTF.m produce panels a-c
Fig8_vary_wTF_stress_profiles produce panels d-e.
---------------------------------------------------------------------------
LaMEM Models:
LaMEM_Input_Files_Output_Folders/L30Nu2Weak00
(L=30 km, Nu=2, zero TF & FZ weakening):
     Running LaMEM in this directory using "input.dat" will integrate for 300 timestep
    with the ridge segments held fixed.  Copy "restart" to the following folder.
    Wm1e3 (wm=1e3 km):
        Running LaMEM -mode restart here will integrate over a few hundred steps for when the ridge
        segments dynamically relocate

Do the same for the other 3D models:
LaMEM_Input_Files_Output_Folders/L30Nu2Weak25 (TF & FZ weakened by 25%)
LaMEM_Input_Files_Output_Folders/L30Nu2Weak50 (TF & FZ weakened by 50%)
LaMEM_Input_Files_Output_Folders/L30Nu2Weak75 (TF & FZ weakened by 75%)
LaMEM_Input_Files_Output_Folders/L30Nu2Weak90 (TF & FZ weakened by 90%)


