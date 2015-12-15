function [time,allBox]=denDetectNoPls(img,opts)
e=tic;
[pesClust,~,~]=pedestrianCluster(img,opts);
imgPad=floor(size(img,1)/16);padImg=imPad(img,imgPad,'replicate');
clustPad=pesClust+imgPad;
% imshow(img);hold on; plot(pesClust(1,:),pesClust(2,:),'*');
hogIms=createHOGImage(padImg,opts);
scaleRange=opts.pDetect.scaleRange;
range=-1:1; cellSize=opts.pDetect.cellSize;
w=opts.pDetect.W/cellSize; h=opts.pDetect.H/cellSize;
allBox={};
for sInd=1:numel(scaleRange)
    for i=1:size(clustPad,2)%%
        cenScale=clustPad(:,i)*scaleRange(sInd);
        [score,centerDense]=denseSearch(hogIms{sInd},cenScale,w,h,opts.model.svm,...
            opts.pDetect.cellSize,range);
        ind=score>opts.pDetect.fineThreshold;
        if sum(ind)==0,continue;end;
        score=score(ind);
        centerDense=centerDense(:,ind);
        box=createBox(centerDense,score,scaleRange(sInd),opts);
%         box(1:2)=box(1:2)-imgPad;
        allBox{end+1}=box;
%         imshow(padImg);hold on;bbApply('draw',box);
%         centerDense=centerDense/scaleRange(sInd);
%         imshow(padImg);hold on; plot(clustPad(1,i),clustPad(2,i),'*');
%         hold on;plot(centerDense(1,:),centerDense(2,:),'*');
%         hold on;bbApply('draw',box);
%         waitforbuttonpress;
    end
end
allBox=cat(1,allBox{:});
allBox=bbNms(allBox,'ovrDnm','min');
% allBox=bbNms(allBox);
time=toc(e);
% imshow(img);hold on;plot(pesClust(1,:),pesClust(2,:),'*')
imshow(padImg);hold on;plot(clustPad(1,:),clustPad(2,:),'*')
bbApply('draw',allBox); 
waitforbuttonpress;
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