function densityTraining(opts)
if ~exist(opts.dtsetOpts.pDenPath,'file')
    %generate feature channels and density images
    [opts.pDen.ftrs,opts.pDen.denGts]=genFtrAndDen(opts);
    if(exist(opts.dtsetOpts.forestPath,'file'))
        loadFile=load(opts.dtsetOpts.forestPath);Forest=loadFile.Forest;
    else
        %gen train data for random forest
        [X,Y]=genArrayForTreeBaggerLearning(opts);
%         findMinLeaf(X,Y);
        disp('Train Forest');
        Forest=TreeBagger(opts.pDen.nTrees,X,Y,'method','regression','NVarToSample','all','minLeaf',opts.pDen.minLeaf);
        Forest=Forest.compact();
        Forest=Forest.Trees;
%         save(opts.dtsetOpts.forestPath,'Forest');
    end
    
    opts.pDen.Forest=Forest; clear Forest;
    [opts.pDen.nLeaves,opts.pDen.leafMap]=createLeafMap(opts);
    [opts.pDen.trainFeatures,opts.pDen.trainWeights]=genForCount(opts);
    
    disp('LearnToCount');
    verbose=false;
    maxIter=100;
    
    colormap('jet');
    wL1 = LearnToCount(opts.pDen.nLeaves, opts.pDen.trainFeatures, opts.pDen.trainWeights,...
        opts.pDen.weightMap, opts.pDen.denGts, 0.1/opts.pDen.nTrnIm, maxIter, verbose);
    opts.pDen.w=wL1;
    
%     clear opts.pDen.trainFeatures opts.pDen.trainWeights opts.pDen.weightMap pDen.denGtPad;
    pDen=opts.pDen;
    save(opts.dtsetOpts.pDenPath,'pDen');
end
end
function [X,Y]=genArrayForTreeBaggerLearning(opts)
X=[];Y=[];
for i=1:opts.pDen.nTrnIm
    [m,n,d]=size(opts.pDen.ftrs{i});
    ftrs=reshape(opts.pDen.ftrs{i},[m*n d]);
    X=[X;ftrs];
    denArray=reshape(opts.pDen.denGts{i},[m*n 1]);
    Y=[Y;denArray];
end
end

function [trainFeatures,trainWeights]=genForCount(opts)
trainFeatures=cell(1,opts.pDen.nTrnIm);
trainWeights=cell(1,opts.pDen.nTrnIm);
for i=1:opts.pDen.nTrnIm
    ftrs=opts.pDen.ftrs{i};
    [~,~,d]=size(ftrs);
    trainFeatures{i}=convertFeature(ftrs,opts);
    trainWeights{i}=repmat(opts.pDen.roi,1,1,opts.pDen.nTrees);
end
end
