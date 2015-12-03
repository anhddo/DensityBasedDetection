function ims=createAllImForDenseTraining(p)
ims=cell(1,p.pDen.nTrnIm);
for i=1:p.pDen.nTrnIm
    id=p.pDen.imIdx(i);
    imName=fullfile(p.dtsetOpts.datasetDir,'frames',sprintf('seq_%06d.jpg',id));
    im=getIm(imName,p);
    %     imPrev=getIm(imIdx-1,p);
%     imwrite(im,sprintf('temp/im_%.6d.png',id));
    ims{i}=im;
end
end