%% sliding widow detect
function [bb,features]=detectSL(im,SVMModel,pDetect)
[m,n,~]=size(im);
padFull=floor(m/8);im=imPad(im,padFull,'replicate');
[boxes,scores1,features,~]=fineDetect(im,SVMModel,pDetect);
if ~isempty(boxes)
    boxes=boxes-padFull;
    xmin=boxes(1,:);ymin=boxes(2,:); xmax=boxes(3,:); ymax=boxes(4,:);
    ind=(xmin>=1).*(ymin>=1).*(xmax<=n).*(ymax<=m); ind=logical(ind);
    boxes=boxes(:,ind); scores1=scores1(ind); features=features(:,ind);
end
bb=convertBB(boxes,'xywh',scores1);
bb=bbNms(bb,'ovrDnm','min');