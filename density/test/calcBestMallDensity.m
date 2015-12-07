function calcBestMallDensity
datasetName='mall';
% for i=1:n, eval(sprintf('pDen%d=pDen;',i,i));end;
trainSettings=struct('method',1,'spacing',2,'nTrees',5,'minLeaf',1000);
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

nTest=numel(trainSettings);methodIdx=(1:nTest)';err={};
dtsetOpts=initSettings(datasetName);
for i=1:nTest
%     pDen(i)=initDensityParameter(datasetName,methodPara(i));
    opts=allParameter(datasetName,trainSettings(i));
    err{i}=test1(opts);
end
err=cat(1,err{:});
disp([methodIdx err]);
end
function err=test1(opts)
opts.dtsetOpts.pDenPath=fullfile(opts.dtsetOpts.matDir,sprintf('%spDen%d.mat',opts.datasetName,opts.pDen.methodNo));
try
    load(opts.dtsetOpts.pDenPath);
catch
    opts.dtsetOpts.forestPath=fullfile(opts.dtsetOpts.matDir,sprintf('%sForest%d.mat',opts.datasetName,opts.pDen.methodNo));
    densityTraining(opts);
    load(opts.dtsetOpts.pDenPath);
end
opts.pDen=pDen;
load(fullfile(opts.dtsetOpts.datasetDir,'perspective_roi.mat'));
pMapN=pMapN(1:opts.pDen.spacing:end,1:opts.pDen.spacing:end);
% index=1:10:2000;
% index=1801:2000;
index=1801:1:2000;

load(fullfile(opts.dtsetOpts.datasetDir,'mall_gt.mat'));
estPath=fullfile(opts.dtsetOpts.matDir,sprintf('estResult%d.mat',opts.pDen.methodNo));
try
    load(estPath);
catch
    estimate=[];
    for i=index
        imPath=fullfile(opts.dtsetOpts.framesDir,sprintf('seq_%06d.jpg',i));
        %         disp(imPath);
        im=getIm(imPath,opts);
        %         tic;
%         disp([opts.dtsetOpts.pDenPath imPath]);
        denIm=mallden(im,opts);
%         denIm=denIm.*pMapN;
        %         fprintf('%f %f %f\n',sum(a(:)),sum(b(:)),count(i));
        %         toc;
        estimate=[estimate sum(denIm(:))];
    end
    save(estPath,'estimate');
end
close all;
% plot(estimate,'r');
% count=count(1:10:2000);
count=count(index);
% hold on;plot(count,'g');
% disp(estimate);
% disp(count');
err=mean(abs(estimate'-count));
end