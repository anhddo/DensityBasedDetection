function [score,centerDense]=denseSearch(hogFeatures,center,w,h,model,cellSize,range)
features={};centerDense={};
x=round(center(1)/cellSize);y=round(center(2)/cellSize);
for i=range
    for j=range
        x1=x+i-w/2;y1=y+j-h/2;
        x2=x1+w-1; y2=y1+h-1;
        if x1>0 && x2<=size(hogFeatures,2) && y1>0 && y2<=size(hogFeatures,1)
            features{end+1}=hogFeatures(y1:y2,x1:x2,:);
            centerDense{end+1}=[(x+i-1)*cellSize+1 (y+j-1)*cellSize+1]';
        end
    end
end
features=cat(4,features{:});features=reshape(features,[],size(features,4));
centerDense=cat(2,centerDense{:});
score=calcSVMScore(features,model,'linear');
end