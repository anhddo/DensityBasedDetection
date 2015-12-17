function compareResult
clear all; close all;
initPath;
compareResult1('mall');
compareResult1('vivo1');
compareResult1('crescent');
end
function compareResult1(datasetName)
% calcBestDensityModel(datasetName,false);
args48=struct('plsPad',48);
args32=struct('plsPad',32);
datasetTrain(datasetName,args32);
datasetTrain(datasetName,args48);

optsList{1}=createParameter(datasetName,'DenBased','pad48',args48);
optsList{1}.pDetect.fineThreshold=-0.2;
% optsList{1}.pDetect.threshold=-2;
% applyDetect(optsList{1});

optsList{2}=createParameter(datasetName,'PLS','pad48',args48);
optsList{2}.pDetect.fineThreshold=-0.2;
% applyDetect(optsList{2});

optsList{3}=createParameter(datasetName,'DenBasedNoPls','pad48',args48);
optsList{3}.pDetect.fineThreshold=-0.2;
% optsList{3}.pDetect.threshold=-1;
% applyDetect(optsList{3});

% optsList{4}=createParameter(datasetName,'DenBased','pad32',args32);
% optsList{4}.pDetect.fineThreshold=-0.2;
% optsList{4}.pDetect.threshold=-1;
% applyDetect(optsList{4});
% 
% optsList{5}=createParameter(datasetName,'PLS','pad32',args32);
% optsList{5}.pDetect.fineThreshold=-0.2;
% applyDetect(optsList{5});
% 
% optsList{6}=createParameter(datasetName,'DenBasedNoPls','pad32',args32);
% optsList{6}.pDetect.fineThreshold=-0.2;
% optsList{6}.pDetect.threshold=-1;

for i=1:numel(optsList)
    applyDetect(optsList{i});
end
drawStyle={'r','g','b'};
prDraw(optsList,drawStyle);
end

function timeDraw(opts)
load(opts.resultOpts.avgTimeFile);
figure;
h(1)=bar(gca,[denTime plsTime],'r','BarWidth',0.5);
set(gca,'XTickLabel',{'Proposed method','PLS'});
hold on;
h(2)=bar(gca,2,plsTime,'b','BarWidth',0.5);
ylabel('Time(s)');
print(fullfile(opts.resultOpts.resultPath,'time.png'),'-dpng');
end
function prDraw(optsList,drawOpts)
figure;
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
legend('Proposed method','PLS','NoPls','Location','southwest');
print(fullfile(optsList{1}.resultOpts.resultPath,'pr.png'),'-dpng');
end

function opts=createParameter(varargin)
datasetName=varargin{1};
methodName=varargin{2};
strName=varargin{3};
if nargin==4,opts=loadTrainModel(datasetName,varargin{4});
else,opts=loadTrainModel(datasetName);end;
resultPath=fullfile(opts.dtsetOpts.datasetDir,'result');
if ~exist(resultPath,'dir'),mkdir(resultPath);end;
resultName=strcat(datasetName,methodName,strName);
sharePath=fullfile(resultPath,resultName);
resultFile=strcat(sharePath,'.txt');
avgTimeFile=strcat(sharePath,'time.mat');
gtTextFolder=fullfile(resultPath,strcat(datasetName,'gtTxtFiles'));
resultOpts=struct('resultFile',resultFile,'avgTimeFile',avgTimeFile,...
    'gtTextFolder',gtTextFolder,'methodName',methodName,'resultPath',resultPath,...
    'resultName',resultName);
opts.resultOpts=resultOpts;
end
function [recall,precision]=PRplot(opts)
[gt,dt]=bbGt('loadAll',opts.resultOpts.gtTextFolder,opts.resultOpts.resultFile);
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