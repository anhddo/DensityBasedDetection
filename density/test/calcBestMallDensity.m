function calcBestMallDensity
datasetName='mall';
% for i=1:n, eval(sprintf('pDen%d=pDen;',i,i));end;
% trainSettings=struct('method',1,'spacing',2,'nTrees',5,'minLeaf',1000);
trainSettings=struct('method',1,'spacing',4,'nTrees',5,'minLeaf',1000);
trainSettings(2)=struct('method',2,'spacing',2,'nTrees',10,'minLeaf',1000);
trainSettings(3)=struct('method',3,'spacing',2,'nTrees',15,'minLeaf',1000);
trainSettings(4)=struct('method',4,'spacing',4,'nTrees',5,'minLeaf',1000);
trainSettings(5)=struct('method',5,'spacing',4,'nTrees',10,'minLeaf',1000);
trainSettings(6)=struct('method',6,'spacing',4,'nTrees',15,'minLeaf',1000);
trainSettings(7)=struct('method',7,'spacing',4,'nTrees',5,'minLeaf',100);
trainSettings(8)=struct('method',8,'spacing',4,'nTrees',5,'minLeaf',200);
trainSettings(9)=struct('method',9,'spacing',4,'nTrees',5,'minLeaf',400);
trainSettings(10)=struct('method',10,'spacing',4,'nTrees',5,'minLeaf',600);
trainSettings(11)=struct('method',11,'spacing',4,'nTrees',5,'minLeaf',1500);
trainSettings(12)=struct('method',12,'spacing',4,'nTrees',5,'minLeaf',1100);
trainSettings(13)=struct('method',13,'spacing',4,'nTrees',10,'minLeaf',1000);
trainSettings(14)=struct('method',14,'spacing',4,'nTrees',15,'minLeaf',2000);
trainSettings(15)=struct('method',15,'spacing',4,'nTrees',5,'minLeaf',3000);
trainSettings(16)=struct('method',16,'spacing',4,'nTrees',5,'minLeaf',4000);
trainSettings(17)=struct('method',17,'spacing',4,'nTrees',5,'minLeaf',6000);
trainSettings(18)=struct('method',18,'spacing',4,'nTrees',5,'minLeaf',7000);
trainSettings(19)=struct('method',19,'spacing',4,'nTrees',5,'minLeaf',10000);
trainSettings(20)=struct('method',20,'spacing',4,'nTrees',15,'minLeaf',4000);
nTest=numel(trainSettings);methodIdx=(1:nTest)';error={};
dtsetOpts=initSettings(datasetName);

for i=1:nTest
%     pDen(i)=initDensityParameter(datasetName,methodPara(i));
    opts=allParameter(datasetName,trainSettings(i));
    storeDir=fullfile(opts.dtsetOpts.matDir,opts.datasetName);
    if ~exist(storeDir,'dir'),mkdir(storeDir);end;
%     disp(opts.pDen.methodNo);
    opts.dtsetOpts.pDenPath=fullfile(storeDir,sprintf('pDen%d.mat',opts.pDen.methodNo));
    opts.dtsetOpts.forestPath=fullfile(storeDir,sprintf('Forest%d.mat',opts.pDen.methodNo));
    error{i}=test1(opts,storeDir);
end
error=cat(1,error{:});
No=[trainSettings.method]';
spacing=[trainSettings.spacing]';
nTrees=[trainSettings.nTrees]';
minLeaf=[trainSettings.minLeaf]';
T=table(No,spacing,nTrees,minLeaf,error);
disp(T);
% disp([methodIdx err]);
[~,idx]=min(error);
bestDenFile=fullfile(fullfile(storeDir,sprintf('pDen%d.mat',idx)));
denPath=fullfile(fullfile(opts.dtsetOpts.matDir,sprintf('%spDen.mat',opts.datasetName)));
copyfile(bestDenFile,denPath);
end
function err=test1(opts,storeDir)
try
    load(opts.dtsetOpts.pDenPath);
catch
    densityTraining(opts);
    load(opts.dtsetOpts.pDenPath);
end
opts.pDen=pDen;
% load(fullfile(opts.dtsetOpts.datasetDir,'perspective_roi.mat'));
% index=1801:2000;
% load(fullfile(opts.dtsetOpts.datasetDir,'mall_gt.mat'));
estPath=fullfile(storeDir,sprintf('estResult%d.mat',opts.pDen.methodNo));
try
    load(estPath);
catch
    estimate=[];
    for i=opts.dtsetOpts.indexTestFile
        im=getImForDensityPhase(i,opts);
        denIm=mallden(im,opts);
        estimate=[estimate sum(denIm(:))];
    end
    save(estPath,'estimate');
end
close all;
% plot(estimate,'r');
% count=count(1:10:2000);
% hold on;plot(count,'g');
% disp(estimate);
% disp(count');
plot(estimate,'b');
hold on;
plot(opts.pDen.count,'r');
filepath=fullfile(storeDir,sprintf('f%d.png',opts.pDen.methodNo));
print(filepath,'-dpng');
err=mean(abs(estimate-opts.pDen.count));
end