warning('off');
loadParameter;
trainPlsImageDir='trainPlsImageDir/'; testPlsImageDir='testPlsImageDir/';
reGenPlsImage=false; reTrainPls=false;
reRundetect=false; showBB=false;

if reGenPlsImage,
    fprintf('generate Image\n');
    inriaCreatePlsImage;
end;
if reTrainPls,
    fprintf('pls training\n');
    [BETA,rmsTrain,rmsTest]=plsTraining(trainPlsImageDir,testPlsImageDir);
    fprintf('rms train [%f %f]\n',rmsTrain(1),rmsTrain(2));
    fprintf('rms test [%f %f]\n',rmsTest(1),rmsTest(2));
    save('BETA','BETA');
end
loadSvmModel; load('BETA');

if reRundetect
    modelName=['svm_' imageType '_' hogType '_' svmTool];
    if exist([modelName '.mat'],'file') load(modelName); else hogtraining; end;
        pPls=struct('cellSize',cellSize,'hogType',hogType,'threshold',-2,...
        'fineThreshold',-0.85,'H',H,'W',W,'xstep',xstep,'ystep',ystep,'pad',padSize);
%     parfor i=1:numel(testFiles)
    n=numel(testFiles);
    bbs=cell(1,n);
    tic;
    for i=1:n
        im=loadImage(testFiles{i},imageType);
        [bb,~]=plsSL(im,SVMModel,BETA,pPls);
        bbs{i}=[i*ones(size(bb,1),1) bb];
        if showBB
            imshow(im);
            bbApply('draw',bb);
            waitforbuttonpress;
        end
    end
    e=toc;
    fprintf('Detect time: %f\n',e);
    bbs=cat(1,bbs{:});
    dlmwrite('plsdt.txt',bbs);
end

[gt,dt]=bbGt('loadAll','testGt','plsdt.txt');
[gt,dt] = bbGt('evalRes',gt,dt);
[fp,tp,score,miss] = bbGt('compRoc',gt,dt,1);
plotRoc([fp tp],'lims',[0 5 0 1],'lineWd',2,'color','r');