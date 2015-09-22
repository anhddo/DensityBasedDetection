function [boxes,scores,features,totalWin]=fineDetect(im,SVMModel,p)
v2struct(p);
features={};boxes={};scores={};
totalWin=0;

for i=0:floor(cellSize/step)-1
    offset=i*step+1;
    [boxes1,scores1,features1,numWin]=detect(im(offset:end,offset:end,:),SVMModel,p);
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

function [boxes,scores,features,totalWin]=detect(im,SVMModel,p)
v2struct(p);
boxes={}; features={};scores={};
totalWin=0;
% imshow(im);
for scale=scaleRange
    sdpara.scale=scale;
    [boxes1,scores1,features1,numWin]=scaleDetection(im,SVMModel,scale,p);
    if ~isempty(boxes1)
        boxes{end+1}=boxes1; features{end+1}=features1;
        scores{end+1}=scores1;
    end
    totalWin=totalWin+numWin; 
end
boxes=cat(2,boxes{:}); features=cat(2,features{:}); scores=cat(2,scores{:});
end

function [boxes,scores,features,totalWin]=scaleDetection(im,model,scale,para)
v2struct(para);
im=imResample(im,scale);

hogFeature=computeHog(im,hogType);
features={};leftTop={};
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

leftTop=cat(2,leftTop{:});
leftTop=(leftTop-1)*cellSize+1; leftTop=leftTop+pad;
leftTop=leftTop/scale;

rightBot=[leftTop(1,:)+(W-2*pad)/scale-1;leftTop(2,:)+(H-2*pad)/scale-1];

boxes=[leftTop;rightBot];
totalWin=numel(scores);

ind=find(scores>=threshold);
scores=scores(ind);features=features(:,ind);boxes=boxes(:,ind);
end