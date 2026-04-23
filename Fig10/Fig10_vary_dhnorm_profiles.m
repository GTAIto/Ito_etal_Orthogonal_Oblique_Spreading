%==========================================================================
% Plots profiles of lithospheric thickness
%==========================================================================
%iprof=find(abs(xc-xprof)==min(abs(xc-xprof)),1);
%clear;
clear;

magPwidth=1000;
dtave=0.5;  %time over which to evaluate mean slope. Other numbers are start times for dynamic dikingcd 
Tsol=600; ylimsxxnorm=[0 4]; ylimlthick=[1 8]; ylimsxx=[0 1000]; ylimdsxx=[0 150];
Tsol=800; ylimsxxnorm=[0 3]; ylimlthick=[2 9]; ylimsxx=[200 1200]; ylimdsxx=[0 150];
Tsol=1000; ylimsxxnorm=[0 3]; ylimlthick=[1 12]; ylimsxx=[200 1200]; ylimdsxx=[0 150];

ymax=6.25;  %along axis distance for averaging
dikehalfwidth=0.75;
magPfac=1;
zmax_magma=-10;
drhomagma=0;
g=9.8;
yprof0=[1:0.5:ymax];
xL=-3; xR=3;
xcc=[xL:0.01:xR];
%xL=-11; xR=11;

yTFfxx=1;
series_s= 'dhnorm  ';
%series_s='TFlength';
series_s= 'wTF     ';
figure(1); clf
set(gcf,'Color','w'); 


for imod=[1 2 3]
    cd LaMEM_Input_Files_Output_Folders
    istep=310;
    xridge=15;
    if (imod==3)
        fig1='100'; fig2='31';   cd L30Nu1Weak50/Wm1e3; logdir='log'; xridge=15; istep=390; 
    elseif (imod==2)
        fig1='101'; fig2='42';   cd L30Nu1.75Weak50/Wm1e3; logdir='log';  xridge=15; istep=310; 
    elseif (imod==1)
        fig1='102'; fig2='53';   cd L30Nu2.5Weak50/Wm1e3; logdir='log'; xridge=15;

    end

parse_model;
weak=weak/100;

dist_ave=2*dikehalfwidth;
dist_find_peak=0.1*2*dikehalfwidth;

%--------------------------------------------------------------------------
% Loading model LaMEM output and compute key arrays
%--------------------------------------------------------------------------
load dir_py_MatLAB/LaMEM_vtr_data.mat
load dir_py_MatLAB/LaMEM_vtr_mesh.mat
Nx=length(X_vec); Ny=length(Y_vec); Nz=length(Z_vec);
x=X_vec; y=Y_vec; z=Z_vec;
dx=x(2:Nx)-x(1:Nx-1); dz=[z(2:Nz)-z(1:Nz-1)]'; dy=y(2:Ny)-y(1:Ny-1);
load dir_py_MatLAB/LaMEM_vts_topo.mat
sxx_eff_node=dev_stress(:,:,:,1)-pressure+litho_press;
Plith=litho_press;

compute_lthick;
compute_sxx_Pmag;

sxx_eff=sxx_tot_ave+Pmag_ave;
syy_eff=syy_tot_ave+Pmag_ave;
fxx_eff=sxx_eff.*lthick;
fxy=sxy_tot_ave.*lthick;
fyy_eff=syy_eff.*lthick;

fxx_TF=mean(fxx_eff(y>=0 & y<=yTFfxx,x>-xridge & x<xridge),'all');
beenhere=0;
%--------------------------------------------------------------------------
%Read dike coordinates
%--------------------------------------------------------------------------
ndyndike=2;
if (ndyndike==2);  map_cbar_loc='north'; end;
if (ndyndike==1);  map_cbar_loc='south'; end; %for computing mean delta sxx
disp(['---- ndynDike #' num2str(ndyndike) ' ----']);
disp(['istep=' num2str(istep)]);
read_dikecoords_fr_log;
ilcc=(xcc<0);
ircc=(xcc>0);
%--------------------------------------------------------------------------
% ANALYTIC solution 
%--------------------------------------------------------------------------
Lfac=0.75;
model_lithosphere;
L=Lfac*2*xridge;
full_analytical_solution;
[lthick_TF_a, diffs_ave_a,dsnorm2_a,fxxslope1_a,h0_a,dh_a,sxx_a_ave,fxx_a_ave]=...
stats4analytical_solns(j4TFLthickness,zLa,x,y,xridge,xL,xR,fxx_a_ave,sxx_a_ave,dist_ave,dist_find_peak);
%xan=xan-xridge;

%--------------------------------------------------------------------------
% PLOTS
%--------------------------------------------------------------------------
red=[0.65 0.32 0.16];
red=[0.8 0.3 0.3];
blu=[0.2 0.35 0.75];
gray=[1 1 1]*0.0;
mlw=2;
fsz=14;
tl=0.03;
lw=1.5;
fsz=12;
lwLam=3;
%------------------------------------------------------------------
% Fxx
%------------------------------------------------------------------
caxon=1;
xx_eff=fxx_eff;  %This is what is being averaged along the segment tip
along_segment_smooth_ave;
x1=0.1; y1=0.99;
xw=0.075; xbuff=0.0125; 
yh=0.12; ybuff=0.02; 

%--------------------------------------------------------------------------
% Profiles of individual stress parts and lith. Thickness
%-------------------------------------------------------------------------
along_segment_smooth_ave_Lthickness;

subplot('position',[x1+(xw+xbuff)*(imod-1) y1-(yh+ybuff) xw yh]);
mthick=min(lthick_cc_ave);
dthick=max(lthick_cc_ave-mthick);
plot(xcc,lthick_cc_ave'-0.0*min(lthick_cc_ave),'Color',blu,'Linewidth',lwLam); hold on;
sxx_a_cc=interp1(x-xridge,zLa_array(1,:),xcc);
plot(xcc,sxx_a_cc,'Color',red,'Linewidth',mlw); hold on;
set(gca,'TickLength',[tl tl],'Linewidth',lw);

xlim([-2 2])
ylim([3 12]);
% grid on;
%axis([xL xR ylimlthick]);
set(gca,'YDIR','Reverse')
if (imod>1)
    set(gca, 'YTickLabel', [], 'FontSize', fsz);
end
xticks([-1.5 0 1.5]);
set(gca, 'FontSize', fsz);
% if (imod==3)
%     xlabel('Across axis (km)');
% end


end
cd /home/mahi/gito/LaMEM_work/hd9g3v1
if (0)
    disp('Outputing high-res png');
    figure(1); exportgraphics(gcf,['Fig9_vary_dhnorm_profs.png'],'Resolution',600)
else
    disp('Not outputing high-res png');
end
