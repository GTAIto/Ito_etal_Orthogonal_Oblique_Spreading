%==========================================================================
% Stress analysis
% xmaxsxx_log:  actual interpolate peak sxx_eff
% xcent_log:  where the new center is placed (limited by 0.5 dx)
% x_maxsxx:  location of peak stress computed by Smooth_stot_Pmag_fr_log
% ycent_log:  ycoords of all dynamic dikes
% xcentold:  previous center
%==========================================================================
%iprof=find(abs(xc-xprof)==min(abs(xc-xprof)),1);
%clear;
clear;
!cd LaMEM_Input_Files_Output_Folders
magPwidth=1000;
showfig=1;
show_dike_hist=1;
plot_indiv_profs=0;

zmax_magma=-10;
drhomagma=0;
g=9.8;
Tsol=600;
Tsol=1000;
%Tsol=900;
ymax=6.25;
yprof00=[1:0.5:ymax];cd 
dikehalfwidth=0.75;
ylim1=1e6;
ylim2=-1e6;
sdiff_ave=0;
xL=-2; xR=2;
%xL=-1.5; xR=1.5;  <--this is consistent with definition of sigvar
%xL=-3; xR=3;
xTF=14; yTF=1;
dw=1.5;  %Dike width
xwin=6*dw;

magPfac=1;
zsol_max=-20;


%fname=['sxx_results_Tsol' num2str(Tsol) '.txt'];
!/bin/rm sxx_results.txt
%pwd
fidout=fopen('sxx_results_LTF.txt','w');
fig1='30'; fig2='20';  

dtave0=0.5; %time over which to evaluate mean slope. Other numbers are start times for dynamic diking
TFlength_measure_rate=15;



iwhich='TFlength';


for imod=1:6
    istep=310;
    dtstart=0;
    if (imod==1)     
       fig2='5'; cd LaMEM_Input_Files_Output_Folders/L05nuk2Weak50/Wm1e3;  logdir='log'; mpw=1e3; dtave=0.4;
    elseif (imod==2)     
       fig2='15'; cd LaMEM_Input_Files_Output_Folders/L10nuk2Weak50/Wm1e3;  logdir='log'; mpw=1e3; dtave=0.3;
    elseif (imod==3)
       istep=360;
       fig2='25'; cd LaMEM_Input_Files_Output_Folders/L20nuk2Weak50/Wm1e3;  logdir='log'; mpw=1e3;  dtave=0.7;
    elseif (imod==4)
        fig2='35'; fig2='37'; cd LaMEM_Input_Files_Output_Folders/L30Nu2Weak50/Wm1e3; logdir='log'; mpw=1e3;  dtave=0.45; 
    elseif (imod==5)
        fig1='40'; fig2='45'; cd LaMEM_Input_Files_Output_Folders/L40nuk2Weak50/Wm1e3;  logdir='log'; mpw=1e3; dtave=0.45;
    elseif (imod==5)
        fig1='50'; fig2='55'; cd LaMEM_Input_Files_Output_Folders/L50nuk2Weak50/Wm1e3;  logdir='log'; mpw=1e3; dtave=0.45; 
    end 
%--------------------------------------------------------------------------
% Parse model params
%--------------------------------------------------------------------------
    parse_model;
    disp(['mpw=',num2str(mpw)]);
    
    beenhere=0;
    disp(['=============Model: ' model '==================']);
%--------------------------------------------------------------------------
    disp('Now calling Dikeloc_hist...')
    Dikeloc_hist_for_stress_anal;
    

%--------------------------------------------------------------------------
    for ndyndike=1:2
        if (ndyndike==2);  yprof0=yprof00; map_cbar_loc='north'; end;
        if (ndyndike==1);  yprof0=-yprof00; map_cbar_loc='south'; end; %for computing mean delta sxx
        dist_ave=2*dikehalfwidth;
        dist_find_peak=dikehalfwidth;

        % Gaussian_magpres=1;
        % magpresence_on=0;
        disp(['---- ndynDike #' num2str(ndyndike) ' ----']);
        read_dikecoords_fr_log;
        read_sxx_Pmag_fr_log;

        if (ndyndike==1)
            load dir_py_MatLAB/LaMEM_vtr_data.mat
            load dir_py_MatLAB/LaMEM_vtr_mesh.mat
            Nx=length(X_vec); Ny=length(Y_vec); Nz=length(Z_vec);
            x=X_vec; y=Y_vec; z=Z_vec;
            dx=x(2:Nx)-x(1:Nx-1); dz=[z(2:Nz)-z(1:Nz-1)]'; dy=y(2:Ny)-y(1:Ny-1);
            load dir_py_MatLAB/LaMEM_vts_topo.mat
            Plith=litho_press;
            [X Y]=meshgrid(x,y);
        end
        compute_lthick;

        xcc=[xL:0.01:xR];
        ilcc=(xcc<0);
        ircc=(xcc>0);

        Pmag=Pmag_filt_log; 
        sxx_eff=sxx_eff_filt_log; 
        sxx_tot=sxx_totave_filt_log;

        compute_sxx_Pmag;   
        fxx_eff=(sxx_tot_ave+Pmag_ave).*lthick;

        stress_force_analyze_cc; 

    end

    cd ../..
    pwd
    
    fprintf(fidout,'%4.2f %4.2f  %4.2f  %4.2f  %4.2f  %5.1f   %3.0f    %5.2f      %5.4f      %5.3f     %5.3f   %5.2f  %5.1f  %7.4f  %4.2f  %5.1f  %8.3f \n', outmean');
end
%TFlength_measure_rate
fclose(fidout);