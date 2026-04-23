%===========================================================================
% Plots output quantities to look for factors that influence TF stability
%==========================================================================
clear;

res=load('LaMEM_Input_Files_Output_Folders/sxx_results_dhnorm.txt'); Tsol=1000;
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
green=[0.25 0.5 0.25];
anal_lw=2;

x1=0.15; xw=0.25; xbuff=0.04; ytop=0.7; yh=0.22; ybuff=0.03;
x1=0.15; xw=0.35; xbuff=0.04; ytop=0.6; yh=0.30; ybuff=0.035;
fz=12;
tl=0.03;
lw=1.5;
wanal=2*1.5;  %to make dh/dx, this is 2*dike width


get_Lfac; L=Lfac*2*xridge; analytical_soln_profs;
dhnorm_LaMEM=dh./h0/wanal;
nsols=length(dwdt); ivaryM=nsols-3:nsols;

figure(1);
clf; set(gcf,'Color','w');
subplot('position',[x1 ytop xw yh]);
plot(dh_a./h0_a/wanal,polyval(pf,0.75*dsnorm2_a),'--','Linewidth',anal_lw,'Color',anal_color); hold on;
plot(dh_a./h0_a/wanal,polyval(pf,dsnorm2_a),'--','Linewidth',anal_lw,'Color',anal_color);
plot(dh_a./h0_a/wanal,polyval(pf,1.25*dsnorm2_a),'--','Linewidth',anal_lw,'Color',anal_color);
plot(dhnorm_LaMEM,dwdt,'ko','MarkerFaceColor',blu,'Markersize',12); hold on;
plot(dhnorm_LaMEM(ivaryM),dwdt(ivaryM),'ko','MarkerFaceColor',green,'Markersize',12); hold on;
set(gca,'TickLength',[tl tl],'Linewidth',lw,'Fontsize',fz);
% xlabel('\Delta {\it{h/h_0}}');
% ylabel('d{\it{w}}/d{\it{t}}, km/Myr');
%set(gca,'YDIR','Reverse','Fontsize',fz);
axis([0.0 0.25 0 30])
xticks(0:0.05:0.25);

subplot('position',[x1 ytop-(yh+ybuff) xw yh]);
plot(dh_a./h0_a/wanal,0.75*dsnorm2_a,'Linewidth',anal_lw,'Color',anal_color); hold on;
plot(dh_a./h0_a/wanal,dsnorm2_a,'Linewidth',anal_lw,'Color',anal_color); 
plot(dh_a./h0_a/wanal,1.25*dsnorm2_a,'Linewidth',anal_lw,'Color',anal_color);
plot(dhnorm_LaMEM,dsnorm2,'ko','MarkerFaceColor',blu,'Markersize',12); 
plot(dhnorm_LaMEM(ivaryM),dsnorm2(ivaryM),'ko','MarkerFaceColor',green,'Markersize',12); hold on;
set(gca,'TickLength',[tl tl],'Linewidth',lw);
axis([0.0 0.25 0 0.8])
xticks([0 0.05 0.1 0.15 0.25]);
yticks(0:0.2:0.8);
% xlabel('\Delta {\it{h/h_0}}');
% ylabel('\Delta {\it{\sigma/\sigma_v_a_r}}');
set(gca,'Fontsize',fz);
%axis([0 0.7 0 1.5]);
%legend('hd8 no smooth','hd8 smooth', 'hd9 no smooth', 'hd15 no smooth','Location','best')

if (0)
    disp('Outputing high-res png');
    figure(1); exportgraphics(gcf,['Fig9_vary_dhnorm.png'],'Resolution',600)
else
    disp('Not outputing high-res png');
end

