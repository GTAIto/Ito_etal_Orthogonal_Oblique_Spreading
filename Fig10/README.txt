--------------------------------------------------------------------------
MATLAB *.m files
--------------------------------------------------------------------------

First run "stress_analyze_cell_multiplemods.m" to compute statistics.  Note
that the paths of the various folders are given in the file so the user will
need to change those appropriately to point to the location of the model
output

Fig10_vary_LTF.m will then produce Fig. 10    

---------------------------------------------------------------------------
LaMEM Models:
LaMEM_Input_Files_Output_Folders/L05Nu2Weak50 (L=5 km, Nu=2, TF and FZ friction angle weakened by 50%):
    Running LaMEM in this directory using "input.dat" will integrate for 300 timestep
    with the ridge segments held fixed.  Copy "restart" to the following folder.
    Wm1e3 (wm=1e3 km):
        Running LaMEM -mode restart here will integrate over a few hundred steps for when the ridge
        segments dynamically relocate

Do the same for the other 3D models:
LaMEM_Input_Files_Output_Folders/L10Nu2Weak50
LaMEM_Input_Files_Output_Folders/L20Nu2Weak50 
LaMEM_Input_Files_Output_Folders/L30Nu2Weak50 
LaMEM_Input_Files_Output_Folders/L40Nu2Weak50 
LaMEM_Input_Files_Output_Folders/L50Nu2Weak50 




