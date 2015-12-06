function plsTrain(opts)
if exist(opts.dtsetOpts.BetaPath,'file'),return;end;
% if exist(opts.dtsetOpts.BetaPath,'file'),return;end;
% warning('off');
% 
% 
% reTrainPls=true; reRundetect=true; showBB=false;

% load(fullfile(matDir,'pDen.mat'));p.pDen=pDen;
% p.pGen=struct('padFullIm',500,'padCrop',48,'H',96,'isFlip',false,...
%     'imageDir',trainPlsImageDir,'matFile',fullfile(matDir,'groundtruth.mat'));
trainPlsImageDir=opts.pTrainPls.trainPlsImageDir;
if ~exist(trainPlsImageDir,'dir')
%     p.pGen.matfile=fullfile(matDir,'groundtruth.mat');
    opts.pGenPls.imageDir=trainPlsImageDir;
    createGenImage(trainPlsImageDir,opts.pGenPls);
end
testPlsImageDir=opts.pTrainPls.testPlsImageDir;
if ~exist(testPlsImageDir,'dir')
    opts.pGenPls.imageDir=testPlsImageDir;
    createGenImage(testPlsImageDir,opts.pGenPls);
end
% choosenPlsTrain=fullfile(dataDir,'choosenPlsTrain');
choosenPlsTrain=fullfile(opts.dtsetOpts.datasetDir,'plsTrainImage');
testPlsFiles=bbGt('getFiles',{testPlsImageDir});
% for i=400:numel(testPlsFiles)
%     delete(testPlsFiles{i});
% end
fprintf('pls training\n');
[BETA,rmsTrain,rmsTest]=plsTraining(choosenPlsTrain,testPlsImageDir,opts);
fprintf('rms train [%f %f]\n',rmsTrain(1),rmsTrain(2));
fprintf('rms test [%f %f]\n',rmsTest(1),rmsTest(2));
save(opts.dtsetOpts.BetaPath,'BETA');
end

function [BETA,rms1,rms2]=plsTraining(trainFolder,testFolder,p)
[Xpls,Ypls]=plsGetPartHog(trainFolder,p);
[XL,YL,XS,YS,BETA,PCTVAR,MSE]=plsregress(Xpls,Ypls,60);

%% test on training Data
rms1=testPLSModel(Xpls,Ypls,BETA);
clear Xpls Ypls;
%% test on Test Data
[Xtest,Ytest]=plsGetPartHog(testFolder,p);
rms2=testPLSModel(Xtest,Ytest,BETA);
end
%%
function rms=testPLSModel(Xpls,Ypls,BETA)
fit=[ones(size(Xpls,1),1) Xpls]*BETA;
res=fit-Ypls;
rms=res.^2;
rms=sqrt(mean(rms,1));
end