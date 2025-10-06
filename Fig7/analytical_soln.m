%==========================================================================
function [sigxx,sigxy]=analytical_soln(xan,yan,sigR,tauTF,W,L)
% Airy stress function solution 
% sigR = stress on ridge axis at x=W
% tauTF = shear stress on TF
%==========================================================================


%sigxx=(2*tauTF./L)*(W - xan + xan.*yan/L - yan.*(W/L))+sigR;
sigxx=(2*tauTF./L)*(W - xan).*(1-yan/L)+sigR;
sigxy=-tauTF.*(1-2.*yan./L+yan.^2./L.^2);

sigxx(yan>L)=sigR;  %debugging
sigxx(xan>W)=sigR;

ileft=find(abs(xan(1,:))==min(abs(xan(1,:)))); %all values for x<0 aren't part of the soln
ileft=max(ileft-1,1);

sigxx(:,1:ileft)=sigxx(:,ileft)*ones(1,ileft);  
sigmax=2*tauTF/L*W+sigR;


sigxx(sigxx>2*sigmax)=sigmax;

sigxy(sigxy>0)=0;
sigxy(sigxy<-tauTF)=-tauTF;
sigxy(yan>L)=0;