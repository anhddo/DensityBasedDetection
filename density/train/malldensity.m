function malldensity
% clear all;
close all;
try
    load('pDen.mat');
catch
    pDen=initDensityParameter;
    %generate feature channels and density images
    [pDen.ftrs,pDen.denGts,pDen.ims]=genFtrAndDen(pDen);
    if(exist('forest.mat','file'))
        loadFile=load('forest');Forest=loadFile.Forest;
    else
        %gen train data for random forest
        [X,Y]=genArrayForTreeBaggerLearning(pDen);
%         findMinLeaf(X,Y);
        disp('Train Forest');
        
        Forest=TreeBagger(pDen.nTrees,X,Y,'method','regression','NVarToSample','all','minLeaf',pDen.minLeaf);
        Forest=Forest.compact();
        Forest=Forest.Trees;
        save('forest','Forest');
    end
    
    pDen.Forest=Forest; clear Forest;
    [pDen.nLeaves,pDen.leafMap]=createLeafMap(pDen);
    [pDen.trainFeatures,pDen.trainWeights]=genForCount(pDen);
    
    disp('LearnToCount');
    verbose=true;
    maxIter=100;
    
    colormap('jet');
    wL1 = LearnToCount(pDen.nLeaves, pDen.trainFeatures, pDen.trainWeights,...
        pDen.weightMap, pDen.denGts, 0.1/pDen.nTrnIm, maxIter, verbose);
    pDen.w=wL1;
    
    clear pDen.trainFeatures pDen.trainWeights pDen.weightMap pDen.denGtPad;
    save(fullfile(pDen.matDir,'pDen.mat'),'pDen');
end
end
function [X,Y]=genArrayForTreeBaggerLearning(p)
X=[];Y=[];
for i=1:p.nTrnIm
    [m,n,d]=size(p.ftrs{i});
    ftrs=reshape(p.ftrs{i},[m*n d]);
    X=[X;ftrs];
    denArray=reshape(p.denGts{i},[m*n 1]);
    Y=[Y;denArray];
end
end

function [trainFeatures,trainWeights]=genForCount(p)
trainFeatures=cell(1,p.nTrnIm);
trainWeights=cell(1,p.nTrnIm);
for i=1:p.nTrnIm
    ftrs=p.ftrs{i};
    [~,~,d]=size(ftrs);
    trainFeatures{i}=convertFeature(ftrs,p);
    trainWeights{i}=repmat(p.roi,1,1,p.nTrees);
end
end

function findMinLeaf(X,Y)
rng('default')
leafs=100:50:1000;
N = numel(leafs);
err = zeros(N,1);
for n=1:N
    t = fitrtree(X,Y,'CrossVal','On',...
        'MinLeaf',leafs(n));
    err(n) = kfoldLoss(t);
end
plot(leafs,err);
xlabel('Min Leaf Size');
ylabel('cross-validated error');
end