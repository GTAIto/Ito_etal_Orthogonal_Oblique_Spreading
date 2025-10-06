%==========================================================================
% Compute mean total stress and magma pressure in lithosphere from LaMEM 
% output files (not log file)  
%--------------------------------------------------------------------------

zsol=zeros(Ny,Nx);
%lthick=zsol;   8_15_24
P_ave=zsol;
Plith_ave=zsol;


dPmag=zsol;
sigtot=dev_stress;
sigtot(:,:,:,1)=sigtot(:,:,:,1)-pressure;
sigtot(:,:,:,5)=sigtot(:,:,:,5)-pressure;
sigtot(:,:,:,9)=sigtot(:,:,:,9)-pressure;
sxx_tot_ave=zeros(Ny,Nx);
sxy_tot_ave=zeros(Ny,Nx);
syy_tot_ave=zeros(Ny,Nx);
Pmag_ave=zeros(Ny,Nx);


kmax=find(z<zmax_magma,1,'last');
for j=1:Ny
    for i=1:Nx
        %kk=find(temperature(2:Nz,j,i)<=Tsol & temperature(1:Nz-1,j,i)>Tsol)+1;  %shallowest node T>Tsol
        kk=find(temperature(1:Nz-1,j,i)>Tsol,1,'last')+1;  %first node cooler than Tsol
        ksf=find(phase(1:Nz-1,j,i)>0.8,1,'last'); %indice of seafloor
        dT=temperature(kk-1,j,i)-temperature(kk,j,i);
        zsol(j,i)=z(kk)+(z(kk-1)-z(kk))/dT*(Tsol-temperature(kk,j,i));  %interpolating downward to greater depths lower k
        %lthick(j,i)=z(ksf)-zsol(j,i); %this with f=1 or f=0 below gives less step like pattern  %8_15_24
        
        %lthick(j,i)=z(ksf)-z(kk);  %this with f=1 or f=0 below causes step-like pattern
        
        f=1;%testing cause for step-like pattern in dike.cpp Compute_sxx_magP
        dzsol=f*(zsol(j,i)-z(kk));
        
        %disp('In Compute sxx'); pause;
        dum=(pressure(kk-1,j,i)-pressure(kk,j,i))./(z(kk-1)-z(kk)).*dzsol; 
        P_ave(j,i)=(sum(pressure(kk:ksf,j,i,1).*dz(kk:ksf))-(pressure(kk,j,i,1)+dum)*dzsol)/lthick(j,i);     
        
        dum=(Plith(kk-1,j,i,1)-Plith(kk,j,i,1))./(z(kk-1)-z(kk)).*dzsol;
        Plith_ave(j,i)=(sum(Plith(kk:ksf,j,i,1).*dz(kk:ksf))-(Plith(kk,j,i,1)+dum)*dzsol)./lthick(j,i);
        
        dum=(sigtot(kk-1,j,i,1)-sigtot(kk,j,i,1))./(z(kk-1)-z(kk)).*dzsol;
        sxx_tot_ave(j,i)=(sum(sigtot(kk:ksf,j,i,1).*dz(kk:ksf))-(sigtot(kk,j,i,1)+dum)*dzsol)./lthick(j,i);
        
        dum=(sigtot(kk-1,j,i,2)-sigtot(kk,j,i,2))./(z(kk-1)-z(kk)).*dzsol;
        sxy_tot_ave(j,i)=(sum(sigtot(kk:ksf,j,i,2).*dz(kk:ksf))-(sigtot(kk,j,i,2)+dum)*dzsol)./lthick(j,i);
        
        dum=(sigtot(kk-1,j,i,5)-sigtot(kk,j,i,5))./(z(kk-1)-z(kk)).*dzsol;
        syy_tot_ave(j,i)=(sum(sigtot(kk:ksf,j,i,5).*dz(kk:ksf))-(sigtot(kk,j,i,5)+dum)*dzsol)./lthick(j,i);
        
        dPmag(j,i)=-(zmax_magma-zsol(j,i)).*drhomagma*g/1e3;  %negative bc zmax_magma-zsol <0 
    end
end

Pmag_ave=Plith_ave+dPmag;

sxx_eff_builtnofilt=sxx_tot_ave+Pmag_ave;
%magpresence=(zsol-zsol_max)./(max(zsol(:))-zsol_max);
