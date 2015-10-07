v2struct(mallDetectionParameter);
load(fullfile(matDir,'pDen.mat'));
estPath=fullfile(matDir,'estimate.mat');
load(fullfile(datasetDir,'perspective_roi.mat'));
pMapN=pMapN(1:pDen.spacing:end,1:pDen.spacing:end);
try
    load(estPath);
catch
    estimate=[];
    for i=1:1:2000
        imPath=fullfile(framesDir,sprintf('seq_%06d.jpg',i));
        im=getIm(imPath,pDen);
        tic;
        denIm=mallden(im,pDen);
        denIm=denIm.*pMapN;
        toc;
        estimate=[estimate sum(denIm(:))];     
    end
    save(estPath,'estimate');
end
plot(estimate,'r');
load(fullfile(datasetDir,'mall_gt.mat'));
% count=count(1:10:2000);
hold on;plot(count,'g');
err=abs(estimate'-count)/numel(estimate);
disp(sum(err))