function [imPath,bbs]=getGtInfo(fname,inriaDir)
fcontent=readTextFile(fname);
imPath=sscanf(fcontent{3},'Image filename : %s');
imPath=imPath(2:end-1);
imPath=[inriaDir imPath];
s=sscanf(fcontent{4},'Image size (X x Y x C) : %d x %d x %d');
nPerson=sscanf(fcontent{6},'Objects with ground truth : %d');
persons=cell(1,nPerson);
bbs=zeros(4,nPerson);
for i=0:nPerson-1
%     centerStr=fcontent{17+7*i};
%     [s,e]=regexp(centerStr,'\(\d+, \d+\)');
%     person.center=sscanf(centerStr(s:e),'(%d, %d)');
    bboxStr=fcontent{18+7*i};
    [s,e]=regexp(bboxStr,'\(\d+, \d+\) - \(\d+, \d+\)');
    bbox=sscanf(bboxStr(s:e),'(%d, %d) - (%d, %d)');
    bbox=bbox';
    bbs(:,i+1)=bbox';
%     person.center=round((person.center+1)/p.spacing);
end
