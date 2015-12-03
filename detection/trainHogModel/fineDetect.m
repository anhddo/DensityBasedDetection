function [boxes,scores,features,totalWin]=fineDetect(im,SVMModel,opts)
% v2struct(p);
features={};boxes={};scores={};
totalWin=0;
up=floor(opts.pDetect.cellSize/opts.pGenSVM.jumpstep)-1;
for i=0:up
    offset=i*opts.pGenSVM.jumpstep+1;
    [boxes1,scores1,features1,numWin]=detect(im(offset:end,offset:end,:),SVMModel,opts);
    if ~isempty(scores1)
        features{end+1}=features1;
        boxes1=boxes1+offset;
        boxes{end+1}=boxes1;
        scores{end+1}=scores1;
    end
    totalWin=totalWin+numWin;
end
features=cat(2,features{:});boxes=cat(2,boxes{:}); scores=cat(2,scores{:});
end

function [boxes,scores,features,totalWin]=detect(im,SVMModel,opts)
boxes={}; features={};scores={};
totalWin=0;
% imshow(im);
for scale=opts.pDetect.scaleRange
    [boxes1,scores1,features1,numWin]=scaleDetection(im,SVMModel,scale,opts);
    if ~isempty(boxes1)
        boxes{end+1}=boxes1; features{end+1}=features1;
        scores{end+1}=scores1;
    end
    totalWin=totalWin+numWin; 
end
boxes=cat(2,boxes{:}); features=cat(2,features{:}); scores=cat(2,scores{:});
end

function [boxes,scores,features,totalWin]=scaleDetection(im,model,scale,opts)
% v2struct(para);
im=imResample(im,scale);

hogFeature=computeHog(im,opts.pDetect.hogType);
features={};leftTop={};
H=opts.pDetect.H;W=opts.pDetect.W;cellSize=opts.pDetect.cellSize;
h=H/cellSize;w=W/cellSize;
[m,n,~]=size(hogFeature);
for i=1:n-w+1
    for j=1:m-h+1
        features{end+1}=hogFeature(j:j+h-1,i:i+w-1,:);
        leftTop{end+1}=[i,j]';
    end
end
features=cat(4,features{:});
features=reshape(features,[],size(features,4));

scores=calcSVMScore(features,model,'linear');
pad=opts.pDetect.pad;
leftTop=cat(2,leftTop{:});
leftTop=(leftTop-1)*cellSize+1; leftTop=leftTop+pad;
leftTop=leftTop/scale;

rightBot=[leftTop(1,:)+(W-2*pad)/scale-1;leftTop(2,:)+(H-2*pad)/scale-1];

boxes=[leftTop;rightBot];
totalWin=numel(scores);

% ind=find(scores>=opts.pDetect.threshold);
ind=find(scores>=model.t);
scores=scores(ind);features=features(:,ind);boxes=boxes(:,ind);
end