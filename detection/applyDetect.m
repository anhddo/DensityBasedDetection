function applyDetect(opts)
createTxtGt(opts);
if ~exist(opts.resultOpts.resultFile,'file')
    imgRange=opts.dtsetOpts.indexTestFile;
    totalImg=numel(imgRange);
    bbs=cell(1,totalImg);dispStuff=bbs;timeFrame=bbs;estCount=bbs;
    isDenBased=strcmp(opts.resultOpts.methodName,'DenBased');
    isPls=strcmp(opts.resultOpts.methodName,'PLS');
    isDenBasedNoPls=strcmp(opts.resultOpts.methodName,'DenBasedNoPls');
    disp(opts.resultOpts.methodName);
    for idx=1:totalImg
        imgIdx=imgRange(idx);
        img=getDatasetImg(opts,imgIdx);
        if isDenBased
            opts.pDetect.iFrame=idx;
            [time,boxes,dispStuff{idx}]=denBasedPlsDetect(img,opts);
        elseif isPls
            [time,boxes]=plsDetect(img,opts);
        elseif isDenBasedNoPls
            opts.pDetect.plsForGUI=false;
            [time,boxes,dispStuff{idx}]=denDetectNoPls(img,opts);
        end
        fprintf('image %d, time:%f\n',imgRange(idx),time);
        timeFrame{idx}=time;
        bbs{idx}=boxes;
        if isDenBased||isDenBasedNoPls
            estCount{idx}=sum(dispStuff{idx}.denIm(:));
        elseif isPls
            estCount{idx}=size(boxes,1);
        end
    end
    result.bbs=bbs;
    result.timeFrame=timeFrame;
    result.dispStuff=dispStuff;
    result.estCount=estCount;
    save(opts.resultOpts.resultFile,'result');
    for idx=1:totalImg
        bbs{idx}=[idx*ones(size(bbs{idx},1),1) bbs{idx}];
    end
    bbs=cat(1,bbs{:});
    bbs(:,2:5)=bbApply('resize',bbs(:,2:5),1,0,0.5);
    dlmwrite(opts.resultOpts.detectBox,bbs);
    timeFrame=cat(1,timeFrame{:});
    avgtime=mean(timeFrame);
    fprintf('average time: %f\n',avgtime);
    save(opts.resultOpts.avgTimeFile,'avgtime');
end
% [gt,dt]=bbGt('loadAll',opts.resultOpts.gtTextFolder,opts.resultOpts.detectBox);
% [gt,dt] = bbGt('evalRes',gt,dt);
if opts.debugOpts.writeBb
    for idx=1:numel(dt)
        bbs=dt{idx};
        idx=loadImage(testFiles{idx},imageType);
        clf;imshow(idx);
        matchInd=bbs(:,6)==1; matchBb=bbs(matchInd,:);
        unMatchInd=bbs(:,6)==0; unMatchBb=bbs(unMatchInd,:);
        bbApply('draw',matchBb,'g',1,'--');
        bbApply('draw',unMatchBb,'r',1,'--');
        print(fullfile('temp',['box' num2str(idx) '.png']),'-dpng');
    end
    movefile(fullfile('temp','*.png'),fullfile('temp',method));
end
% [recall,precision,~,~] = bbGt('compRoc',gt,dt,0);
% plot(precision,recall);
% xlabel('precision'); ylabel('recall');
end
