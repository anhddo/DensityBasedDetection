function opts=initFilePath(dataset)
if strcmp(dataset,'mall')
    opts=init('mall_dataset','groundtruth.mat','gt1801-2000.mat');
elseif strcmp(dataset,'vivo')
    opts=init('vivodataset','','');
end
end
function init(datasetDirName,gtName,gtTestName)
mainDir=fullfile('.');
datasetDir=fullfile(mainDir,datasetDirName);
matDir=fullfile(mainDir,'matfile');
gtDir=fullfile(datasetDir,gtName);
gtTestFile=fullfile(matDir,gtTestName);
end