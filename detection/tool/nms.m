function [wins,scores,ind] = nms(boxes,scores, overlap,type)
n=size(boxes,2);
saveBB=ones(1,n);
in=boxIntersect(boxes,boxes);
area=boxArea(boxes);
[aj,ai]=meshgrid(area,area);

if strcmp(type,'union')
    union=ai+aj-in;
    fraction=in./union;
elseif strcmp(type,'min')
    m=min(ai,aj);
    fraction=in./m;
end

ind=find(fraction>overlap);
[j,i]=ind2sub([n n],ind);
ind=scores(i)<scores(j);
saveBB(i(ind))=0;
ind=logical(saveBB);
wins=boxes(:,ind);
scores=scores(ind);