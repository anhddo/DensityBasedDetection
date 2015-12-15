function calcBestMallDensity
datasetName='mall';
% for i=1:n, eval(sprintf('pDen%d=pDen;',i,i));end;
% trainSettings=struct('method',1,'spacing',2,'nTrees',5,'minLeaf',1000);
%spacing nTree minLeaf
trainSettings=getTrainSettings(datasetName);
% trainSettings(:,2)=4;
nTest=(size(trainSettings,1));methodIdx=(1:nTest)';MAE={};
dtsetOpts=initSettings(datasetName);

for i=1:nTest
    %     pDen(i)=initDensityParameter(datasetName,methodPara(i));
    setting=trainSettings(i,:);
    setting=struct('method',i,'spacing',setting(1),'nTrees',setting(2),'minLeaf',setting(3));
    opts=allParameter(datasetName,setting);
    storeDir=fullfile(opts.dtsetOpts.matDir,opts.datasetName);
    if ~exist(storeDir,'dir'),mkdir(storeDir);end;
    %     disp(opts.pDen.methodNo);
    opts.dtsetOpts.pDenPath=fullfile(storeDir,sprintf('pDen%d.mat',opts.pDen.methodNo));
    opts.dtsetOpts.forestPath=fullfile(storeDir,sprintf('Forest%d.mat',opts.pDen.methodNo));
    MAE{i}=test1(opts,storeDir);
end
MAE=cat(1,MAE{:});
No=(1:nTest)';
spacing=trainSettings(:,1);
nTrees=trainSettings(:,2);
minLeaf=trainSettings(:,3);
T=table(No,spacing,nTrees,minLeaf,MAE);
disp(T);
% disp([methodIdx err]);
[~,idx]=min(MAE);
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
        denIm=mallden(i,opts);
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
filePath=fullfile(storeDir,sprintf('f%d.png',opts.pDen.methodNo));
if ~exist(filePath,'file')
    close all;
    figure('Visible','off');
    plot(estimate,'b','LineWidth',2);
    hold on;
    plot(opts.pDen.count,'r','LineWidth',2);
    xlabel('Frame');ylabel('Number of pedestrians');
    print(filePath,'-dpng');
end
err=mean(abs((estimate-opts.pDen.count)));
end
function trainSettings=getTrainSettings(datasetName)
if strcmp(datasetName,'mall')
    trainSettings=[2 5 100;
        2 5 500;2 5 1000; 2 5 1500;
        4 5 100;4 10 100; 4 15 100;
        4 20 100; 4 5 200; 4 5 300;
        4 5 400;4 5 400; 4 5 500;
        4 5 1000; 4 5 1500;4 5 2000;4 5 2500;
        4 5 3000;4 5 5000;4 5 7000;4 5 10000;4 5 15000;4 5 20000;
        4 5 20000; 4 5 25000; 4 5 30000; 4 4 20000;
        ];
elseif strcmp(datasetName,'vivo1')
    trainSettings=[
        4 5 100;4 10 100; 4 15 100;
%         4 20 100; 4 5 200; 4 5 300;
%         4 5 400;4 5 400; 4 5 500;
4 4 1000; 4 4 1500;4 4 2000;4 4 2500;
        4 5 1000; 4 5 1500;4 5 2000;4 5 2500;
%          8 5 1000; 8 5 1500;8 5 2000;8 5 2500;
        4 5 3000;4 5 5000;4 5 7000;4 5 10000;4 5 15000;4 5 20000;
        4 5 20000; 4 5 25000; 4 5 30000;
%         8 4 1500;
        4 5 60000;
        4 5 120000;
        ];
    trainSettings(:,1)=8;
end
end