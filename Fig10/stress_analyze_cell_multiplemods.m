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

dtave0=0.5; %time over which to evaluate mean slope. Other numbers are start times for dynamic diking
TFlength_measure_rate=15;


iwhich=3;  %dhnorm
iwhich=4;  %TFlength
%iwhich=2; %dhnorm, 8 km
%iwhich='TFlength';
%iwhich='g4v1LT   ';
iwhich='dhnorm   ';
%iwhich='wTF';
iwhich='varyM   ';


for imod=2
    istep=310;
    dtstart=0;
if (sum(iwhich(1:3)=='wTF')==3)
    mpwstr='mpw1.5'; mpw=1.5; dtave=0.4;
    mpwstr='mpw1e3'; mpw=1e3; 
    mpwstr='mpw4.5'; mpw=4.5;
    if (imod==1)
        fig1='10'; fig2='15';    eval(['cd /home/mahi/gito/LaMEM_work/hd9g3v1/T30nuk2wTF00FZ/' mpwstr ';']); logdir='log'; 
        %logdir='../mpw1e3fx075fy60/log'; istep=320; mpw=1e3;
    elseif (imod==2)
        fig1='20'; fig2='25';    eval(['cd /home/mahi/gito/LaMEM_work/hd9g3v1/T30nuk2wTF25FZ/' mpwstr ';']);   logdir='log'; 
    elseif (imod==3)
        fig1='30'; fig2='35';    eval(['cd /home/mahi/gito/LaMEM_work/hd9g3v1/T30nuk2wTF50FZ/' mpwstr ';']);  logdir='log'; 
    elseif (imod==4)
        fig1='40'; fig2='45';    eval(['cd /home/mahi/gito/LaMEM_work/hd9g3v1/T30nuk2wTF75FZ/' mpwstr ';']);  logdir='log'; 
    elseif (imod==5)
        fig1='40'; fig2='45';    eval(['cd /home/mahi/gito/LaMEM_work/hd9g3v1/T30nuk2wTF90FZ/' mpwstr ';']); logdir='log'; 
    end

elseif (sum(iwhich(1:6)=='dhnorm')==6) %hd9, dnorm
    if (imod==1)
        istep=390; 
        fig1='1'; fig2='5';   cd /home/mahi/gito/LaMEM_work/hd9g3v1/T30nuk1wTF50FZ/mpw1e3st380; logdir='log';dtave=0.5; mpw=1e3; 
        %fig1='1'; fig2='5';   cd /home/mahi/gito/LaMEM_work/hd9g3v1/T30nuk1wTF50FZ/mpw1e3; logdir='log';dtave=0.5; mpw=1e3; 
    elseif (imod==2)
        %fig1='12'; fig2='25';   cd /home/mahi/gito/LaMEM_work/hd9g3v1/T30nuk1.5wTF50FZ/mpw1e3; logdir='log';  dtave=0.5; mpw=1e3; 
        fig1='12'; fig2='25';   cd /home/mahi/gito/LaMEM_work/hd9g3v1/T30nuk1.5wTF50FZ-again; logdir='log';  dtave=0.5; mpw=1e3; 
    elseif (imod==3)
        fig1='22'; fig2='35';   cd /home/mahi/gito/LaMEM_work/hd9g3v1/T30nuk1.75wTF50FZ/mpw1e3; logdir='log';  dtave=0.5; mpw=1e3; 
    elseif (imod==4)
        fig1='20'; fig2='45';	cd /home/mahi/gito/LaMEM_work/hd9g3v1/T30nuk2wTF50FZ/mpw1e3;  logdir='log';dtave=0.4; mpw=1e3; 
    elseif (imod==5) 
        fig1='30'; fig2='55';   cd /home/mahi/gito/LaMEM_work/hd9g3v1/T30nuk2.5wTF50FZ/mpw1e3; logdir='log';  dtave=0.45; mpw=1e3; 
    elseif (imod==6)
        fig1='40'; fig2='65';   cd /home/mahi/gito/LaMEM_work/hd9g3v1/T30nuk3wTF50FZ/mpw1e3; logdir='log';  dtave=0.25; mpw=1e3; 
    end
    
