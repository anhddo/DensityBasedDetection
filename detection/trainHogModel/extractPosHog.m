%% Get Positive vector
function trainPos=extractPosHog(p)
displayInline;
v2struct(p);
fprintf('Gathering positive subwindows:\n ');
trainPos={};
trainPosFiles=bbGt('getFiles',{trainPosDir});
n=numel(trainPosFiles);
for i=1:n
    im=loadImage(trainPosFiles{i},imageType);
    subHog=computeHog(im,hogType);
    trainPos{end+1}=subHog;
    displayInline(sprintf('%d/%d\n',i,n));
end
trainPos=cat(4,trainPos{:});
trainPos=reshape(trainPos,[],size(trainPos,4));
