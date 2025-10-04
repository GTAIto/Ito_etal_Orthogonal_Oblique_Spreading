%===========================================================================
% Plots output quantities to look for factors that influence TF stability
%==========================================================================
clear;

res=load('/home/mahi/gito/LaMEM_work/hd9g3v1/sxx_results_dhnorm.txt'); Tsol=1000;
n1=res(:,1); n2=res(:,2); h0=res(:,3); dh=res(:,4); 
diffs_ave=res(:,5); dwdt=-res(:,6); smax=res(:,7); sig_var=-res(:,8); 
fxxslope1=res(:,14); lthick_TF=res(:,15);
dsnorm=diffs_ave./smax;
dsnorm2=abs(diffs_ave./sig_var);
Lfac=0.75;  %vertical extent of model

%-------------------------------------------------------------------------
% Plots
%-------------------------------------------------------------------------
pf=polyfit(dsnorm2,dwdt,1);
%pf=[-60.88 4.50];  %fit to all of them. 
xmod=[0:0.01:0.5]';

xridge=15;

% dwdt_a=polyval(pf,dsnorm2_a);
anal_color=[0.8 0.5 0.5];
blu=[0.25 0.35 0.75];
anal_lw=2;

x1=0.1; xw=0.25; xbuff=0.04; ytop=0.7; yh=0.22; ybuff=0.03;
fz=12;
tl=0.03;
lw=1.5;
wanal=1.5;  %to make dh/dx, this is 2*dike width

figure(11);
get_Lfac; L=Lfac*2*xridge; analytical_soln_profs;
clf; set(gcf,'Color','w');
subplot('position',[x1 ytop xw yh]);
plot(dh_a./h0_a/wanal,polyval(pf,0.75*dsnorm2_a),'--','Linewidth',anal_lw,'Color',anal_color); hold on;
plot(dh_a./h0_a/wanal,polyval(pf,dsnorm2_a),'--','Linewidth',anal_lw,'Color',anal_color);
plot(dh_a./h0_a/wanal,polyval(pf,1.25*dsnorm2_a),'--','Linewidth',anal_lw,'Color',anal_color);
plot(dh./h0/wanal,dwdt,'ko','MarkerFaceColor',blu,'Markersize',12); hold on;
set(gca,'TickLength',[tl tl],'Linewidth',lw,'Fontsize',fz);
%xlabel('\Delta h/h_0');
%ylabel('dw/dt km/Myr');
%set(gca,'YDIR','Reverse','Fontsize',fz);
axis([0.2 0.5 0 30])


subplot('position',[x1 ytop-(yh+ybuff) xw yh]);
plot(dh_a./h0_a/wanal,0.75*dsnorm2_a,'Linewidth',anal_lw,'Color',anal_color); hold on;
plot(dh_a./h0_a/wanal,dsnorm2_a,'Linewidth',anal_lw,'Color',anal_color); 
plot(dh_a./h0_a/wanal,1.25*dsnorm2_a,'Linewidth',anal_lw,'Color',anal_color);
plot(dh./h0/wanal,dsnorm2,'ko','MarkerFaceColor',blu,'Markersize',12); hold on;
set(gca,'TickLength',[tl tl],'Linewidth',lw);
axis([0.2 0.5 0 0.5])
%xlabel('\Delta h/h_0');
%ylabel('\Delta\sigma/\sigma_v_a_r');
set(gca,'Fontsize',fz);
%axis([0 0.7 0 1.5]);
%legend('hd8 no smooth','hd8 smooth', 'hd9 no smooth', 'hd15 no smooth','Location','best')

if (0)
    disp('Outputing high-res png');
    figure(11); exportgraphics(gcf,['Fig9_vary_dhnorm.png'],'Resolution',600)
else
    disp('Not outputing high-res png');
end

