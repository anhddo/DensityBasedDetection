function opts=allParameter(varargin)
datasetName=varargin{1};
dtsetOpts=initSettings(datasetName);

dtsetOpts.framesDir=fullfile(dtsetOpts.datasetDir,'frames');
thumbfile=fullfile(dtsetOpts.framesDir,'Thumbs.db');
if exist(thumbfile,'file'), delete(thumbfile);end;

H=128; W=64; cellSize=8; xstep=32;ystep=64;
% gtFile=fullfile(datasetDir,'vivoTrainGt.mat');

%pGen: crop pedestrian paramter for hogsvm
trainPosDir=fullfile(dtsetOpts.datasetDir,'trainPosCrop');
pGenSVM=struct('padFullIm',500,'padSize',16,'H',96,'isFlip',true,...
    'jumpstep',8,...
    'trainPosDir',trainPosDir,...
    'gtFile',dtsetOpts.gtFile,'framesDir',dtsetOpts.framesDir,...
    'choosedImg',{dtsetOpts.svmChoosedImg});

pGenPls=struct('padFullIm',500,'padSize',48,'H',96,'isFlip',false,...
    'gtFile',dtsetOpts.gtFile,'framesDir',dtsetOpts.framesDir,...
    'choosedImg',{dtsetOpts.plsChoosedImg});
trainPlsImageDir=fullfile(dtsetOpts.datasetDir,'plsTrainImage');
testPlsImageDir=fullfile(dtsetOpts.datasetDir,'plsTestImage');
pTrainPls=struct('trainPlsImageDir',trainPlsImageDir,'testPlsImageDir',testPlsImageDir);
pDetect=struct('cellSize',cellSize,'threshold',-2,'hogType','piotr',...
    'fineThreshold',-0.5,'H',H,'W',W,'xstep',xstep,'ystep',ystep,'pad',16,...
    'scaleRange',dtsetOpts.scaleRange,'imageType','rgb','svmTool','fitcsvm');

if nargin>1,
    pDenOpts=varargin{2};
    pDen=initDensityParameter(datasetName,pDenOpts);
else
    pDen=initDensityParameter(datasetName);
end

dtsetOpts=rmfield(dtsetOpts,{'scaleRange','plsChoosedImg','svmChoosedImg'});

debugOpts=struct('writeBb',false,'dBB',false,'dCenBox',false,...
    'dCenPls',false,'dClust',false,'dDenIm',false,'dDenFilt',false,...
    'colorDen',false);
pCLustering=struct('bandwidth',3);
opts=struct('datasetName',datasetName,'dtsetOpts',dtsetOpts,'pDen',pDen...
    ,'pGenSVM',pGenSVM,'pGenPls',pGenPls,'pDetect',pDetect,...
    'pTrainPls',pTrainPls,'debugOpts',debugOpts,'pCLustering',pCLustering);
%%loadTrainModel;
if exist(opts.dtsetOpts.pDenPath,'file')
    load(opts.dtsetOpts.pDenPath);opts.pDen=pDen;
end
if exist(opts.dtsetOpts.SvmModelPath,'file')
    load(opts.dtsetOpts.SvmModelPath);opts.model.svm=SVMModel;
end
if exist(opts.dtsetOpts.BetaPath,'file')
    load(opts.dtsetOpts.BetaPath);opts.model.BETA=BETA;
end
%%
end
