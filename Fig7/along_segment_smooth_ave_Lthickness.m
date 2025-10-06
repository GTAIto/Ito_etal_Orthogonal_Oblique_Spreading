%==========================================================================
% Averages lithospheric thickness along axis
%==========================================================================
interp_type='linear';
interp_type='spline';

nprofs=length(yprof0);
for k=1:nprofs
    yprof=yprof0(k);
    jprofn=find(abs(y-yprof)==min(abs(y-yprof)),1);
    lthick_cc_ave=lthick_cc_ave+interp1(x-xcnew,lthick(jprofn,:),xcc,interp_type)./nprofs;
    
end