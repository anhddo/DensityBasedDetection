function compareResult
datasetName='vivo1';
initPath;
datasetTrain(datasetName)
opts1=createParameter(datasetName,'DenBased');
opts1.pDetect.fineThreshold=-0.5;
opts2=createParameter(datasetName,'PLS');
applyDetect(opts1);
applyDetect(opts2);
prDraw(opts1,opts2);
timeDraw(opts1,opts2);
end
function timeDraw(opts1,opts2)
load(opts1.resultOpts.avgTimeFile);
denTime=avgtime;
load(opts2.resultOpts.avgTimeFile);
plsTime=avgtime;
figure;
h(1)=bar(gca,[denTime plsTime],'r','BarWidth',0.5);
set(gca,'XTickLabel',{'Proposed method','PLS'});
hold on;
h(2)=bar(gca,2,plsTime,'b','BarWidth',0.5);
ylabel('Time(s)');
end
function prDraw(opts1,opts2)
figure;
[recall,precision]=PRplot(opts1);
plot(precision,recall,'r','LineWidth',2);
[recall,precision]=PRplot(opts2);
hold on; plot(precision,recall,'b','LineWidth',2);
xlabel('precision'); ylabel('recall');
legend('Proposed method','PLS','Location','southwest');
end
function opts=createParameter(datasetName,methodName)
opts=loadTrainModel(datasetName);
resultPath=fullfile(opts.dtsetOpts.datasetDir,'result');
if ~exist(resultPath,'dir'),mkdir(resultPath);end;
resultFile=fullfile(resultPath,strcat(datasetName,methodName,'.txt'));
avgTimeFile=fullfile(resultPath,strcat(datasetName,methodName,'time.mat'));
gtTextFolder=fullfile(resultPath,strcat(datasetName,'gtTxtFiles'));
resultOpts=struct('resultFile',resultFile,'avgTimeFile',avgTimeFile,...
    'gtTextFolder',gtTextFolder,'methodName',methodName,'resultPath',resultPath);
opts.resultOpts=resultOpts;
end
function [recall,precision]=PRplot(opts)
[gt,dt]=bbGt('loadAll',opts.resultOpts.gtTextFolder,opts.resultOpts.resultFile);
[gt,dt] = bbGt('evalRes',gt,dt);
[recall,precision,~,~] = bbGt('compRoc',gt,dt,0);
index=opts.dtsetOpts.indexTestFile;
imgFolderPath=fullfile(opts.resultOpts.resultPath,'img',opts.resultOpts.methodName);
if ~exist(imgFolderPath,'dir');mkdir(imgFolderPath);end;
for i=1:numel(index)
    imFile=fullfile(imgFolderPath,sprintf('im%d.png',index(i)));
    if exist(imFile,'file');continue;end;
    im=getDatasetImg(opts,index(i));
    close all;
    figure('Visible','off');imshow(im);hold on;
    bbApply('draw',gt{i},'r');hold on;
    detectBox=dt{i};
%     detectBox(:,5)=[];
    bbApply('draw',detectBox,'b');
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