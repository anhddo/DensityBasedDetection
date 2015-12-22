function [time,allBox,dispStuff]=denDetectNoPls(img,opts)
e=tic;
[pesClust,denIm,noiseReduce]=pedestrianCluster(img,opts);
dispStuff=v2struct(denIm,noiseReduce,pesClust);
imgPad=floor(size(img,1)/16);padImg=imPad(img,imgPad,'replicate');
clustPad=pesClust+imgPad;
% imshow(img);hold on; plot(pesClust(1,:),pesClust(2,:),'*');
hogIms=createHOGImage(padImg,opts);
scaleRange=opts.pDetect.scaleRange;
range=-1:1; cellSize=opts.pDetect.cellSize;
w=opts.pDetect.W/cellSize; h=opts.pDetect.H/cellSize;
allBox={};
for sInd=1:numel(scaleRange)
    boxScale={};
    for i=1:size(clustPad,2)%%
        cenScale=clustPad(:,i)*scaleRange(sInd);
        if ~isDenseSearch(cenScale,w,h,cellSize,hogIms{sInd},opts.model.svm,opts.pDetect.threshold),continue;end;
        [score,centerDense]=denseSearch(hogIms{sInd},cenScale,w,h,opts.model.svm,...
            opts.pDetect.cellSize,range);
        ind=score>opts.pDetect.fineThreshold;
        if sum(ind)==0,continue;end;
        score=score(ind);
        centerDense=centerDense(:,ind);
        box=createBox(centerDense,score,scaleRange(sInd),opts);
        box(1:2)=box(1:2)-imgPad;
%         boxScale{end+1}=box;
        allBox{end+1}=box;
%         imshow(padImg);hold on;bbApply('draw',box);
%         centerDense=centerDense/scaleRange(sInd);
%         imshow(padImg);hold on; plot(clustPad(1,i),clustPad(2,i),'*');
%         hold on;plot(centerDense(1,:),centerDense(2,:),'*');
%         hold on;bbApply('draw',box);
       
    end

%      boxScale=cat(1,boxScale{:});
%      boxScale=bbNms(boxScale);
%      allBox{end+1}=boxScale;
%      imshow(img); bbApply('draw',boxScale);
%      waitforbuttonpress;
end

allBox=cat(1,allBox{:});
allBox=bbNms(allBox,'thr',opts.pDetect.fineThreshold);
allBox=bbNms(allBox,'ovrDnm','min');
% allBox=bbNms(allBox,'thr',opts.pDetect.fineThreshold,'ovrDnm','min');
% allBox=bbNms(allBox);
time=toc(e);

% clustPath=fullfile('./vivo_dataset1/result/img/DenBasedNoPls/clust');
% if ~exist(clustPath),mkdir(clustPath);end;
% close all;figure('Visible','off');
% imshow(img); hold on;plot(pesClust(1,:),pesClust(2,:),'*');
% clustFile=fullfile(clustPath,sprintf('%d.jpg',opts.idx));
% print(clustFile,'-dpng');


% imshow(img);hold on;plot(pesClust(1,:),pesClust(2,:),'*')
% imshow(padImg);hold on;plot(clustPad(1,:),clustPad(2,:),'*')
% imshow(img); bbApply('draw',allBox); 
% waitforbuttonpress;
end
function v=isDenseSearch(center,w,h,cellSize,hogFeatures,model,threshold)
x=round(center(1)/cellSize);y=round(center(2)/cellSize);
x1=x-w/2;y1=y-h/2;
x2=x1+w-1; y2=y1+h-1;
if x1>0 && x2<=size(hogFeatures,2) && y1>0 && y2<=size(hogFeatures,1)
    features=hogFeatures(y1:y2,x1:x2,:);
    features=reshape(features,numel(features),[]);
    v=calcSVMScore(features,model,'linear')>threshold;
else
    v=false;
end
% if v==false,disp('count');end;
end
function box=createBox(center,score,scale,opts)
%     function v=getCenter(r,c)
%         if size(center,2)==1,
%             v=center(r);
%         else,v=center(r,c);end;
%     end
W=opts.pDetect.W;H=opts.pDetect.H;pad=opts.pDetect.pad;
box={};
for i=1:size(center,2)
    x=center(1,i)-W/2+pad; y=center(2,i)-H/2+pad;
    width=W-2*pad; height=H-2*pad;
    box{end+1}=[[x y width height]/scale score(i) scale];
end
box=cat(1,box{:});
box=bbNms(box);
end