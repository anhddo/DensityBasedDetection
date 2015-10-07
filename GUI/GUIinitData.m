function data=GUIinitData
p=mallDetectionParameter;
estimationPara.mallParameter=p;
load(fullfile(p.datasetDir,'mall_gt.mat'));
estimationPara.count=count;
load(fullfile(p.matDir,'pDen.mat'));
estimationPara.pDen=pDen;
load(fullfile(p.datasetDir,'perspective_roi.mat'));
estimationPara.pMapN=pMapN(1:pDen.spacing:end,1:pDen.spacing:end);

estimationPara.frame=[];
estimationPara.estimation=[];
estimationPara.range=50;

data.estimationParameter=estimationPara;
data.detectionParameter=initDensityDetection;


