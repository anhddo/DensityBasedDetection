function SVMModel=mallTrainHogModel(p)
v2struct(p);
% rmdir(trainPosDir);
if ~exist(trainPosDir,'dir'),
    createGenImage(p);
end;
if ~exist('trainPos.mat','file'),
    trainPos=extractPosHog(p); save('trainPos','trainPos');
else
    load('trainPos');
end;
if ~exist('trainNeg.mat','file'),
    p.nNeg=size(trainPos,2)*5;
    trainNeg=mallExtractNegHog(p);
    save('trainNeg','trainNeg');
else
    load('trainNeg');
end;
if ~exist('svmstage0.mat','file')
    SVMModel=trainSVMModel(trainPos,trainNeg,p);
    save('svmstage0','SVMModel');
else
    load('svmstage0');
end
nRetrain=2;
neg=trainNeg;
for i=1:nRetrain
    fprintf('Retrain stage %d\n',i);
    hardNeg=getHardNeg(p,SVMModel);
    fprintf('%d hard negatives\n',size(hardNeg,2));
    if size(hardNeg,2)>0
        neg=[neg hardNeg];
        SVMModel=trainSVMModel(trainPos,neg,p);
        save(sprintf('svmstage%d',i),'SVMModel');
    end
end
save('mallSVMModel','SVMModel');
end

function features=getHardNeg(p,SVMModel)
v2struct(p);
scaleRange=2.5./(1.05.^(0:10));
    pDetect=struct('cellSize',cellSize,'hogType',hogType,'threshold',0,...
        'step',1,'H',H,'W',W,'pad',16,'scaleRange',scaleRange);
im=loadImage('background.jpg',imageType);

[~,features]=detectSL(im,SVMModel,pDetect);

end

function trainNeg=mallExtractNegHog(p)
v2struct(p);
displayInline;
fprintf('Gathering negative subwindows:\n');
im=loadImage('background.jpg',imageType);
scale=1.05.^(-5:10);
trainNeg={};
for s=scale
    sim=imResample(im,s);
    sHog=computeHog(sim,hogType);
    [m,n,~]=size(sHog);
    for i=1:m-H/cellSize+1
        for j=1:n-W/cellSize+1
            trainNeg{end+1}=sHog(i:i+H/cellSize-1,j:j+W/cellSize-1,:);
        end
    end
    displayInline(sprintf('%d/%d\n',i,n));
    if numel(trainNeg)>nNeg,break;end;
end
trainNeg=cat(4,trainNeg{:});
trainNeg=reshape(trainNeg,[],size(trainNeg,4));
end