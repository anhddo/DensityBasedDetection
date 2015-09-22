% clearvars;
warning('off');
p=mallDetectionParameter;
gtDir=fullfile('mall_dataset','gt1801-2000');
createTxtGt;

% modelName='svmstage0';
modelName='mallSVMModel';
if ~exist(sprintf('%s.mat',modelName),'file') mallTrainHogModel(p);end;
% [gt,dt]=bbGt('loadAll',gtDir,'mallsl2.txt');
% [gt1,dt1] = bbGt('evalRes',gt,dt);
gt=bbGt('loadAll',gtDir);
% gt=gt(1:10:end);
redetect=true;show=true;
if ~exist('mallsl.txt','file')||redetect
    v2struct(p);
    
    load(modelName);
    scaleRange=3./(1.2.^(0:8));
    pDetect=struct('cellSize',cellSize,'hogType',hogType,'threshold',0,...
        'step',8,'H',H,'W',W,'pad',16,'scaleRange',scaleRange);
%     testFiles=testFiles(1:10:end);

    n=numel(testFiles);
    bbs=cell(1,n);time=zeros(1,n);
    count=0;
    tic;

    for i=1:n

        disp(testFiles{i});
        im=loadImage(testFiles{i},imageType);
        tic;
        bb=detectSL(im,SVMModel,pDetect);
        toc;
        bbs{i}=[i*ones(size(bb,1),1) bb];
        if show

            fig=imshow(im);
            bbApply('draw',bb(:,1:4),'g',1,'-');
            nbb=size(gt{i},1);
            bbApply('draw',[gt{i}(:,1:4) (count+1:count+nbb)'],'r',1,'--');
            count=count+nbb;
            fnm=fullfile('detectImage',sprintf('%d.png',1800+i));
            saveas(fig,fnm);
            waitforbuttonpress;
        end
    end
    e=toc;
    fprintf('Detect time: %f\n',e);
    bbs=cat(1,bbs{:});
    dlmwrite('mallsl.txt',bbs);
end
[gt,dt]=bbGt('loadAll',gtDir,'mallsl.txt');
[gt,dt] = bbGt('evalRes',gt,dt,0.4);
v=[];
for i=1:numel(gt)
    gt1=gt{i};
    match=gt1(:,5);
    v=[v;i sum(match)/numel(match)];
end
disp(v);
[fp,tp,score,miss] = bbGt('compRoc',gt,dt,1);
figure;plotRoc([fp tp],'lims',[0 50 0 1],'lineWd',1,'xLbl','fppi');
