

%--------------------------------------------------------------------------------------------
% Stresses before smoothing
%---------------------------------------------------------------------------------------------
if (exist('./sxx_Pmag.txt','file')==0)
    grepcommand=['!grep "101010.1010 ' num2str(istep) '" log >! sxx_Pmag.txt']; eval(grepcommand);
else
    disp('Reading existing file: sxx_Pmag.txt from prior log file');
end
dat_stress_nf=load('sxx_Pmag.txt');
id1=find(dat_stress_nf(:,7)==ndyndike);
dat_stress_nf=dat_stress_nf(id1,:);

xdc=dat_stress_nf(:,3); ydc=dat_stress_nf(:,4);
nx=find(ydc(2:end)~=ydc(1:end-1),1);
ny=length(xdc)./nx;

xc=dat_stress_nf(1:nx,3); yc=unique(dat_stress_nf(:,4));
[Xc,Yc]=meshgrid(xc,yc);

sxx_ave_log=reshape(dat_stress_nf(:,5),nx,ny)'*1e3;
Pmag_log=reshape(dat_stress_nf(:,6),nx,ny)'*1e3;
zsol_log=reshape(dat_stress_nf(:,8),nx,ny)';
%--------------------------------------------------------------------------------------------
% Stresses after smoothing
%---------------------------------------------------------------------------------------------
if (exist('./sxxfilt.txt','file')==0);
    grepcommand=['!grep "202020.2020 ' num2str(istep) '" log >! sxxfilt.txt']; eval(grepcommand);
else
    disp('Reading existing file: sxxfilt.txt from prior log file');
end
dat_stress_f=load('sxxfilt.txt');
id2=find(dat_stress_f(:,7)==ndyndike);
dat_stress_f=dat_stress_f(id2,:);

sxx_eff_filt_log=reshape(dat_stress_f(:,5),nx,ny)'*1e3;
Pmag_filt_log=reshape(dat_stress_f(:,6),nx,ny)'*1e3;

%
if (0)
    junk=Pmag_filt_log;
    for jj=1:length(xcent_log)
        j=find(Yc(:,1)==ycent_log(jj));
        junk(j,:)=Pmag_filt_log(j,:).*magPfac.*exp(-0.5.*((xcent_log(jj)-Xc(j,:))/magPwidth).^2);
    end    
    Pmag_filt_log=junk;
end

sxx_totave_filt_log=sxx_eff_filt_log-Pmag_filt_log;


