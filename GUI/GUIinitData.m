function opts=GUIinitData(datasetName,figureObject)
handles=guidata(figureObject);
opts=allParameter(datasetName);
% if strcmp(dataset,'mall')
%     p=mallDetectionParameter;
%     load(fullfile(p.datasetDir,'mall_gt.mat'));
%     load(fullfile(p.datasetDir,'perspective_roi.mat'));
%     estimationParameter.count=count;
% elseif strcmp(dataset,'vivo')
%     p=vivoDetectionParameter;
%     bggray=rgb2gray(imread(fullfile(p.datasetDir,'background.jpg')));
%     pMapN=ones(size(bggray));
% end
% estimationParameter.mallParameter=p;
if strcmp(datasetName,'mall')
    opts.video=VideoReader(fullfile(opts.dtsetOpts.datasetDir,'video.avi'));
    opts.frameid=1801;opts.plotEstRange=35; opts.framestep=1;
elseif strcmp(datasetName,'vivo')
    opts.video=VideoReader(fullfile(opts.dtsetOpts.datasetDir,'vivo.MP4'));
end
pDenPath=fullfile(opts.dtsetOpts.matDir,sprintf('%spDen.mat',datasetName));
load(pDenPath);
opts.pDen=pDen;
load(fullfile(opts.dtsetOpts.matDir,sprintf('%sSVMModel.mat',datasetName)));
load(fullfile(opts.dtsetOpts.matDir,sprintf('%sBETA.mat',datasetName)));
opts.model.svm=SVMModel;
opts.model.BETA=BETA;
% estimationParameter.pDen=pDen;
% estimationParameter.pMapN=pMapN(1:pDen.spacing:end,1:pDen.spacing:end);
% 
% estimationParameter.frame=[];
% estimationParameter.estimation=[];
% estimationParameter.range=50;
% estimationParameter.totalTime=0;

% detectionParameter=initDensityDetection(datasetName);

opts.timePerIm=[]; opts.denEst=[];
% [gtBb,~]=bbGt('loadAll',p.gtDir);
% data=v2struct(estimationParameter,detectionParameter,frameid,timePerIm,...
%     denEst,plotEstRange,gtBb);

% data=v2struct(estimationParameter,detectionParameter,frameid,timePerIm,...
%     denEst,plotEstRange,video,framestep);
end

