%==========================================================================
%Computes statistics from analytical solutions of Fxx for comparison
%with LaMEM Models. 
%==========================================================================
%-------------------------------------------------------------------------
% Analytical Solution
%-------------------------------------------------------------------------
nu2array=flipud([1:0.1:2.7]');
%nu2array=[0.8:0.1:2.2]';
dikehalfwidth=0.75;
dist_find_peak=dikehalfwidth;
dist_ave=2*dikehalfwidth;

xL=-2; xR=2;
xridge=15;
ymax=6.25;
yTFfxx=1;

x=[0:0.1:2*xridge]; %These are relative to LaMEM origin
% xcc=x-xridge;
% xcc=[xL:0.1:xR];
y=[0:0.1:ymax];
Ny=length(y);
%jj=find(y>0);
weak=0.5;
nu1=1;

nnk=length(nu2array);
diffs_ave_a=zeros(1,nnk);
dsnorm_a=zeros(1,nnk);
dsnorm2_a=zeros(1,nnk);
fxxslope2_a=zeros(1,nnk);
fxxslope1_a=zeros(1,nnk);
h0_a=zeros(1,nnk);
dh_a=zeros(1,nnk);
lthick_TF_a=zeros(1,nnk);

for nk=1:length(nu2array)
    nu2=nu2array(nk);
    model_lithosphere;
    full_analytical_solution; 
    
    [lthick_TF_a(nk),diffs_ave_a(nk),dsnorm2_a(nk),fxxslope1_a(nk),h0_a(nk),dh_a(nk),sxx_a_ave,fxx_a_ave]=...
    stats4analytical_solns(j4TFLthickness,zLa,x,y,xridge,xL,xR,fxx_a_ave,sxx_a_ave,dist_ave,dist_find_peak);
%     lthick_TF_a(nk)=zLa(j4TFLthickness);
%     x_cent=x-xridge;    %node values relative to old dike center
%     xcc=x_cent;
%     il=find((xL<=x_cent & x_cent<0)); ir=find((0<x_cent  & x_cent<=xR));
%     ilcc=il; ircc=ir;
%     
%     fxx_a_ave=mean(fxx_a(jj,:),1);
%     sxx_a_ave=mean(sxx_a(jj,:),1);
%     
%     diff_sxx_ave=(fliplr(sxx_a_ave(ilcc))-(sxx_a_ave(ircc)));
%     xccr=xcc(ircc);
%     diffs_ave_a(nk)=mean(diff_sxx_ave(xccr<=dist_ave));
%     
%     smax_a=max(sxx_a_ave(abs(xcc)<=dist_find_peak));
%     iends=find(abs(xcc)==dist_ave);
%     sig_var_a=smax_a-mean(sxx_a_ave(iends));
%     
%     dsnorm_a(nk)=diffs_ave_a(nk)./smax_a;
%     dsnorm2_a(nk)=abs(diffs_ave_a(nk)./sig_var_a);
%     
%     islope_IC=find(x_cent<0 & x_cent>=xL);
%     islope_OC=find(x_cent>0 & x_cent<=xR);
%     fnorm=sigR;         
%     
%     mbIC=polyfit(x_cent(islope_IC),fxx_a_ave(islope_IC),1);
%     mbOC=polyfit(x_cent(islope_OC),fxx_a_ave(islope_OC),1);
%     
%     fxxslope2_a(nk)=-mean([mbIC(1) mbOC(1)]);
%     fxxslope1_a(nk)=-mbIC(1);
%     
    if (nu2==200)
        figure(100); clf;
        subplot(311);
        plot(xcc,fxx_a_ave);
        ylabel('fxx analytic');
        ylim([200 1000]);
        xlim([xL xR])
        grid on;
        
        subplot(312)
        plot(xcc,sxx_a_ave); hold on;
        plot(xcc(iends),sxx_a_ave(iends),'o')
        [nk nu2 sxx_a_ave(iends)]
        ylabel('sxx_a_ave')
        ylim([38 120]);
        xlim([xL xR])
        grid on;
        
        subplot(313)
        plot(xcc,zLa)
        ylim([1 12]);
        xlim([xL xR])
        ylabel('Lith. Thickness')
        set(gca,'YDIR','reverse')
        grid on;
        disp('Paused')
        [z0G zLGamp sig nu_k tauTF sigR zLa(j4TFLthickness)]
        [h0_a(nk) dh_a(nk) h0]
        pause
    end

end