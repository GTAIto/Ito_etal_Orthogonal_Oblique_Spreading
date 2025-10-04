%==========================================================================
% Compute lithospheric thickness from LaMEM 
% output files (not log file)  
%--------------------------------------------------------------------------

zsol=zeros(Ny,Nx);
lthick=zsol;
for j=1:Ny
    for i=1:Nx
        %kk=find(temperature(2:Nz,j,i)<=Tsol & temperature(1:Nz-1,j,i)>Tsol)+1;  %shallowest node T>Tsol
        kk=find(temperature(1:Nz-1,j,i)>Tsol,1,'last')+1;  %first node cooler than Tsol
        ksf=find(phase(1:Nz-1,j,i)>0.9,1,'last'); %indice of seafloor
        dT=temperature(kk-1,j,i)-temperature(kk,j,i);
        zsol(j,i)=z(kk)+(z(kk-1)-z(kk))/dT*(Tsol-temperature(kk,j,i));  %interpolating downward to greater depths lower k
        %zsol(j,i)=z(kk);
        lthick(j,i)=z(ksf)-zsol(j,i); 
        %lthick(j,i)=0*topo_Z(j,i)-zsol(j,i); 
    end
end
%disp('****** Better Fix compute_lthick!! ****************');

