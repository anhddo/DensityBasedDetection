function [time,boxes]=denDetectNoPls(img,opts)
time=tic;
[pesClust,denIm,noiseReduce]=pedestrianCluster(img,opts);
[score,centerDense]=denseSearch(hogIms{sInd},cenPes,w,h,opts.model.svm,...
    opts.pDetect.cellSize,range);
end