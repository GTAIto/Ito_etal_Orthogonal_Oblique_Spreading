%===========================================================================
% Plots output quantities to look for factors that influence TF stability
%==========================================================================
clear;
res=load('sxx_results.txt');
% n1=res(:,1); n2=res(:,2); h0=res(:,3); dh=res(:,4); 
% diffs_ave=res(:,5); dwdt=res(:,6); smax=res(:,7); dsig_tot=-res(:,8); mpw=res(:,14);
% TFfrict=0.6*(1-res(:,13)/100);
n1=res(:,1); n2=res(:,2); h0=res(:,3); dh=res(:,4); 
diffs_ave=res(:,5); dwdt=-res(:,6); smax=res(:,7); dsig_var=-res(:,8); mpw=res(:,17);
weak=res(:,13);
TFfrict=tand(30*(1-weak/100));

dsnorm=diffs_ave./smax;
dsnorm2=abs(diffs_ave./dsig_var); 

ii=(mpw==1e3);
i2=(mpw==1.5);
i3=(mpw==0.75);
i4=(mpw==0.375);
i5=(mpw==4.5);
anal_color=[0.8 0.5 0.5];
anal_lw=3;
%--------------------------------------------------------------------------
% Analytical Solution
%--------------------------------------------------------------------------
dikehalfwidth=0.75;
dist_find_peak=dikehalfwidth;
dist_ave=2*dikehalfwidth;
xL=-2; xR=2;
xridge=15;
ymax=6.25;
x=[0:0.1:2*xridge]; %These are relative to LaMEM origin
% xcc=x-xridge;
% xcc=[xL:0.1:xR];
y=[0:0.1:ymax];
Ny=length(y);
nu2=2;
nu1=2;
Tsol=1000;

weak_array=[0.0:0.01:0.95];

TFfrict_a=tand(30*(1-weak_array));
%--------------------------------------------------------------------
tL=0.04;
x1=0.1; xw=0.3; xbuff=0.04; ytop=0.5; yh=0.35; ybuff=0.05;
x1=0.1; xw=0.25; xbuff=0.04; ytop=0.7; yh=0.22; ybuff=0.03;

% pf=polyfit(dsnorm2(ii),dwdt(ii),1);
% xmod=[0:0.1:0.5]';
% 
figure(12);
clf; set(gcf,'Color','w');
anal_color=[0.8 0.5 0.5];
blu=[0.25 0.35 0.75];
fsz=12; tl=0.03; lw=1.5;
pf=polyfit(dsnorm2(ii),dwdt(ii),1);

subplot('position',[x1 ytop xw yh]);
get_Lfac;analytical_soln_varyMu;
analytical_soln_varyMu;
% plot(TFfrict_a,polyval(pf,0.75*dsnorm2_a),'--','Linewidth', anal_lw,'Color',anal_color); hold on;
% plot(TFfrict_a,polyval(pf,1.0*dsnorm2_a),'--','Linewidth', anal_lw,'Color',anal_color);
% plot(TFfrict_a,polyval(pf,1.25*dsnorm2_a),'--','Linewidth', anal_lw,'Color',anal_color);

plot(TFfrict(ii),dwdt(ii),'ko','MarkerFaceColor',blu,'Markersize',12); hold on;
if (1)
    plot(TFfrict(i2),dwdt(i2),'ks','Markersize',13,'MarkerFaceColor',[0.3 0.8 0.3]); 
    plot(TFfrict(i3),dwdt(i3),'k>','Markersize',11,'MarkerFaceColor',[0.85 0.6 0.3]); 
    plot(TFfrict(i4),dwdt(i4),'kd','Markersize',11,'MarkerFaceColor',[0.8 0.3 0.3]);
    plot(TFfrict(i5),dwdt(i5),'kd','Markersize',10,'MarkerFaceColor',0.5*[1 1 1]);
end
%ylabel('Transform Shortening Rate, km/Myr');
axis([0 0.65 0 30]);
set(gca,'TickLength',[tl tl],'Linewidth',lw,'Fontsize',fsz);

if (0)
    disp('Outputing high-res png');
    figure(12); exportgraphics(gcf,['Fig11_vary_wTF.png'],'Resolution',600)
else
    disp('Not outputing high-res png');
end

