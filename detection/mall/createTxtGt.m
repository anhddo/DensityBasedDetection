if ~exist(gtDir,'dir')
    mkdir(gtDir);
    load('groundtruth1801-2000');
    ind=newOriData(:,1)>=0;
    boxes=newOriData(ind,[1 3:6]);
    boxes(:,2:5)=convertBB(boxes(:,2:5)','xywh',[]);
    for i=1801:2000
        ind=boxes(:,1)==i;
        box1=boxes(ind,:);
        bbs=bbGt('create',size(box1,1));
        bbs=bbGt('set',bbs,'bb',box1(:,2:5));
        lbls=cellfun(@(x)('person'),cell(1,numel(bbs)),'UniformOutput',0);
        bbs=bbGt('set',bbs,'lbl',lbls);
        bbGt('bbSave',bbs,fullfile(gtDir,sprintf('%d.txt',i)));
    end
end