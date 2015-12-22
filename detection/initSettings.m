function opts=initSettings(datasetName)
if strcmp(datasetName,'mall')
    opts=init(datasetName,'mall_dataset','groundtruth.mat','gt1801-2000.mat');
    opts.scaleRange='';
    opts.scaleRange=1.05.^(-7:15);
    load(fullfile(opts.datasetDir,'chooseImgTrain.mat'));
    opts.svmChoosedImg=chooseImgTrain;
    load(fullfile(opts.datasetDir,'plsPatchTrain.mat'));
    opts.plsChoosedImg=plsPatchTrain;
elseif strcmp(datasetName,'vivo1')
    opts=init(datasetName,'vivo_dataset1','vivoTrain_MAH00183.mat','vivoTest_MAH00183.mat');
    opts.scaleRange=1./(1.06.^(-5:17));
    load(fullfile(opts.datasetDir,'choosedImg.mat'));
    opts.svmChoosedImg=choosedImg;
    opts.plsChoosedImg=choosedImg;
    load(fullfile('vivo_dataset1','vivoTrain_MAH00183_retrain.mat'));
    opts.retrainGtFile=newOriData;
elseif strcmp(datasetName,'crescent')
    opts=init(datasetName,'crescent_dataset','crescentTrain.mat','crescentTest.mat');
    opts.scaleRange=1./(1.06.^(-5:17));
end
end
function opts=init(datasetName,datasetDirName,gtName,gtTestName)
mainDir=fullfile('.');
datasetDir=fullfile(mainDir,datasetDirName);
matDir=fullfile(mainDir,datasetDirName,'matfile');
if ~exist(matDir,'dir');mkdir(matDir);end;
gtFile=fullfile(datasetDirName,gtName);
if exist(gtFile,'file')==2,load(gtFile); gtFile=newOriData;end;
gtTestFile=fullfile(datasetDirName,gtTestName);
if exist(gtTestFile,'file')==2,load(gtTestFile); gtTestFile=newOriData;end;
pDenPath=fullfile(matDir,sprintf('%spDen.mat',datasetName));
forestPath=fullfile(matDir,sprintf('%sForest.mat',datasetName));
SvmModelPath=fullfile(matDir,sprintf('%sSVMModel.mat',datasetName));
BetaPath=fullfile(matDir,sprintf('%sBETA.mat',datasetName));
indexTestfile=unique(gtTestFile(gtTestFile(:,1)>0))';
opts=struct('datasetDir',datasetDir,'matDir',matDir,'gtFile',gtFile,...
    'gtTestFile',gtTestFile,'svmChoosedImg','','plsChoosedImg','',...
    'pDenPath',pDenPath,'SvmModelPath',SvmModelPath,'BetaPath',BetaPath,...
    'forestPath',forestPath,'indexTestFile',indexTestfile);
end