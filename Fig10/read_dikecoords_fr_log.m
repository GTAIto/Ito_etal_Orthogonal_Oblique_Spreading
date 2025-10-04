%--------------------------------------------------------------------------------------------
% Dike zone coords
%--------------------------------------------------------------------------------------------

grepcommand='!grep "Current time" log | awk ''{print $4}'' >! junk'; eval(grepcommand);
junk=load('junk');
time1=junk(1); 
%if (exist('./dcoords_current.txt','file')==0)
    disp(['Creating dcoords_current.txt for istep=' num2str(istep)])
    grepcommand=['!grep "303030.3030 ' num2str(istep) '" ' logdir ' >! dcoords_current.txt'];eval(grepcommand);
% else
%     disp('Reading current dike coords file from prior log')
% end
%!cp dcoords_current.txt junk.txt
dat_coords=load('dcoords_current.txt');

id3=find(dat_coords(:,end-1)==ndyndike);
% dat3=dat3(id3,:);


ycent_log=dat_coords(:,3); 
xcentold=dat_coords(:,4);
xshift=dat_coords(:,5);
xcent_log=xcentold+xshift; %where the new center is set (within 0.5 elements of previious)

%xmaxsxx_log=dat_coords(:,6); %actual interpolated location of peak stress
%xcellmax=dat_coords(:,7);  %x coord of cell with greatest sxx
xbL=dat_coords(:,end-3);
xbR=dat_coords(:,end-2);
xcent_log=(xbL+xbR)./2;  %Use what LaMEM is actually using for dike center
time=dat_coords(1,end); 
dtime=time-time1;