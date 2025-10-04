%==========================================================================
%function [Pmag_cc_ave, sxx_cc_ave, sxxt_cc_ave,lthick_cc_ave]=stress_analyze_sxx_cc(xcentold,xcent_log,ycent_log,xc,yc,x,y,sxx_eff,Pmag,lthick,sxx_tot,Nx,nx,xcc,ilcc,ircc,xL,xR,xbL,xbR,yprof0,plot_indiv_profs,fig1,fig2)
%
%Computes and reflects mean stresses about (old) dike center
%xc=x location at center of cell
%xcc high res grid centered on dike 
%==========================================================================
interp_type='linear';
interp_type='spline';
%interp_type='cubic';
%interp_type='makima';
fignum=str2num(fig1)+ndyndike-1;

Pmag_cc_ave=zeros(1,length(xcc));
sxxt_cc_ave=zeros(1,length(xcc));
sxx_cc_ave=zeros(1,length(xcc));
lthick_cc_ave=zeros(1,length(xcc));
diff_sxx_ave=zeros(1,sum(ilcc));

nprofs=length(yprof0);
fade=0.7;
mb=0;  %initialize slope intercept for averaging
%--------------------------------------------------------------------------
% Along-segment stress smoothing
%--------------------------------------------------------------------------
sxx_lthick_alongsegment_smooth;

%--------------------------------------------------------------------------
% Some More stress calculations
%--------------------------------------------------------------------------
smax=max(sxx_cc_ave(abs(xcc)<=dist_find_peak));
snorm=1;
iends=find(abs(xcc)==dist_ave);
sig_var=smax-mean(sxx_cc_ave(iends));
%smax=max(sxx_cc_ave(abs(xcc)<=dist_ave));
%iends=find(abs(xcc)==dist_ave);
%sig_var=smax-mean(sxx_cc_ave(iends));
if (ndyndike==1)
    diff_sxx_ave=(sxx_cc_ave(ircc)-fliplr(sxx_cc_ave(ilcc)));
else
    diff_sxx_ave=(fliplr(sxx_cc_ave(ilcc))-(sxx_cc_ave(ircc)));
end
xccr=xcc(ircc);
sdiff_ave=mean(diff_sxx_ave(xccr<=dist_ave));

if (ndyndike==1)
    mslope=mb(1);
    diff_sxx_ave_norm=(sxx_cc_ave(ircc)-fliplr(sxx_cc_ave(ilcc)))./sig_var;
else
    diff_sxx_ave_norm=(fliplr(sxx_cc_ave(ilcc))-(sxx_cc_ave(ircc)))./sig_var;
    mslope=-mb(1);  %increases if mbl is less negative and
end
xccr=xcc(ircc);
sdiff_ave_norm=mean(diff_sxx_ave_norm(xccr<=dist_ave));
mthick=min(lthick_cc_ave);
dthick=max(lthick_cc_ave-mthick);

force_lthick_alongseg_smooth_ave;
%--------------------------------------------------------------------------
% Asymmetry in force profiles
%--------------------------------------------------------------------------
if (ndyndike==1)
  mslopen=mean([mbnIC(1) mbnOC(1)]);
  mslopen1=mbnIC(1);
  mslope=mean([mbIC(1) mbOC(1)]);
  mslope1=mbIC(1);

else
  mslopen=-mean([mbnIC(1) mbnOC(1)]);  %increases if mbl is less negative and
  mslopen1=-mbnIC(1);
  mslope=-mean([mbIC(1) mbOC(1)]);
  mslope1=-mbIC(1);
end
lthick_TF=mean(lthick(-xTF<X & X<xTF & -yTF <= Y & Y <= yTF));

