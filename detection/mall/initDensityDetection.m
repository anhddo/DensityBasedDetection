function pDetectFrame=initDensityDetection
p=mallDetectionParameter;
v2struct(p);
%%debug para
% dCenBox=true; dClust=true; dBB=true; dDenIm=true; dDenFilt=true;
writeBb=false;
dBB=false;dCenBox=false; dCenPls=false; dClust=false; dDenIm=false; dDenFilt=false;
colorDen=false; bandwitdh=3;

try
    load(fullfile(matDir,'pDen.mat'));
catch
    malldensity;
    load(fullfile(matDir,'pDen.mat'));
end
pDen.dDenIm=dDenIm; pDen.dDenFilt=dDenFilt; pDen.bandwidth=bandwitdh;
pDen.colorDen=colorDen;

modelName='mallSVMModel';
modelPath=fullfile(matDir,[modelName '.mat']);
try load(modelPath) ;catch, mallTrainHogModel(p); end;
try load(fullfile(matDir,'BETA.mat'));catch, mallPlsTrain; end

scaleRange=1./(1.04.^(-15:10));
pDetect=struct('cellSize',cellSize,'hogType',hogType,'threshold',-2,...
    'fineThreshold',-0.5,'H',H,'W',W,'xstep',xstep,'ystep',ystep,'pad',padSize,...
    'scaleRange',scaleRange,'bPad',16,'dCenBox',dCenBox,'dCenPls',dCenPls);
totalTime=0;
mkdir(fullfile('temp','density'));
pDetectFrame=v2struct(imageType,SVMModel,BETA,roi,testFiles,pDen,pDetect,...
    totalTime,dClust,writeBb,dBB,dCenBox,dCenPls,dDenIm,dDenFilt);
end
