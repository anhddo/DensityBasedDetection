function opts=initDensityParameter(varargin)
%init default parameter
datasetName=varargin{1};
dtsetOpts=initSettings(datasetName);
if nargin>1,trainOpts=varargin{2};
else trainOpts=struct('spacing',4,'nTrees',5,'minLeaf',1000,'method',0);
end
if strcmp(dataset,'vivo')
    load(fullfile(datasetDir,'vivoTrainDensityGt.mat'));
    bggray=rgb2gray(imread(fullfile(datasetDir,'background.jpg')));
    pMapN=ones(size(bggray));
    roi=pMapN;
end
if strcmp(datasetName,'mall')
    load(fullfile(dtsetOpts.datasetDir,'mall_gt.mat'));
    load(fullfile(dtsetOpts.datasetDir,'perspective_roi.mat'));
    % load(fullfile(matDir,'data.mat'));
    % load(fullfile(matDir,'treeROI.mat'));
    % load(fullfile(matDir,'groundtruth.mat'));
    load(fullfile(dtsetOpts.datasetDir,'denTrainGT.mat'));
    roi=roi.mask;
elseif strcmp(datasetName,'vivo')
    load(fullfile(dtsetOpts.datasetDir,'vivoTrainDensityGt.mat'));
    pMapN=ones(size(bggray));
    roi=pMapN;
end
bggray=rgb2gray(imread(fullfile(dtsetOpts.datasetDir,'background.jpg')));
bggray=bggray(1:trainOpts.spacing:end,1:trainOpts.spacing:end);
pMapN=pMapN(1:trainOpts.spacing:end,1:trainOpts.spacing:end);
% pMapN=sqrt(pMapN);
% roi=~treeROI.*roi;

roi=roi(1:trainOpts.spacing:end,1:trainOpts.spacing:end);

% imIdx=1:5:51;
% imIdx=[46 51 76 86 111 121 126 146 271 301 459 488];
% imIdx=[1 6 86 101 111 121 126 131 151 156 161 176 186];

imIdx=unique(newOriData(:,1));
imIdx=imIdx(imIdx>0);
loc=cell(1,numel(imIdx));
for i=1:numel(imIdx)
    id=imIdx(i);
    bb=newOriData(newOriData(:,1)==id,:);
    bb=round(bb(:,3:6)/trainOpts.spacing);
    bb(bb==0)=bb(bb==0)+1;
    loc{i}=bb;
end
nTrnIm=numel(imIdx);
opts=struct('nTrnIm',nTrnIm,...
    'imRange',imIdx,'bggray',bggray,...
    'medSize',[3 3],'imIdx',imIdx,'loc',{loc},'weightMap',pMapN,...
    'roi',roi,'count',count,...
    'useBoxMask',0,'gaussSize',7,'sigma',2,'spacing',trainOpts.spacing,...
    'nTrees',trainOpts.nTrees,'minLeaf',trainOpts.minLeaf,...
    'methodNo',trainOpts.method);
end