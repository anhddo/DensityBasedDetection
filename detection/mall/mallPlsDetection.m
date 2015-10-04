mallPlsTrain;
method='pls';
if reRundetect
    modelName='mallSVMModel';
    scaleRange=1./(1.04.^(-15:10));
%     scaleRange=1./(1.05.^(-9:7));
    if exist([modelName '.mat'],'file') load(modelName); else mallTrainHogModel(p); end;
        pPls=struct('cellSize',cellSize,'hogType',hogType,'threshold',-2,...
        'fineThreshold',0,'H',H,'W',W,'xstep',xstep,'ystep',ystep,'pad',padSize,...
        'scaleRange',scaleRange);
    n=numel(testFiles);
    bbs=cell(1,n);
    totalTime=0;
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
    avgtime=totalTime/n;
    fprintf('average time: %f\n',avgtime);
    save([method 'time'],'avgtime');
end
fprintf('average time: %f\n',totalTime/n);
% plotRoc([recall precision],'lims',[0 20 0 1],'lineWd',2,'color','r');