function applyDetect(opts)
createTxtGt(opts);
if ~exist(opts.resultOpts.resultFile,'file')
    gtTestFile=opts.dtsetOpts.gtTestFile;
    imgRange=unique(gtTestFile(gtTestFile(:,1)>0));
    totalImg=numel(imgRange);
    bbs=cell(1,totalImg);
    timeFrame=zeros(1,totalImg);
    for imgIdx=1:totalImg
        idx=imgRange(imgIdx);
        img=getDatasetImg(opts,idx);
        if strcmp(opts.resultOpts.methodName,'DenBased')
            [time,boxes,~]=denDectectByFrame(img,opts);
        elseif strcmp(opts.resultOpts.methodName,'PLS')
            [time,boxes]=plsDetect(img,opts);
        elseif strcmp(opts.resultOpts.methodName,'DenBasedNoPls')
            opts.idx=idx;
            [time,boxes]=denDetectNoPls(img,opts);
        end
        fprintf('image %d, time:%f\n',imgRange(imgIdx),time);
        timeFrame(imgIdx)=time;
        bbs{imgIdx}=[imgIdx*ones(size(boxes,1),1) boxes];
    end
    bbs=cat(1,bbs{:});
    bbs(:,2:5)=bbApply('resize',bbs(:,2:5),1,0,0.5);
    dlmwrite(opts.resultOpts.resultFile,bbs);
    avgtime=mean(timeFrame);
    fprintf('average time: %f\n',avgtime);
    save(opts.resultOpts.avgTimeFile,'avgtime');
end
% [gt,dt]=bbGt('loadAll',opts.resultOpts.gtTextFolder,opts.resultOpts.resultFile);
% [gt,dt] = bbGt('evalRes',gt,dt);
if opts.debugOpts.writeBb
    for imgIdx=1:numel(dt)
        bbs=dt{imgIdx};
        idx=loadImage(testFiles{imgIdx},imageType);
        clf;imshow(idx);
        matchInd=bbs(:,6)==1; matchBb=bbs(matchInd,:);
        unMatchInd=bbs(:,6)==0; unMatchBb=bbs(unMatchInd,:);
        bbApply('draw',matchBb,'g',1,'--');
        bbApply('draw',unMatchBb,'r',1,'--');
        print(fullfile('temp',['box' num2str(imgIdx) '.png']),'-dpng');
    end
    movefile(fullfile('temp','*.png'),fullfile('temp',method));
end
% [recall,precision,~,~] = bbGt('compRoc',gt,dt,0);
% plot(precision,recall);
% xlabel('precision'); ylabel('recall');
end
