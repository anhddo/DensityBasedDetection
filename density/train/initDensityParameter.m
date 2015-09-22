function pr=initDensityParameter
mallParameter;
testDir=datasetDir;
load(fullfile(datasetDir,'mall_gt.mat'));
load(fullfile(datasetDir,'perspective_roi.mat'));
% load(fullfile(matDir,'data.mat'));
% load(fullfile(matDir,'treeROI.mat'));
load(fullfile(matDir,'groundtruth.mat'));
spacing=4;

bggray=rgb2gray(imread(fullfile(mainDir,'background.jpg')));
bggray=bggray(1:spacing:end,1:spacing:end);

pMapN=pMapN(1:spacing:end,1:spacing:end);
pMapN=sqrt(pMapN);
roi=roi.mask;
% roi=~treeROI.*roi;

roi=roi(1:spacing:end,1:spacing:end);

% imIdx=1:5:51;
imIdx=[46 51 76 86 111 121 126 146 271 301 459 488];
loc=cell(1,numel(imIdx));
for i=1:numel(imIdx)
    id=imIdx(i);
    bb=newOriData(newOriData(:,1)==id,:);
    bb=round(bb(:,3:6)/spacing);
    bb(bb==0)=bb(bb==0)+1;
    loc{i}=bb;
end

nTrnIm=numel(imIdx);
pr=struct('datasetDir',datasetDir,'testDir',testDir,'nTrnIm',nTrnIm,...
    'imRange',imIdx,'bggray',bggray,...
    'medSize',[3 3],'imIdx',imIdx,'loc',{loc},'weightMap',pMapN,...
    'roi',roi,'matDir',matDir,...
    'useBoxMask',0,'gaussSize',7,'sigma',2,'spacing',spacing,'nTrees',10,'minLeaf',1000);
end