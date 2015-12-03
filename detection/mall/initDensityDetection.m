function pDetectFrame=initDensityDetection(dataset)
if strcmp(dataset,'mall')
    p=mallDetectionParameter;
elseif strcmp(dataset,'vivo')
    p=vivoDetectionParameter;
end
v2struct(p);
%%debug para
dCenBox=true; dClust=true; dBB=true; dDenIm=true; dDenFilt=true;

pDenFile=fullfile(matDir,sprintf('%spDen.mat',dataset));
try
    load(pDenFile);
catch
    malldensity;
    load(pDenFile);
end
% pDen.dDenIm=dDenIm; pDen.dDenFilt=dDenFilt; pDen.colorDen=colorDen;
% pDen.bandwidth=bandwitdh;


modelPath=fullfile(matDir,sprintf('%sSVMModel.mat',dataset));
betaPath=fullfile(matDir,sprintf('%sBETA.mat',dataset));
try load(modelPath) ;catch, trainSVMModel(p,modelPath); load(modelPath);end;
try load(betaPath);catch, mallPlsTrain(dataset); load(betaPath);end;

totalTime=0;
dendir=fullfile('temp','density');
if ~exist(dendir,'dir'),mkdir(dendir);end;
if ~exist('testFiles'),testFiles=[];end;
pDetectFrame=v2struct(imageType,SVMModel,BETA,testFiles,pDen,pDetect,...
    totalTime,dClust,writeBb,dBB,dCenBox,dCenPls,dDenIm,dDenFilt);
end
