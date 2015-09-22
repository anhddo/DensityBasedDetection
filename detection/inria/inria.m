close all;
loadParameter;
reRundetect=false;

if reRundetect
    modelName=['svm_' imageType '_' hogType '_' svmTool];
    if exist([modelName '.mat'],'file') load(modelName); else hogtraining; end;
    
    pDetect=struct('cellSize',cellSize,'hogType',hogType,'threshold',-0.85,...
        'step',8,'H',H,'W',W,'pad',16);
    n=numel(testFiles);
    bbs=cell(1,n);time=zeros(1,n);
    tic;
    parfor i=1:n
        im=loadImage(testFiles{i},imageType);
        bb=detectSL(im,SVMModel,pDetect);
        bbs{i}=[i*ones(size(bb,1),1) bb];
    end
    e=toc;
    fprintf('Detect time: %f\n',e);
    bbs=cat(1,bbs{:});
    dlmwrite('sl.txt',bbs);
end


if ~exist('testGt','dir'),
    V=vbb('vbbLoad','annotations/set01/V000');
    vbb('vbbToFiles',V,'testGt');
end;
[gt,dt]=bbGt('loadAll','testGt','sl.txt');
[gt,dt] = bbGt('evalRes',gt,dt);
[fp,tp,score,miss] = bbGt('compRoc',gt,dt,1);
figure;plotRoc([fp tp],'lims',[0 5 0 1],'lineWd',2,'xLbl','fppi');