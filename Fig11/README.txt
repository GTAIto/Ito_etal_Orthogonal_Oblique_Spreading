--------------------------------------------------------------------------
MATLAB *.m files
--------------------------------------------------------------------------

First run "stress_analyze_cell_multiplemods.m" to compute statistics.  Note
that the paths of the various folders are given in the file so the user will
need to change those appropriately to point to the location of the model
output

---------------------------------------------------------------------------
LaMEM Models:
LaMEM_Input_Files_Output_Folders/L30Nu2Weak00
(L=30 km, Nu=2, zero TF & FZ weakening):
    Running LaMEM in this directory using "input.dat" will integrate for 300 timestep
    with the ridge segments held fixed.

    Use "restart" in the following directories for the ridge segments to dynamically relocate 
    for different magma pressure widths
    Wm1e3 (wm=1e3 km):
    Wm0.375 (wm=0.375 km)
    Wm0.5 (wm=0.5 km)
    Wm0.75 (wm=0.75 km)
    Wm1.5 (wm=1.5 km)
    Wm4.5 (wm=4.5 km)

Do the same for the other 3D models:
LaMEM_Input_Files_Output_Folders/L30Nu2Weak25 (TF & FZ weakened by 25%)
LaMEM_Input_Files_Output_Folders/L30Nu2Weak50 (TF & FZ weakened by 50%)
LaMEM_Input_Files_Output_Folders/L30Nu2Weak75 (TF & FZ weakened by 75%)
LaMEM_Input_Files_Output_Folders/L30Nu2Weak90 (TF & FZ weakened by 90%)


