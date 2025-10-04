%==========================================================================
% Model of lithosphere thickness.
% Dike injections is Gaussian
% Subsequent cooling half-space from T&S
% nu_K slows the thickening off-axis for slow-conductive cooling
% z0G = initial lithosphere thickness
% zlGAmp= amplitude of Gaussian fast (hydrothermal) cooling
% sigma = width of Gaussian (fast) cooling
%==========================================================================
u=10; 
cp=1e3; %J/kg/K; 
kcond=3.5; %W/m/K
rho=3300;


Gdistfac=2;
dxmin=min(x(2:end)-x(1:end-1));
sigmin=0.6*Gdistfac.*dxmin;
hdfit=9;

showfig=0;

x0=xridge;
x0fit=[1   1    1    1    1 ]*x0;

TFl=2.*xridge;
TFl1=30;
TFlmax=40;
%--------------------------------------------------------------------------
% TF effects on z0 and GAussian Amplitude
%--------------------------------------------------------------------------
z0TFf1=5.5/7; z0TFf=z0TFf1+(1-z0TFf1)/30.*TFl;

zlGampTFf1=0.5;
if (TFl<=TFl1)
    zlGampTFf=zlGampTFf1+(1-zlGampTFf1)/TFl1.*TFl;
else
    zlGampTFf=1;
end
%zlGampTFf=zlGampTFf1+(1-zlGampTFf1)/TFl1.*TFl;
zlGampTFf=1;
%--------------------------------------------------------------------------

if (hdfit==8)
    nu2fit=[1    1.5 2   2.25 2.5];
    z0Gfit=[4.55 5.6 7.5 8   10];    
    zlGampfit=[3 2.9 2   1.5   0.3];  
    sigfit=[0.7 0.6 0.5 0.45 0.3]; %fits the lithosphere for nuk1-2.5, hd=8km
    %dist4sigR=3;
else
    nu2fit=[1    1.5 2   2.5 3];
    z0Gfit=[4.5 5 6.5 8 9]; 
    %z0Gfit=[4.5 5 6.5 8 11];   
    zlGampfit=[3 2.9 2.8   2  1];  
    zlGampfit=[4 2.9 2.8   2  1];  
    sigfit=[0.9 0.8 0.5 0.45 0.3]; %fits the lithosphere for nuk1-2.5, hd=9km
end    

nu_kfit  =[1   1   1   1   1]*0.3;  

pzlGamp=polyfit([nu2fit],zlGampfit,2);  %originally
pz0G=polyfit(nu2fit,z0Gfit,1);  %ORIGINAL with hd=8;
pnu_k=polyfit(nu2fit,nu_kfit,2);
psig=polyfit(nu2fit,sigfit,3);%originally
px0=polyfit(nu2fit,x0fit,3);
        
pzlGamp=polyfit([nu2fit],zlGampfit,1);
psig=polyfit(nu2fit,sigfit,1);
%--------------------------------------------------------------------------
% Gaussian Part
%--------------------------------------------------------------------------
z0G=polyval(pz0G,nu2);
z0G=z0G.*z0TFf;             %minimums lithosphere thickness at ridge axis
zLGamp=polyval(pzlGamp,nu2);
zLGamp=zLGamp.*zlGampTFf;
zLGamp=max([zLGamp zlGampfit(end)]);
sig=polyval(psig, nu2);
sig=max([sig sigmin]);  %Gdistfac*sig  
nu_k=polyval(pnu_k, nu2);

%nu2_z0G_zLGamp_sig=[nu2 z0G zLGamp sig]
%x0=polyval(px0,nu2);  %Comment this out for ORIGINAL with hd=8 km;

