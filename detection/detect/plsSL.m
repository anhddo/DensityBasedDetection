% function boxes=plsSL(im,SVMModel,BETA,pPls)
function [time,boxes]=plsSL(img,opts)
e=tic;
[m,n,~]=size(img);
padFullIm=floor(m/16);img=imPad(img,padFullIm,'replicate');
boxes=findCenter(img,opts);
if ~isempty(boxes)
    boxes=removeOutOfRangeBox(boxes,padFullIm,m,n);
end
boxes=bbNms(boxes);
boxes=bbNms(boxes,'ovrDnm','min');
time=toc(e);