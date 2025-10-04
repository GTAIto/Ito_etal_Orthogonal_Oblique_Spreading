%==========================================================================
% Compute statistics from analytical solutions
function [lthick_TF_aF,diffs_ave_aF,dsnorm2_aF,fxxslope1_aF, h0_aF, dh_aF,sxx_a_ave,fxx_a_ave]= ....
    stats4analytical_solns(j4TFLthickness,zLa,x,y,xridge,xL,xR,fxx_a_ave,sxx_a_ave,dist_ave,dist_find_peak)
%==========================================================================
   
    lthick_TF_aF=zLa(j4TFLthickness);
    x_cent=x-xridge;    %node values relative to old dike center
    xcc=x_cent;
    il=find((xL<=x_cent & x_cent<0)); ir=find((0<x_cent  & x_cent<=xR));
    ilcc=il; ircc=ir;
    
%     fxx_a_ave=mean(fxx_a(y>0,:),1);xcc
%     sxx_a_ave=mean(sxx_a(y>0,:),1);
    ilcc_int=[ilcc(1)-1 ilcc ilcc(end)+1];
    sxx_a_l=interp1(abs(xcc(ilcc_int)),sxx_a_ave(ilcc_int),xcc(ircc),'spline'); %values on left size at same coords as right side
    diff_sxx_ave=((sxx_a_l)-(sxx_a_ave(ircc)));

    %diff_sxx_ave=(fliplr(sxx_a_ave(ilcc))-(sxx_a_ave(ircc)));
    xccr=xcc(ircc);
    diffs_ave_aF=mean(diff_sxx_ave(xccr<=dist_ave));
    
    smax_a=max(sxx_a_ave(abs(xcc)<=dist_find_peak));
    %iends=find(abs(xcc)==dist_ave);
    iends1=find(abs(xcc+dist_ave)==min(abs(xcc+dist_ave)));
    iends2=find(abs(xcc-dist_ave)==min(abs(xcc-dist_ave)));
    iends=[iends1 iends2]';
    sig_var_a=smax_a-mean(sxx_a_ave(iends));
    
    %dsnorm_a=diffs_ave_aF(nk)./smax_a;
    dsnorm2_aF=abs(diffs_ave_aF./sig_var_a);
    
    %disp(sprintf('diffs_ave_aF = %5.1f, sig_var_a=%5.1f, dsnorm2_aF=%5.3f \n ', [diffs_ave_aF sig_var_a dsnorm2_aF]));
    %dsig_sigvar=[abs(diffs_ave_aF) sig_var_a dsnorm2_aF]
    
    islope_IC=find(x_cent<0 & x_cent>=xL);
    islope_OC=find(x_cent>0 & x_cent<=xR);     
    
    mbIC=polyfit(x_cent(islope_IC),fxx_a_ave(islope_IC),1);
    mbOC=polyfit(x_cent(islope_OC),fxx_a_ave(islope_OC),1);
    
    %fxxslope2_a(nk)=-mean([mbIC(1) mbOC(1)]);
    fxxslope1_aF=-mbIC(1);
    
    h0_aF=min(zLa([il ir]));
    dh_aF=max(zLa([il ir])-h0_aF);
    %dh_h0_ratio=[dh_aF h0_aF dh_aF./h0_aF]
    