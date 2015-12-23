function optsList=testDataset(varargin)
if nargin==0
    testDataset1('mall',false);
    testDataset1('vivo1',false);
    testDataset1('crescent',false);
    optsList=[];
else
    optsList=testDataset1(varargin{1},true);
end
end
%% nargin=2 only load optsList(no Train, no Detect)
function optsList=testDataset1(datasetName,isLoad)
args48=struct('plsPad',48);
% args32=struct('plsPad',32);
% datasetTrain(datasetName,args32);
if ~isLoad
    datasetTrain(datasetName,args48);
end

optsList{1}=createParameter(datasetName,'DenBased','pad48',args48);
optsList{1}.pDetect.fineThreshold=-0.2;
% optsList{1}.pDetect.threshold=-2;
% applyDetect(optsList{1});

optsList{2}=createParameter(datasetName,'PLS','pad48',args48);
optsList{2}.pDetect.fineThreshold=-0.2;
% applyDetect(optsList{2});

optsList{3}=createParameter(datasetName,'DenBasedNoPls','pad48',args48);
optsList{3}.pDetect.fineThreshold=-0.2;
if ~isLoad
    for i=1:numel(optsList)
        applyDetect(optsList{i});
    end
    drawStyle={'r','g','b'};
    prDraw(optsList,drawStyle);
    timeDraw(optsList);
end
end

function timeDraw(optsList)
filePath=fullfile(optsList{1}.resultOpts.resultPath,'time.png');
if exist(filePath,'file'),return;end;
load(optsList{1}.resultOpts.avgTimeFile);denTime=avgtime;
load(optsList{2}.resultOpts.avgTimeFile);plsTime=avgtime;
load(optsList{3}.resultOpts.avgTimeFile);noplsTime=avgtime;
figure('Visible','off');
bar([denTime plsTime noplsTime],'r','BarWidth',0.5);
set(gca,'XTickLabel',{'DenBased','PLS','DenBased(non-PLS)'});
hold on;
ylabel('Time(s)');
print(filePath,'-dpng');
end
function prDraw(optsList,drawOpts)
filePath=fullfile(optsList{1}.resultOpts.resultPath,'pr.png');
if exist(filePath,'file'),return;end;
figure('Visible','off');
for i=1:numel(optsList)
    opts=optsList{i};
    [recall,precision]=PRplot(opts);
    % plot(precision,recall,'r','LineWidth',2);
    %     nSample=50;
    %     if numel(recall)>nSample,
    %         step=numel(recall)/nSample;
    %         recall=recall(1:step:end);precision=precision(1:step:end);
    %     end
    % hold on;
    hold on;
    plot(precision,recall,drawOpts{i},'LineWidth',1);
end
xlabel('precision'); ylabel('recall');
legend('DenBased','PLS','Denbase NoPls','Location','southwest');
print(filePath,'-dpng');
end

function opts=createParameter(varargin)
datasetName=varargin{1};
methodName=varargin{2};
strName=varargin{3};
if nargin==4,opts=loadTrainModel(datasetName,varargin{4});
else,opts=loadTrainModel(datasetName);end;
resultPath=fullfile('result',datasetName);
if ~exist(resultPath,'dir'),mkdir(resultPath);end;
resultName=strcat(datasetName,methodName,strName);
sharePath=fullfile(resultPath,resultName);
resultFile=strcat(sharePath,'result.mat');
detectBox=strcat(sharePath,'.txt');
avgTimeFile=strcat(sharePath,'time.mat');
gtTextFolder=fullfile(resultPath,strcat(datasetName,'gtTxtFiles'));
resultOpts=struct('resultFile',resultFile,'detectBox',detectBox,'avgTimeFile',avgTimeFile,...
    'gtTextFolder',gtTextFolder,'methodName',methodName,'resultPath',resultPath,...
    'resultName',resultName);
opts.resultOpts=resultOpts;
end
function [recall,precision]=PRplot(opts)
[gt,dt]=bbGt('loadAll',opts.resultOpts.gtTextFolder,opts.resultOpts.detectBox);
[gt,dt] = bbGt('evalRes',gt,dt,0.3);
[recall,precision,~,~] = bbGt('compRoc',gt,dt,0);
index=opts.dtsetOpts.indexTestFile;
imgFolderPath=fullfile(opts.resultOpts.resultPath,'img',opts.resultOpts.methodName);
return;
if ~exist(imgFolderPath,'dir');mkdir(imgFolderPath);end;
for i=1:numel(index)
    imFile=fullfile(imgFolderPath,sprintf('im%d.png',index(i)));
    if exist(imFile,'file');continue;end;
    im=getDatasetImg(opts,index(i));
    close all;
    figure('Visible','off');
    imshow(im);
    %     bbGt( 'showRes', im, gt{i}, dt{i},'lw',1);
    bbApply('draw',gt{i},'r');hold on;
    bbApply('draw',dt{i}(:,1:4),'b');
    print(imFile,'-dpng');
end
end

function chooseim
a=bbGt('getFiles',{'D:\document\vision\DensityBasedDetection\vivo_dataset1\plsTrainImage'});
choosedImg={};
for i=1:numel(a)
    [~,name,ext]=fileparts(a{i});
    choosedImg{end+1}=[name ext];
end
end