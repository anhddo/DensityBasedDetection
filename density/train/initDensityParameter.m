function opts=initDensityParameter(varargin)
%init default parameter
opts=varargin{1};
datasetName=opts.datasetName;
dtsetOpts=initSettings(datasetName);
if nargin>1,trainOpts=varargin{2};
else trainOpts=struct('spacing',4,'nTrees',5,'minLeaf',1000,'method',0);
end
bggray=rgb2gray(imread(fullfile(dtsetOpts.datasetDir,'background.jpg')));
if strcmp(datasetName,'mall')
    load(fullfile(dtsetOpts.datasetDir,'mall_gt.mat'));
    load(fullfile(dtsetOpts.datasetDir,'perspective_roi.mat'));
    % load(fullfile(matDir,'data.mat'));
    % load(fullfile(matDir,'treeROI.mat'));
    % load(fullfile(matDir,'groundtruth.mat'));
    load(fullfile(dtsetOpts.datasetDir,'denTrainGT.mat'));
    count=count(opts.dtsetOpts.indexTestFile);
    roi=roi.mask;
elseif strcmp(datasetName,'vivo1')
    load(fullfile(dtsetOpts.datasetDir,'vivoTest_MAH00183.mat'));
    range=unique(newOriData(newOriData(:,1)>0));
    count=zeros(1,numel(range));
    for i=1:numel(range)
        idx=newOriData(:,1)==range(i);
        count(i)=sum(idx);
    end
    
    load(fullfile(dtsetOpts.datasetDir,'vivoTrainDensityGt10.mat'));
%     ind=unique(newOriData(newOriData(:,1)>0));
    
	load(fullfile(dtsetOpts.datasetDir,'perspective.mat'));
    roi=ones(size(bggray));
end
bggray=bggray(1:trainOpts.spacing:end,1:trainOpts.spacing:end);
pMapN=pMapN(1:trainOpts.spacing:end,1:trainOpts.spacing:end);
pMapN=sqrt(pMapN);
% roi=~treeROI.*roi;

roi=roi(1:trainOpts.spacing:end,1:trainOpts.spacing:end);

imIdx=unique(newOriData(:,1));
imIdx=imIdx(imIdx>0);
loc=cell(1,numel(imIdx));
for i=1:numel(imIdx)
    id=imIdx(i);
    bb=newOriData(newOriData(:,1)==id,:);
    bb=floor(bb(:,3:6)/trainOpts.spacing);
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