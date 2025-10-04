
clear dat3;

TFlength=0;
%if (exist('./dcoords.txt','file')==0) 
    grepcommand=['!grep "303030.3030" ' logdir ' >! dcoords.txt']; eval(grepcommand);
    disp('Reading and creating dike history')
% else
%     disp('Reading dcoords file from prior log file')
% end
dat3=load('dcoords.txt');
%Originally  "303030.3030 (jr->ts->istep+1), ycell, xcenter, xshift, 
%x_maxsxx, COORD_CELL(ixmax, sx, fs->dsx), CurrPhTr->celly_xboundL[lj], CurrPhTr->celly_xboundR[lj], (LLD)(nD), dtime);

%Now: 303030.3030 (jr->ts->istep+1), ycell, xcenter, xshift, 
% CurrPhTr->celly_xboundL[lj], CurrPhTr->celly_xboundR[lj], (LLD)(nD), dtime)
cols=size(dat3,2);

[isteps,iu]=unique(dat3(:,2));
time=(dat3(iu,end));
tmax=time(1)+100*dtave;
%tmax=2.62+dtave; %nuk3
%tmax=1.8+dtave;  %nuk1_2
%tmax=5.5;
%istepmax=1000;
if(exist('istepmax','var'))
   istepsplot=isteps(find(isteps<=istepmax));
   tmax=time(find(isteps==istepsplot(end)));
else
   istepsplot=isteps(find(time<=tmax));
end
ytip=0.25;
is=0;
%istep=isteps(1);
isplot=1;

for is=1:length(istepsplot)
%while istep<980
    %is=is+1;
    iistep=isteps(is);
    if (mod(iistep,isplot)==0 && 0 && showfig==1)
        figure(10); clf;    
        set(gcf,'Color','w')
    end
    counter=0;
    for is2=1:is
        ii2=find(dat3(:,2)==istepsplot(is2));
        y2=dat3(ii2,3); %y-location
        %x2=(dat3(ii2,6)+dat3(ii2,7))./2;
        x2=(dat3(ii2,cols-3)+dat3(ii2,cols-2))/2;  %Old indices for new center
        if (mod(iistep,isplot)==0 && mod(is2,isplot)==0 && 0  && showfig==1)
            counter=counter+1;
            if (mod(counter,2)==0)
            plot(x2,y2,'-','Color',[0.5 0.8 1]); hold on;
            %plot(dat3(ii2,8),y2,'-','Color',[0.5 0.8 1]); hold on;
            %plot(dat3(ii2,9),y2,'-','Color',[0.5 0.8 1]); hold on;
            else
            plot(x2,y2,'-','Color',0.0*[1 1 1]); hold on;
            %plot(dat3(ii2,8),y2,'-','Color',0.0*[0.5 0.8 1]); hold on;
            %plot(dat3(ii2,9),y2,'-','Color',0.0*[0.5 0.8 1]); hold on;
            end
        end
    end
    %disp(num2str(istepsplot(is)));
    ii=find(dat3(:,2)==istepsplot(is));
    y=dat3(ii,3); 
    %x=dat3(ii,4)+dat3(ii,5);
    x=(dat3(ii2,cols-3)+dat3(ii2,cols-2))/2;
    jj=find(abs(y)==ytip);
    TFlength(is)=abs(x(jj(1))-x(jj(2)));
    if (mod(iistep,isplot)==0 && 0)
        plot(x,y,'r.'); hold on;
    end
    grid on;
    %text(-15,25,['istep=' num2str(istepsplot(is))]);
%     title(['istep=' num2str(istepsplot(is)) '; t=' num2str(time(is)) ', Myr']);
%     disp('hit return to continue >'); pause

    if (0) plot(x,y,'r.'); hold on; end
    grid on;
end
    
nTF=length(TFlength);

ii=find(time<=time(1)+dtave);
ii=find(time>dtstart & time<=time(1)+dtave);
% ii2=find((TFlength(1)-TFlength(:))<=TFlength_measure_rate);
% if (length(ii2)>length(ii1)); 
%     ii=ii1;
% else
%     ii=ii2;
% end
p=polyfit(time(ii),TFlength(ii),1);
dwdt=p(1);

if (show_dike_hist==1)
    eval(['figure(' fig2 '); clf;']);
    set(gcf,'Color','w')
    plot(time(1:nTF),TFlength,'.-'); hold on;
    plot(time(ii),polyval(p,time(ii),'k'));
    xlabel('Time (Myr)');
    ylabel('TF length, km');
    %mean_slope=(TFlength(ii(end))-TFlength(1))/(time(ii(end))-time(1));
    %axis([time(1) time(1)+dtave 20 30]);
    grid on
    precis=1000;
    %ylim([20 30]);
    title([model ': dwdt=' num2str(round(precis*dwdt)/precis) 'km/Myr']);
end