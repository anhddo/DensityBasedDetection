function createTxtGt(opts)
if ~exist(opts.resultOpts.gtTextFolder,'dir')
    mkdir(opts.resultOpts.gtTextFolder);
    groundTruth=opts.dtsetOpts.gtTestFile;
    ind=groundTruth(:,1)>=0;
    boxes=groundTruth(ind,[1 3:6]);
    boxes(:,2:5)=convertBB(boxes(:,2:5)','xywh',[]);
    for i=opts.dtsetOpts.indexTestFile
        ind=boxes(:,1)==i;
        box1=boxes(ind,:);
        box1(:,2:5)=bbApply('resize',box1(:,2:5),1,0,0.5);
        bbs=bbGt('create',size(box1,1));
        bbs=bbGt('set',bbs,'bb',box1(:,2:5));
%         bbs=bbApply('resize',bbs,1,0,0.5);
        lbls=cellfun(@(x)('person'),cell(1,numel(bbs)),'UniformOutput',0);
        bbs=bbGt('set',bbs,'lbl',lbls);
        bbGt('bbSave',bbs,fullfile(opts.resultOpts.gtTextFolder,sprintf('%d.txt',i)));
    end
end