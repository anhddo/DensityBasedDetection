%% Get Positive vector
function trainPos=extractPosHog(opts)
fprintf('Gathering positive subwindows:\n ');
trainPos={};
trainPosFiles=bbGt('getFiles',{opts.pGenSVM.trainPosDir});
n=numel(trainPosFiles);
for i=1:n
    im=loadImage(trainPosFiles{i},opts.pDetect.imageType);
    subHog=computeHog(im,opts.pDetect.hogType);
    trainPos{end+1}=subHog;
end
trainPos=cat(4,trainPos{:});
trainPos=reshape(trainPos,[],size(trainPos,4));
