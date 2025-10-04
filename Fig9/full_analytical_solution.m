%--------------------------------------------------------------------------
% ANALYTICAL solution 
%--------------------------------------------------------------------------
g=9.8;
%if (exist('weak','var')==0); weak=0.5; end;
phi=30;
xTF=0;
TFfac=1.2;  %Add a bit to account for ductile flow beneath
TFfac=1.0;
xfault=1;
jR=find(abs(x-(xridge-xfault))==min(abs(x-(xridge-xfault))),1);
W=2*xridge;
%L=0.75*2*xridge;  %commented out 4/30/25
%dist4sigR=2.5;  %increase this to decrease sigR
dist4sigR=exp(1);
%L=0.75*W;
%L=20;

sigR=rho*g*sind(phi)/(1+sind(phi))*((z0G+zLGamp/dist4sigR)*1e3).^2./1e9;  %Tsol=1000 for LaMEM Model & shallower isotherm for analytic
%sigR=rho*g*sind(phi)/(1+sind(phi))*((z0G+0.6*zLGamp/2)*1e3).^2./1e9;  %Tsol=900 for LaMEM Model
%sigR=rho*g*sind(phi)/(1+sind(phi))*((z0G)*1e3).^2./1e9;  %Tsol=900 for LaMEM Model
%sigR=rho*g*sind(phi)/(1+sind(phi))*(zL(jR)*1e3).^2./1e9;  %Tsol=900 for LaMEM Model

j4TFLthickness=find(abs(x-xTF)==min(abs(x-xTF)));
zTF=zLa(j4TFLthickness);
%zTF=mean(zLa(x>=0 & x <=xridge));

tauTF=rho*g*tand(phi.*(1-weak)).*(TFfac.*zTF*1e3).^2./2/1e9;  %LaMEM reduces friction agnel see constEq.cpp
zLa_array=ones(Ny,1)*zLa;
%zLa_array=lthick;  disp(['>>>Model lithosphere thickness is LaMEM lthick!'])



%dx=0.2;
%[xan, yan]=meshgrid([0:dx:W]-xridge,[0:dx:L]); xshift=0;
[xan,yan]=meshgrid(x,y);
%tauTF=600; %sigR=550;
[fxx_a,fxy_a]=analytical_soln(xan+xridge,yan,sigR,tauTF,W,L);
%fxx_a(y>=0 & y<yTFfxx,x>=-xridge & x<=xridge)=sigR;  %Adding TF fxx

fxx_a(find(xan>xridge))=sigR;
sxx_a=fxx_a./zLa_array;
sxy_a=fxy_a./zLa_array;

jj=find(1<=y & y<=min([ymax L]));
jj=find(1<=y & y<=ymax);  %debugging;
%jj=find(y<=ymax-1);  %debugging
fxx_a_ave=mean(fxx_a(jj,:),1);
sxx_a_ave=mean(sxx_a(jj,:),1);  
