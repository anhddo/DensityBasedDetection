function [centers,denIm0,noiseReduce]=pedestrianCluster(img0,opts)
img=img0(1:opts.pDen.spacing:end,1:opts.pDen.spacing:end,:);
denIm=mallden(img,opts);
denIm0=denIm;
t=max(denIm(:))*0.1;
denIm(denIm<t)=0;
denIm(denIm>=t)=1;

noiseReduce=medfilt2(denIm,[3 3]);
[r,c]=find(noiseReduce);
scale=size(img,1)/size(noiseReduce,1);
noiseReduce=imResample(noiseReduce,scale,'nearest');
x=[c r]';
[centers,~,~] = MeanShiftCluster(x,opts.pCLustering.bandwidth);
centers=centers*opts.pDen.spacing;

if opts.debugOpts.colorDen
    colormap('jet');
    clf;imagesc(denIm0);
    print(fullfile('temp','denImage.png'),'-dpng');
end
if opts.debugOpts.dDenIm
    clf;imshow(denIm);
    print(fullfile('temp','denIm.png'),'-dpng');
end
if opts.debugOpts.dDenFilt
    clf;imshow(noiseReduce);
    %     hold on;vl_plotpoint(x);
    print(fullfile('temp','denImfilt.png'),'-dpng');
end
end
%%