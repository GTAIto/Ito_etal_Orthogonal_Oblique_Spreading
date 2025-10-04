%==========================================================================
% For force_analyze_node or LaMEM_vs_analytic_TF_eff
% Computes smooth sxx or fxx across axis and averages along-axis near the
% segment tip to quantify the transform fault effect on cross-axis stress 
% or force profiles 
%==========================================================================
interp_type='linear';
interp_type='spline';

nprofs=length(yprof0);

fxx_cc_profs=zeros(nprofs,length(xcc));
    
fxx_cc_ave=zeros(1,length(xcc));
lthick_cc_ave=zeros(1,length(xcc));
% xcent_LaMEM=zeros(length(x),nprofs);    %actual coords of LaMEM output relative to dike 
% fxx_cc_LaMEM=zeros(length(x),nprofs); %actual values of LaMEM output
diff_fxx_ave=zeros(1,sum(ilcc));

fade=0.7;
mbIC=0;  %initialize slope intercept for averaging
mbOC=0;
mbnIC=0;
mbnOC=0;

for k=1:nprofs
    yprof=yprof0(k);

    jprof=find(abs(y-yprof)==min(abs(y-yprof)),1);
    jcent=find(abs(ycent_log-yprof)==min(abs(ycent_log-yprof)),1);  %index of current dike 
    %jcent2=find(abs(y-yprof)==min(abs(y-yprof)),1);               %global index
    
    xcold=xcentold(jcent);  %center of dike from log
    xcnew=xcent_log(jcent); %new center of dike from log
    
    %sxxmax=max(xx_eff(jprof,:));
    dw=(xbR(jcent)-xbL(jcent));
    xwin=6*dw;
    x_cent=x-xcold;    %node values relative to old dike center

    %--------------------------------------------------------------------------
    % Profiles of sxx_cc, which is smoothed version of sxx_eff
    %--------------------------------------------------------------------------
    il=(x_cent<=0); ir=(x_cent>0);
%     xcent_LaMEM(:,k)=x_cent'; 
%     fxx_cc_LaMEM(:,k)=xx_eff(jprof,:)';  
    fxx_cc=interp1(x_cent,xx_eff(jprof,:),xcc,interp_type);
    fxx_cc_ave=fxx_cc_ave+fxx_cc./nprofs;
    
    if (ndyndike==1)
        islope_IC=find(x_cent>0 & x_cent<=xR);
        islope_OC=find(x_cent>=xL & x_cent<0);
        fnorm=mean(fxx_cc(xcc<0));
    else
        islope_IC=find(x_cent<0 & x_cent>=xL);
        islope_OC=find(x_cent>0 & x_cent<=xR);
        fnorm=mean(fxx_cc(xcc>0));         
    end

    fxx_cc=fxx_cc/fnorm;
    fxx_cc_profs(k,:)=fxx_cc;
    
    mbnIC=mbnIC+polyfit(x_cent(islope_IC),xx_eff(jprof,islope_IC),1)./fnorm/nprofs;
    mbIC=mbIC+polyfit(x_cent(islope_IC),xx_eff(jprof,islope_IC),1)./nprofs;
    mbnOC=mbnOC+polyfit(x_cent(islope_OC),xx_eff(jprof,islope_OC),1)./fnorm/nprofs;
    mbOC=mbOC+polyfit(x_cent(islope_OC),xx_eff(jprof,islope_OC),1)./nprofs;
    %------------------------------------------------------------------
    % reflected stress profiles
    %-------------------------------------------------------------------

    if (ndyndike==2)
        diff_fxx=fxx_cc(ilcc)-fliplr(fxx_cc(ircc));
        xave=abs(xcc(ilcc));
        ii=xave<=dist_ave;
    else
        diff_fxx=fxx_cc(ircc)-fliplr(fxx_cc(ilcc));
        xave=abs(xcc(ircc));
        ii=xave<=dist_ave;
    end
    %fdiff_ave=fdiff_ave+sum(diff_fxx(ii))./length(ii);
 
    diff_fxx_ave=diff_fxx_ave+diff_fxx./nprofs;   
end
