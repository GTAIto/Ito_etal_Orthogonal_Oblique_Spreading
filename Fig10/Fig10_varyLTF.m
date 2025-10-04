%===========================================================================
% Plots output quantities to look for factors that influence TF stability
%==========================================================================
clear;
yTFfxx=1;  %within this distance of TF, Fxx=Sigr;

res=load('/home/mahi/gito/LaMEM_work/hd9g3v1/sxx_results_LTF.txt'); Tsol=1000;
n1=res(:,1); n2=res(:,2); h0=res(:,3); dh=res(:,4); 
diffs_ave=res(:,5); dwdt=res(:,6); smax=res(:,7); dsig_var=-res(:,8); mpw=res(:,17);
weak_mods=res(:,13); LTF=res(:,16);
dsnorm2=abs(diffs_ave./dsig_var);

res=load('/home/mahi/gito/LaMEM_work/hd9g3v1/sxx_results_dhnorm.txt'); Tsol=1000;
h03=res(:,3); dh3=res(:,4); 
diffs_ave3=res(:,5); dwdt3=res(:,6); sig_var3=-res(:,8); 
dsnorm23=abs(diffs_ave3./sig_var3);

pf=polyfit(dsnorm23,-dwdt3,1);

%-------------------------------------------------------------------------
% Analytical Solution
%-------------------------------------------------------------------------
dikehalfwidth=0.75;
dist_find_peak=dikehalfwidth;
dist_ave=2*dikehalfwidth;

nu2=2;
nu1=2;
%1LTF_array=[5 6 8 10 12 14];  
LTF_array=[5:45];  %must be >4 because xL=-2; xR=2;
weak=weak_mods(1)/100;

%-------------------------------------------------------------------------
% Plots
%-------------------------------------------------------------------------

fsz=12; tl=0.03; lw=1.5;
x1=0.1; xw=0.3; xbuff=0.04; ytop=0.5; yh=0.22; ybuff=0.03;
x1=0.1; xw=0.25; xbuff=0.04; ytop=0.7; yh=0.22; ybuff=0.03;
figure(1);
clf; set(gcf,'Color','w');
anal_color=[0.8 0.5 0.5];
blu=[0.25 0.35 0.75];
anal_lw=2;

xmod=[0:0.05:0.6]';

Lfac0=[0.75 1 1.25];  %too vary multiplying factor in front of Lfac
Lfac0=1;

for kk=1:1 
    analytical_soln_LTF_varLfac;
    subplot('position',[x1 ytop xw yh]);
    plot(LTF_array,polyval(pf,0.75*dsnorm2_a),'--','Linewidth',anal_lw,'Color',anal_color); hold on;
    plot(LTF_array,polyval(pf,dsnorm2_a),'--','Linewidth',anal_lw,'Color',anal_color); hold on;
    plot(LTF_array,polyval(pf,1.25*dsnorm2_a),'--','Linewidth',anal_lw,'Color',anal_color); hold on;
    if (kk==1)
        plot(LTF,-dwdt,'ko','MarkerFaceColor',blu,'Markersize',12); hold on;
        % xlabel('L_T_F, MPa');
        % ylabel('dw/dt km/Myr');
        %set(gca,'YDIR','Reverse');
        ylim([0 30]);
        xlim([0 50]);
    end
    set(gca,'TickLength',[tl tl],'Linewidth',lw,'Fontsize',fsz);
    %yticks([0:10:30]);


%------------------------------------------------------------------------
% Row 2
%-------------------------------------------------------------------------
    subplot('position',[x1 ytop-(yh+ybuff) xw yh]);
    plot(LTF_array,0.75*dsnorm2_a,'-','Linewidth',anal_lw,'Color',anal_color); hold on;
    plot(LTF_array,dsnorm2_a,'-','Linewidth',anal_lw,'Color',anal_color); hold on;
    plot(LTF_array,1.25*dsnorm2_a,'-','Linewidth',anal_lw,'Color',anal_color); hold on;
    if (kk==1)
        plot(LTF,dsnorm2,'ko','MarkerFaceColor',blu,'Markersize',12); hold on;
        %xlabel('L_T_F, km');
        %ylabel('\Delta\sigma_n/\sigma_v_a_r')
        ylim([0.0 0.5]);
        xlim([0 50]);
        %grid on;
    end
    set(gca,'TickLength',[tl tl],'Linewidth',lw,'Fontsize',fsz);

end

if (0) 
    subplot(224);
    xridge=15;
    L=0.75*2*xridge; analytical_soln_profs;
    plot(dh_a./h0_a,dsnorm2_a,'r-'); hold on;
    plot(dh_a./h0_a,0.75*dsnorm2_a,'r-');
    plot(dh_a./h0_a,1.25*dsnorm2_a,'r-');
    plot(dh3./h03,dsnorm23,'ko','MarkerfaceColor',[0.8 0.5 0.3],'Markersize',10);
    %plot(dh2./h02,dsnorm22,'ko','MarkerFaceColor','c'); hold on;
    plot(dh./h0,dsnorm2,'ko','MarkerFaceColor','b'); hold on;
    xlabel('\Delta h/h0, km');
    ylabel('\Delta\sigma_n/\sigma_v_a_r')
    axis([0.2 0.8 0 0.5]);
    grid on;

end

if (0)
    disp('Outputing high-res png');
    figure(1); exportgraphics(gcf,['Fig10_varyLTF.png'],'Resolution',600)
else
    disp('Not outputing high-res png');
end









