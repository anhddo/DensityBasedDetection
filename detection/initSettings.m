function opts=initSettings(datasetName)
if strcmp(datasetName,'mall')
    opts=init(datasetName,'mall_dataset','groundtruth.mat','gt1801-2000.mat');
    opts.scaleRange='';
    opts.scaleRange=1.05.^(-5:10);
    load(fullfile(opts.datasetDir,'chooseImgTrain.mat'));
    opts.svmChoosedImg=chooseImgTrain;
    load(fullfile(opts.datasetDir,'plsPatchTrain.mat'));
    opts.plsChoosedImg=plsPatchTrain;
elseif strcmp(datasetName,'vivo')
    opts=init(datasetName,'vivodataset','vivoTrainGt.mat','');
    opts.scaleRange=1./(1.06.^(0:15));
end
end
function opts=init(datasetName,datasetDirName,gtName,gtTestName)
mainDir=fullfile('.');
datasetDir=fullfile(mainDir,datasetDirName);
matDir=fullfile(mainDir,'matfile');
gtFile=fullfile(datasetDir,gtName);
gtTestFile=fullfile(matDir,gtTestName);
pDenPath=fullfile(matDir,sprintf('%spDen.mat',datasetName));
forestPath=fullfile(matDir,sprintf('%sForest.mat',datasetName));
SvmModelPath=fullfile(matDir,sprintf('%sSVMModel.mat',datasetName));
BetaPath=fullfile(matDir,sprintf('%sBETA.mat',datasetName));
opts=struct('datasetDir',datasetDir,'matDir',matDir,'gtFile',gtFile,...
    'gtTestFile',gtTestFile,'svmChoosedImg','','plsChoosedImg','',...
    'pDenPath',pDenPath,'SvmModelPath',SvmModelPath,'BetaPath',BetaPath,...
    'forestPath',forestPath);
end