function ims=createAllImForDenseTraining(opts)
ims=cell(1,opts.pDen.nTrnIm);
for i=1:opts.pDen.nTrnIm
    id=opts.pDen.imIdx(i);
    imName=fullfile(opts.dtsetOpts.datasetDir,'frames',sprintf('seq_%06d.jpg',id));
    im=getIm(imName,opts);
    %     imPrev=getIm(imIdx-1,p);
%     imwrite(im,sprintf('temp/im_%.6d.png',id));
    ims{i}=im;
end
end