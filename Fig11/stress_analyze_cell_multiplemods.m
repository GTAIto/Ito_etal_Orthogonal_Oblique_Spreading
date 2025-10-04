%==========================================================================
% Stress analysis
%==========================================================================

clear;
!cd /home/mahi/gito/LaMEM_work/hd9g3v1 
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
fidout=fopen('sxx_results.txt','w');
fig1='30'; fig2='20';  

dtave=4.5; %time over which to evaluate mean slope. Other numbers are start times for dynamic diking
TFlength_measure_rate=15;

mpwstring=['mpw0375'; 'mpw075 '; 'mpw1.5 '; 'mpw4.5 '; 'mpw1e3 ';];
mpw0=[0.375 0.75 1.5 4.5 1e3];

for imod=1:4
    istep=310;
    dtstart=0;
    for kmpw=1:5
        mpwstr=mpwstring(kmpw,:);
        mpw=mpw0(kmpw);
        if (imod==1)
            fig1='10'; fig2='15';    eval(['cd /home/mahi/gito/LaMEM_work/hd9g3v1/T30nuk2wTF00FZ/' mpwstr ';']); logdir='log'; 
        elseif (imod==2)
            fig1='20'; fig2='25';    eval(['cd /home/mahi/gito/LaMEM_work/hd9g3v1/T30nuk2wTF25FZ/' mpwstr ';']);   logdir='log'; 
        elseif (imod==3)
            fig1='30'; fig2='35';    eval(['cd /home/mahi/gito/LaMEM_work/hd9g3v1/T30nuk2wTF50FZ/' mpwstr ';']);  logdir='log'; 
        elseif (imod==4)
            fig1='40'; fig2='45';    eval(['cd /home/mahi/gito/LaMEM_work/hd9g3v1/T30nuk2wTF75FZ/' mpwstr ';']);  logdir='log'; 
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
end

fclose(fidout);