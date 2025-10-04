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
%xL=-11; xR=11;


yTFfxx=1;
series_s='dhnorm';
series_s='TFlength';
 
for iplot=1:4
tickarray=[0:10:30];
if (iplot==1)   
    fig1='102'; fig2='50';   cd T30nuk1wTF50FZ/mpw1e3st380; logdir='log'; xridge=15; istep=390;
elseif (iplot==2)
    fig1='103'; fig2='51';   cd T30nuk2wTF50FZ/mpw1e3; logdir='log'; xridge=15; istep=310;
elseif (iplot==3)
    fig1='120'; fig2='52';   cd T30nuk2wTF25FZ/mpw1e3; logdir='log'; istep=310;xridge=15; 
elseif (iplot==4)
    %fig1='120'; fig2='53';   cd T20nuk2wTF50FZ/mpw1e3str350; logdir='log'; istep=360; xridge=10; 
    fig1='120'; fig2='53';   cd T30nuk2wTF75FZ/mpw1e3; logdir='log'; istep=310; xridge=15; 
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
xcc=[xL:0.01:xR];
ilcc=(xcc<0);
ircc=(xcc>0);
%--------------------------------------------------------------------------
% ANALYTIC solution 
%--------------------------------------------------------------------------
get_Lfac;
L=Lfac*2*xridge; 
model_lithosphere;
full_analytical_solution;
[lthick_TF_a, diffs_ave_a,dsnorm2_a,fxxslope1_a,h0_a,dh_a,sxx_a_ave,fxx_a_ave]=...
stats4analytical_solns(j4TFLthickness,zLa,x,y,xridge,xL,xR,fxx_a_ave,sxx_a_ave,dist_ave,dist_find_peak);
%xan=xan-xridge;

%--------------------------------------------------------------------------
% Maps
%--------------------------------------------------------------------------

%xp=[-25 5]; yp=[-20 10];
%xp=[-12 12]; yp=[0 20];
xp=[-17 17]; yp=[0 30];

ii=find(yp(1)<=y & y<=yp(2));
jj=find(xp(1)<=x & x<=xp(2));


climfxx=[0 3000];
climsxx=[0 200];
fsz=14;
tl=0.02;
lw=1.5;
%--------------------------------------------------------------------------
% STresses
%--------------------------------------------------------------------------
eval(['figure(' fig2 '); clf;']);
set(gcf,'Color','w'); 
depthplot=-8;
kk=find(abs(z-depthplot)==min(abs(z-depthplot)),1);
j2ratexy=zeros(Ny,Nx);
j2ratexy(:,:)=j2_strain_rate(kk,:,:);


x1=0.1; ytop=0.6; xw=0.35; yh=0.3; xbuf=0.07; ybuf=0.05;  %with colorbars
x1=0.1; ytop=0.6; xw=0.34; yh=0.3; xbuf=0.05; ybuf=0.05;

subplot('position',[x1 ytop xw yh]);
[C,h]=contourf(x(jj),y(ii),sxx_eff(ii,jj),50); shading flat; set(h,'LineColor','none'); hold on; 
%plot([[-15 -15 15 15 ]'],[0 22.5 22.5 0],'k--','Linewidth',1);
contour(x,y,j2ratexy,[1e-13 1e-13],'w','Linewidth',2);
%c=colorbar('EastOutside');%c.Label.String='\sigma_e_f_f (MPa)'; 
axis([xp yp]);
caxis(climsxx);
set(gca,'Fontsize',fsz,'TickLength',[tl tl],'Linewidth',lw);
yticks([0:10:30]);

set(gca,'XtickLabel',[]);

subplot('position',[x1+xw+xbuf/2 ytop xw yh]);
[C,h]=contourf(xan+15,yan,sxx_a,50); shading flat; set(h,'LineColor','none'); hold on; 
%plot([[-15 -15 15 15 ]']+15,[0 22.5 22.5 0],'k--','Linewidth',1);
% c=colorbar('EastOutside'); %c.Label.String='\sigma_e_f_f (GPa m)'; 
% c.FontSize=12;
% c.LineWidth=lw;
%plot([-xridge -xridge xridge xridge],[yp(1) 0 0 yp(2)],'k-');
axis([xp+15 yp]);
caxis(climsxx);
% xlabel('Across-Axis (km)');
set(gca,'Fontsize',fsz,'TickLength',[tl tl],'Linewidth',lw);
yticks([0:10:30]);
xticks(tickarray);
set(gca,'XtickLabel',[]);
set(gca,'YtickLabel',[]);

cmap = (crameri('-roma'));
colormap(cmap);


%--------------------------------------------------------------------------
% Forces
%--------------------------------------------------------------------------
subplot('position',[x1 ytop-yh-ybuf/2 xw yh]);
[C,h]=contourf(x(jj),y(ii),fxx_eff(ii,jj),50); shading flat; set(h,'LineColor','none'); hold on; 
%plot([[-15 -15 15 15 ]'],[0 22.5 22.5 0],'k--','Linewidth',1);
contour(x,y,j2ratexy,[1e-13 1e-13],'w','Linewidth',2);
%c=colorbar('EastOutside'); %c.Label.String=' F_x_x (GPa m)'; 
axis([xp yp]);
%ylabel('Along-axis (km)');
caxis(climfxx);
set(gca,'Fontsize',fsz,'TickLength',[tl tl],'Linewidth',lw);
yticks([0:10:30]);


subplot('position',[x1+xw+xbuf/2 ytop-yh-ybuf/2 xw yh]);
[C,h]=contourf(xan+15,yan,fxx_a,50); shading flat; set(h,'LineColor','none'); hold on; 
%plot([[-15 -15 15 15 ]']+15,[0 22.5 22.5 0],'k--','Linewidth',1);
% c=colorbar('EastOutside');
% c.FontSize=12;
% c.LineWidth=lw;
axis([xp+15 yp]);
caxis(climfxx);
% xlabel('Across-Axis (km)');
% ylabel('Along-axis (km)');
set(gca,'Fontsize',fsz,'TickLength',[tl tl],'Linewidth',lw);
set(gca,'YtickLabel',[]); 
yticks([0:10:30]);
xticks(tickarray);set(gca,'xtickLabels',{'0', '10', '20' '30'});

f = gcf;

cd ../..
if (1)
    disp('Outputing high-res png');
    exportgraphics(f,['Fig_stress_map' num2str(iplot) '.png'],'Resolution',600)
else
    disp('Not outputing high-res png');
end
end