elseif (sum(iwhich(1:8)=='TFlength')==8)  %hd9 TF Length
    if (imod==1)     
       fig2='5'; cd /home/mahi/gito/LaMEM_work/hd9g3v1/T05nuk2wTF50FZ/mpw1e3;  logdir='log'; mpw=1e3; dtave=0.4;
    elseif (imod==2)     
       fig2='15'; cd /home/mahi/gito/LaMEM_work/hd9g3v1/T10nuk2wTF50FZ/mpw1e3;  logdir='log'; mpw=1e3; dtave=0.3; dtave=0.4;
    elseif (imod==3)
       istep=360;
       fig2='25'; cd /home/mahi/gito/LaMEM_work/hd9g3v1/T20nuk2wTF50FZ/mpw1e3str350;  logdir='log'; mpw=1e3;  dtave=0.7;
       %dtstart=2.75;
    elseif (imod==4)
        fig2='35'; fig2='37'; cd /home/mahi/gito/LaMEM_work/hd9g3v1/T30nuk2wTF50FZ/mpw1e3; logdir='log'; mpw=1e3;  dtave=0.45; 
    elseif (imod==5)
        fig1='40'; fig2='45'; cd /home/mahi/gito/LaMEM_work/hd9g3v1/T40nuk2wTF50FZ/mpw1e3orig;  logdir='log'; mpw=1e3; dtave=0.45;
    elseif (imod==6)
        fig1='50'; fig2='55'; cd /home/mahi/gito/LaMEM_work/hd9g3v1/T50nuk2wTF50FZhd9.5/mpw1e3;  logdir='log'; mpw=1e3; dtave=0.45;
    elseif (imod==7)
        fig1='60'; fig2='65'; cd /home/mahi/gito/LaMEM_work/hd9g3v1/T60nuk2wTF50FZ/mpw1e3;  logdir='log'; mpw=1e3; dtave=0.45;
    end 
    
elseif (sum(iwhich(1:6)=='g4v1LT')==6)  %Wide models
    if (imod==1)     
        fig2='5'; cd /home/mahi/gito/LaMEM_work/g4nx512/T10nuk2wTF50FZ/mpw1e3;  logdir='log'; mpw=1e3; dtave=0.4;
    elseif (imod==2)     
       fig2='10'; cd /home/mahi/gito/LaMEM_work/g4nx512/T30nuk2wTF50FZ/mpw1e3;  logdir='log'; mpw=1e3; dtave=0.4;
    elseif (imod==3)     
       fig2='15'; cd /home/mahi/gito/LaMEM_work/g4nx512/T50nuk2wTF50FZ/mpw1e3;  logdir='log'; mpw=1e3; dtave=0.4;
    elseif (imod==4)     
       fig2='20'; cd /home/mahi/gito/LaMEM_work/g4nx512/T60nuk2wTF50FZ/mpw1e3;  logdir='log'; mpw=1e3; dtave=0.4;
    end
elseif (sum(iwhich(1:5)=='varyM')==5)  %Varying M
    istep=360;
    if (imod==1)
        %fig2='20'; cd /home/mahi/gito/LaMEM_work/hd10g3v1/T20M35nuk1.5wTF50FZ/mpw1e3;  logdir='log'; mpw=1e3; dtave=0.4;
        fig2='2'; cd /home/mahi/gito/LaMEM_work/varyM/T30M35-75nuk1.5wTF50FZ;  logdir='log'; mpw=1e3; dtave=0.2;
    elseif (imod==2)
        %fig2='2'; cd /home/mahi/gito/LaMEM_work/varyM/T30M45-75nuk1.5wTF50FZ-newinput-mumps;  logdir='log'; mpw=1e3; dtave=0.3; istep=340;
        fig2='2'; cd /home/mahi/gito/LaMEM_work/varyM/T30M45-75nuk1.5wTF50FZ;  logdir='log'; mpw=1e3; dtave=0.3; istep=410;
    elseif (imod==3)
        fig2='2'; cd /home/mahi/gito/LaMEM_work/varyM/T30M55-75nuk1.5wTF50FZ;  logdir='log'; mpw=1e3; dtave=0.3; istep=400;
    elseif (imod==4)
        fig2='2'; cd /home/mahi/gito/LaMEM_work/varyM/T30M65-75nuk1.5wTF50FZ;  logdir='log'; mpw=1e3; dtave=0.5; istep=370;
    end
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
        %read_sxx_Pmag_fr_log_with_stress;  %for T30nuk1.5-wTF50FZ-newinput-mumps
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