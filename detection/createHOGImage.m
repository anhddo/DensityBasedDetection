function hogIms=createHOGImage(img,opts)
nScale=numel(opts.pDetect.scaleRange);
hogIms=cell(1,nScale);
for i=1:nScale
    s=opts.pDetect.scaleRange(i);
    imS=imResample(img,s);
    hogIms{i}=computeHog(imS,opts.pDetect.hogType);
end
end