function opts=initSettings(dataset)
if strcmp(dataset,'mall')
    opts=init('mall_dataset','groundtruth.mat','gt1801-2000.mat');
    opts.scaleRange='';
    opts.scaleRange=1.05.^(-5:10);
    load(fullfile(opts.datasetDir,'chooseImgTrain.mat'));
    opts.svmChoosedImg=chooseImgTrain;
    load(fullfile(opts.datasetDir,'plsPatchTrain.mat'));
    opts.plsChoosedImg=plsPatchTrain;
elseif strcmp(dataset,'vivo')
    opts=init('vivodataset','vivoTrainGt.mat','');
    opts.scaleRange=1./(1.06.^(0:15));
end
end
function opts=init(datasetDirName,gtName,gtTestName)
mainDir=fullfile('.');
datasetDir=fullfile(mainDir,datasetDirName);
matDir=fullfile(mainDir,'matfile');
gtFile=fullfile(datasetDir,gtName);
gtTestFile=fullfile(matDir,gtTestName);
opts=struct('datasetDir',datasetDir,'matDir',matDir,'gtFile',gtFile,...
    'gtTestFile',gtTestFile,'svmChoosedImg','','plsChoosedImg','');
end