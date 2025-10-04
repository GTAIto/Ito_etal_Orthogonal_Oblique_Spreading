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

cd /home/mahi/gito/LaMEM_work/hd9g3v1

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


for imod=[1 2]
    istep=310;
    xridge=15;
    if (imod==1)
       cd T30nuk2wTF75FZ/mpw1e3; logdir='log';
    elseif (imod==2)
       cd T30nuk2wTF25FZ/mpw1e3; logdir='log';
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
x1=0.1; y1=0.78;
xw=0.12; xbuff=0.035; 
yh=0.19; ybuff=0.02; 


%------------------------------------------------------------------
% sxx
%------------------------------------------------------------------
xx_eff=sxx_eff;  %This is what is being averaged along the segment tip
along_segment_smooth_ave;

subplot('position',[0.1+(xw+xbuff)*(imod-1) y1 xw yh]);
plot(xcc,fxx_cc_ave,'Color',blu,'Linewidth',lwLam); hold on;
sxx_a_cc=interp1(x-xridge,sxx_a_ave,xcc);
plot(xcc,sxx_a_cc,'Color',red,'Linewidth',mlw); hold on;
xlim([-2 2]);
xticks([-1.5 0 1.5]);
if (imod==2)
    %ylabel('\sigma_x_x (MPa)','FontSize',fsz)
    ax = gca; % Get current axes
    ax.YAxisLocation = 'right'; % Move the y-axis to the right
    set(gca,'Yticklabel',[])
else
    set(gca, 'YTickLabel', [40 60 80 100 120], 'FontSize', fsz)
end
ylim([40 120]);

set(gca,'TickLength',[tl tl],'Linewidth',lw,'FontSize', fsz);


cd /home/mahi/gito/LaMEM_work/hd9g3v1


end

if (0)
    f=gcf;
    disp('Outputing high-res png');
    exportgraphics(f,['Fig8_varyWTF_stress_profs.png'],'Resolution',600)
else
    disp('Not outputing high-res png');
end