out=          [ nu1 nu2  mthick dthick sdiff_ave dwdt  smax    sig_var sdiff_ave/smax sdiff_ave/sig_var abs(yprof0(1)) abs(yprof0(end)) weak mslope1 lthick_TF TFwidth mpw];
outs=sprintf('%4.2f %4.2f  %4.2f  %4.2f  %4.2f  %5.1f   %3.0f    %5.2f      %5.4f      %5.3f     %5.2f   %5.2f  %5.1f  %7.4f  %5.2f  %5.1f %8.3f', out');

%------------------------------------------------------------------
% PLOTS
%------------------------------------------------------------------
if (showfig==1)
    eval(['figure(' num2str(fignum) ');']);
    subplot(421);
    plot(xcc,sxx_cc_ave./sxx_cc_ave(find(xcc==0)),'k','Linewidth',2)
    plot(xcc,polyval(mb,xcc),'b-','Linewidth',1);
    title(model)

    subplot(422);
    cmap = crameri('-roma');
    colormap(cmap);
    pcolor(x(1:nx),y(1:ny),sxx_eff); shading flat; hold on;
    plot(xcentold,ycent_log,'k.')
    wincent=max(xcentold);
    if (caxon==1); caxis(climf); end
    %caxis([5 11]);
    c=colorbar(map_cbar_loc);%c.Label.String='MPa'; 
    axis([wincent-xwin wincent+xwin 0 yprof+2*xwin]);
    title([sprintf('t=%0.2g, dt=%0.3g Myr',time,dtime)]);
    if (ndyndike==1); axis([-wincent-xwin -wincent+xwin yprof-xwin 0.5]);end

    %--------------------------------------------------------------------------
    % Asymmetry in stress, not normalized
    %--------------------------------------------------------------------------
    subplot(423);
    plot(abs(xcc(ilcc)),sxx_cc_ave(ilcc)./snorm,'k','Linewidth',2); hold on;
    plot(xcc(ircc),sxx_cc_ave(ircc)./snorm,'b','Linewidth',2)
    xlabel('Distance from curr. axis (km)');
    grid on;
    xlim([0 dist_ave]);
    %ylim([max(sxx_cc_ave)-10; max(sxx_cc_ave)+1]);
    ylabel('mean \sigma_e_f_f (MPa)')
    title(sprintf('smax=%0.2g, sig_v_a_r=%0.3g mPa',smax,sig_var));

    subplot(424);
    plot(xccr,diff_sxx_ave,'b-','Linewidth',2);
    %sdiff_ave=sdiff_ave./sdiff_norm;
    title(['\Delta\sigma_x_x_a_v_e (MPa) = ' num2str(sdiff_ave)]);
    grid on;
    xlabel('Distance fr axis (km)');
    xlim([0 dist_ave]);

    %--------------------------------------------------------------------------
    % Asymmetry in normalize stress and slope
    %--------------------------------------------------------------------------
    subplot(425);
    plot(abs(xcc(ilcc)),sxx_cc_ave(ilcc)./smax,'k','Linewidth',2); hold on;
    plot(xcc(ircc),sxx_cc_ave(ircc)./smax,'b','Linewidth',2)
    xlabel('Distance from curr. axis (km)');
    grid on;
    xlim([0 dist_ave]);
    ylabel('mean \sigma_e_f_f, normalized')

    subplot(426);
    plot(xccr,diff_sxx_ave_norm,'b-','Linewidth',2);
    title(['\Delta\sigma_x_x_a_v_e, norm2 = ' num2str(sdiff_ave./sig_var)]);
    grid on;
    xlabel('Distance fr axis (km)');
    xlim([0 dist_ave]);

    %--------------------------------------------------------------------------
    % Profiles of individual stress parts and lith. Thickness
    %-------------------------------------------------------------------------
    %eval(['figure(' fig2 ');']);
    subplot(427);
    plot(xcc,Pmag_cc_ave'-0*Pmag_cc_ave(1),'r-','Linewidth',2); hold on;
    plot(xcc,sxx_cc_ave'-0*sxx_cc_ave(1),'k-','Linewidth',2); 
    plot(xcc,sxxt_cc_ave'-0*sxxt_cc_ave(1),'b-','Linewidth',2); 
    grid on;
    axis([xL xR -150 200]);
    ylabel('MPa'); xlabel('km');
    leg=legend('P_m','\sigma_e_f_f', '\sigma_t','Location','Best');
    leg.ItemTokenSize=[7,7,7];

    subplot(428);
    plot(xcc,lthick_cc_ave'-0.0*min(lthick_cc_ave),'k-','Linewidth',2);
    %xlim([xL xR]);
    axis([xL xR min(lthick_cc_ave)-0.5 min(lthick_cc_ave)+4]);
    axis([xL xR 2 15]);
    set(gca,'YDIR','Reverse')
    title([sprintf('h_0=%0.2g, dh=%0.3g km, dh/h_0=%0.3g',mthick,dthick,dthick./mthick)]);
    grid on;
    ylabel('Lith. thickness, h (km)'); xlabel('km');

    disp(' ');
    %disp(outs)
end
if (beenhere==0)
    outmean=out;
    beenhere=1;
else
    outmean=mean([outmean; out;]);
    disp('**** Mean of two tips ****');
    disp(['   n1  n2   h0    dh  sdiff   dw/dt   smax   sig_v_a_r  sdiffnorm1 sdiffnorm2  yprof1 yprof2  WTF   mslope lthick_TF TFwidth mpw']);
    outs=sprintf('%4.2f %4.2f  %4.2f  %4.2f  %4.2f  %5.1f   %3.0f    %5.2f      %5.4f      %5.3f     %5.2f   %5.2f  %5.1f  %7.4f  %5.2f     %5.1f  %8.3f', outmean');
    disp(outs)
end




