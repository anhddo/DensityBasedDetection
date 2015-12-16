function reTrainHardNegative(datasetName)
opts=loadTrainModel(datasetName);
if isfield(opts.pGenSVM,'hardNegDetect') &&opts.pGenSVM.hardNegDetect
    opts=createResultObj(datasetName,'PLS');
    gtTestFile=opts.dtsetOpts.retrainGtFile;
    index=unique(gtTestFile(gtTestFile(:,1)>0))';
    opts.dtsetOpts.gtTestFile=gtTestFile;
    opts.dtsetOpts.indexTestFile=index;
    %     opts.dtsetOpts.gtTestFile=opts.dtsetOpts.gtTestFile(1:
    applyDetect(opts);
    [gt,dt]=bbGt('loadAll',opts.resultOpts.gtTextFolder,opts.resultOpts.resultFile);
    [gt,dt] = bbGt('evalRes',gt,dt,0.3);
    imgFolderPath=fullfile(opts.resultOpts.resultPath,'img');
    if ~exist(imgFolderPath,'dir'),mkdir(imgFolderPath);end;
    for i=1:numel(index)
        imFile=fullfile(imgFolderPath,sprintf('im%d.png',index(i)));
        if exist(imFile,'file');continue;end;
        im=getDatasetImg(opts,index(i));
        %     close all; figure('Visible','off');
        imshow(im);
        %     bbGt( 'showRes', im, gt{i}, dt{i},'lw',1);
        bbApply('draw',gt{i},'r');hold on;
        bbApply('draw',dt{i}(:,1:4),'b');
%         waitforbuttonpress;
        %         print(imFile,'-dpng');
    end
end
end

function opts=createResultObj(datasetName,methodName)
opts=loadTrainModel(datasetName);
resultPath=fullfile(opts.dtsetOpts.datasetDir,'retrain');
if ~exist(resultPath,'dir'),mkdir(resultPath);end;
resultFile=fullfile(resultPath,strcat(datasetName,methodName,'.txt'));
avgTimeFile=fullfile(resultPath,strcat(datasetName,methodName,'time.mat'));
gtTextFolder=fullfile(resultPath,strcat(datasetName,'gtTxtFiles'));
resultOpts=struct('resultFile',resultFile,'avgTimeFile',avgTimeFile,...
    'gtTextFolder',gtTextFolder,'methodName',methodName,'resultPath',resultPath);
opts.resultOpts=resultOpts;
end