 


if (exist('wd0','var')==1)
    wd=wd0;
else
    wd=pwd
end
i1=find(wd=='T',1,'first');
i2=find(wd=='/',1,'last');
model=wd(i1:end);
cdum=extractAfter(model,'wTF'); 
weak=str2double(cdum(1:2));


ispace=find(model=='_');
iw=find(model=='w');


%     inu=find(model(1:end-1)=='u' & model(2:end)=='k');
%     nu1=str2num(model(inu+2));
if length(ispace>0)
    cdum=extractBetween(model,'nuk','_'); nu1=str2double(cdum(1));
    cdum=extractBetween(model,'_','wTF'); nu2=str2double(cdum(1));
%         model(ispace)='-';
%         nu2=str2num(model(ispace+1:iw-1));
else
    cdum=extractBetween(model,'nuk','wTF'); nu1=str2double(cdum(1));
    nu2=nu1;
end
TFwidth=str2num(model(2:3));
%weak=str2num(wd(i2-3:i2-2));