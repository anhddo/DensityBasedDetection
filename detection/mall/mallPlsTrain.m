function mallPlsTrain
p=mallDetectionParameter;
v2struct(p);
filePath=fullfile(matDir,'BETA.mat');
if exist(filePath,'file'),return;end;
warning('off');


reTrainPls=true; reRundetect=true; showBB=false;

load(fullfile(matDir,'pDen.mat'));p.pDen=pDen;
trainPlsImageDir=fullfile(datasetDir,'plsTrainImage');
testPlsImageDir=fullfile(datasetDir,'plsTestImage');
if ~exist(trainPlsImageDir,'dir')
    %     p.pGen=struct('padFullIm',500,'padCrop',48,'H',96,'isFlip',false,...
    %         'imageDir',trainPlsImageDir,'matFile',fullfile(matDir,'groundtruth.mat'));
    p.pGen.matfile=fullfile(matDir,'groundtruth.mat');
    p.pGen.imageDir=trainPlsImageDir;
    createGenImage(p);
end
if ~exist(testPlsImageDir,'dir')
    %     p.pGen=struct('padFullIm',500,'padCrop',48,'H',96,'isFlip',false,...
    %         'imageDir',testPlsImageDir,'matFile',fullfile(matDir,'groundtruth1801-2000.mat'));
    p.pGen.matfile=fullfile(matDir,'gt1801-2000.mat');
    p.pGen.imageDir=testPlsImageDir;
    createGenImage(p);
end
% choosenPlsTrain=fullfile(dataDir,'choosenPlsTrain');
choosenPlsTrain=fullfile(datasetDir,'plsTrainImage');
testPlsFiles=bbGt('getFiles',{testPlsImageDir});
% for i=400:numel(testPlsFiles)
%     delete(testPlsFiles{i});
% end
fprintf('pls training\n');
[BETA,rmsTrain,rmsTest]=plsTraining(choosenPlsTrain,testPlsImageDir,p);
fprintf('rms train [%f %f]\n',rmsTrain(1),rmsTrain(2));
fprintf('rms test [%f %f]\n',rmsTest(1),rmsTest(2));
save(filePath,'BETA');

