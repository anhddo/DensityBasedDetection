function [resultPath,timeResultPath]=mallPlsDetection(method)
p=mallDetectionParameter;
v2struct(p);
resultPath=fullfile('result',[method '.txt']);
timeResultPath=fullfile(matDir,[method 'time.mat']);
if exist(resultPath,'file'),return;end;

mallPlsTrain;
load(fullfile(matDir,'BETA.mat'));

showBB=false;

modelName='mallSVMModel';
modelPath=fullfile(matDir,[modelName '.mat']);
try load(modelPath) ;catch, trainSVMModel(p); end;
scaleRange=1./(1.04.^(-15:10));
pPls=struct('cellSize',cellSize,'hogType',hogType,'threshold',-2,...
    'fineThreshold',0,'H',H,'W',W,'xstep',xstep,'ystep',ystep,'pad',padSize,...
    'scaleRange',scaleRange);
n=numel(testFiles);
bbs=cell(1,n);
totalTime=0;
mkdir(fullfile('temp','pls'));
for i=1:n
    %     for i=1
    im=loadImage(testFiles{i},imageType);
    im=im.*repmat(roi,1,1,3);
    e=tic;
    bb=plsSL(im,SVMModel,BETA,pPls);
    e=toc(e);
    fprintf('detect time:%f\n',e);
    totalTime=totalTime+e;
    bbs{i}=[i*ones(size(bb,1),1) bb];
    if showBB
        clf;
        imshow(im);
        bbApply('draw',bb,'g',1,'--');
        [~,nm,~]=fileparts(testFiles{i});
        print(fullfile('temp',method,[nm '.png']),'-dpng');
        %             hold on; vl_plotpoint(center);
        %             waitforbuttonpress;
    end
end
bbs=cat(1,bbs{:});
bbs(:,2:5)=bbApply('resize',bbs(:,2:5),1,0,0.5);
dlmwrite(resultPath,bbs);
avgtime=totalTime/n;
fprintf('average time: %f\n',avgtime);
save(timeResultPath,'avgtime');
fprintf('average time: %f\n',totalTime/n);
% plotRoc([recall precision],'lims',[0 20 0 1],'lineWd',2,'color','r');