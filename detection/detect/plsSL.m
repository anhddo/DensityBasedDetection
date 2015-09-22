function boxes=plsSL(im,SVMModel,BETA,pPls)
v2struct(pPls);
[m,n,~]=size(im);

padFullIm=floor(m/16);im=imPad(im,padFullIm,'replicate');

boxes=findCenter(im,SVMModel,BETA,pPls);

if ~isempty(boxes)
    boxes=removeOutOfRangeBox(boxes,padFullIm,m,n);
end
boxes=bbNms(boxes);
boxes=bbNms(boxes,'ovrDnm','min');