if (showfig==1)
    nu2ar=[1:0.05:3];
    %nu2ar=nu2array;
    z0Gar=polyval(pz0G,nu2ar);
    zlGampar=polyval(pzlGamp,nu2ar);
    zlGampar(zlGampar<zlGampfit(end))=zlGampfit(end);
    nu_kar=polyval(pnu_k,nu2ar);
    sigar=polyval(psig,nu2ar);
    sigar(sigar<sigmin)=sigmin;
    x0_ar=polyval(px0,nu2ar,2);
    lw=1; lw2=0.7; fsz=12; tl=0.02;

    figure(1); clf;
    set(gcf,'Color','w');
    subplot(311)
    plot(nu2fit,z0Gfit,'o','MarkerEdgeColor',0.0*[1 1 1],'MarkerFaceColor',[0.19  0.19 0.8],'MarkerSize',10); hold on;
    plot(nu2ar,z0Gar,'k','LineWidth',lw);
    ylabel('h_0');
    grid off;
    xlim([1 2.5]);
    set(gca,'Fontsize',fsz);
    set(gca,'Fontsize',fsz,'TickLength',[tl tl],'Linewidth',lw2);
    
    subplot(312)
    plot([nu2fit],zlGampfit,'o','MarkerEdgeColor',0.0*[1 1 1],'MarkerFaceColor',[0.19  0.19 0.8],'MarkerSize',10); hold on;
    plot(nu2ar,zlGampar,'k','LineWidth',lw);
    xlim([1 2.5]);
    grid off;
    ylabel('\Delta h');
    set(gca,'Fontsize',fsz);
    set(gca,'Fontsize',fsz,'TickLength',[tl tl],'Linewidth',lw2);
    yticks(2:4);
    
    subplot(313)
    plot(nu2fit,sigfit,'o','MarkerEdgeColor',0.0*[1 1 1],'MarkerFaceColor',[0.19  0.19 0.8],'MarkerSize',10); hold on;
    plot(nu2ar,sigar,'k','LineWidth',lw);
    ylabel('w_h');
    grid off;
    xlabel('Nu');
    xlim([1 2.5]);
    set(gca,'Fontsize',fsz);
    set(gca,'Fontsize',fsz,'TickLength',[tl tl],'Linewidth',lw2);

%     subplot(414)
%     plot([nu2fit],zlGampfit./z0Gfit,'o','MarkerEdgeColor',0.0*[1 1 1],'MarkerFaceColor',[0.19  0.19 0.8],'MarkerSize',10); hold on;
%     plot(nu2ar,zlGampar./z0Gar,'k','LineWidth',lw);
%     xlim([1 3]);
%     grid off;
%     ylabel('dh/h0');
%     xlim([1 2.5])
%     set(gca,'Fontsize',fsz);
%     set(gca,'Fontsize',fsz,'TickLength',[tl tl],'Linewidth',lw2);
       
%     subplot(615)
%     tfl=[0:TFlmax];
%     plot(tfl,(z0TFf1+(1-z0TFf1)/30.*tfl)); hold on;
%     %plot(tfl,z0G*z0TFf1*ones(size(tfl)),'k--');
%     grid on;
%     ylabel('z0TFf1');
%     xlabel('TF Fault length (km)');
%     
%     subplot(616)
%     zlGampTFf=zlGampTFf1+(1-zlGampTFf1)/(TFlmax-TFl1).*(tfl-TFl1);
%     %zlGampTFf(tfl>TFl1)=zlGampTFf1;
%     plot(tfl,zlGampTFf); hold on;
%     grid on;
%     ylabel('zlGampTF1');
%     xlabel('TF Fault length (km)');
end

kap=nu_k*kcond/(rho*cp)*1e-6*(3600*24*365.25*1e6);

zLG=z0G+zLGamp-zLGamp.*exp(-(x-x0).^2/(2.*sig.^2));  %Gaussian cooling

%--------------------------------------------------------------------------
%Slow cooling
%--------------------------------------------------------------------------
thetaL=Tsol/1350;
etaL=erfinv(thetaL);
ifast1=find(abs(x0-x-Gdistfac*sig)==min(abs(x0-x-Gdistfac*sig)));
ifast2=find(abs(x-x0-Gdistfac*sig)==min(abs(x-x0-Gdistfac*sig)));

zLa=2*etaL.*sqrt(kap*abs(x-x0)/u);
zshift=mean(zLG([ifast1 ifast2])-zLa([ifast1 ifast2])); %shifting zLa down to Gaussian level; 
zLa=zshift+zLa;

zLa(ifast1:ifast2)=zLG(ifast1:ifast2);