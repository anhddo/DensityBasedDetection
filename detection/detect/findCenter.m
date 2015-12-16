function boxes=findCenter(im,opts)
[w,h]=calc_wh(opts);
f=reshape(opts.model.svm.w,h,w,[]);
centers={};boxes={};scores={};
for s=opts.pDetect.scaleRange
    im1= imResample(im, s) ;
    boxes1=findCenter1(im1,opts);
%     print(fullfile('temp',['center' num2str(i) '_' num2str(s) '.png']),'-dpng');
    if isempty(boxes1),continue;end;
    boxes1(:,1:4)=boxes1(:,1:4)/s;
    boxes{end+1}=boxes1;
end
boxes=cat(1,boxes{:});
end
function [w,h]=calc_wh(opts)
H=opts.pDetect.H;W=opts.pDetect.W;cellSize=opts.pDetect.cellSize;
h=H/cellSize;w=W/cellSize;
end
%%
function saveBB(name,im,boxes,center,score)
clf;
figure('Visible','off');
imshow(im);
hold on;
% disp(size(im));
if ~isempty(boxes),
    boxes=convertBB(boxes,'xywh',score);
    bbApply('draw',boxes,'b',1);
end;
if ~isempty(center), vl_plotpoint(center); end;
print(['temp/' name '.png'],'-dpng');
end
%%
function boxes=findCenter1(im,opts)
hogFeature=computeHog(im,opts.pDetect.hogType);
[m,n,~]=size(hogFeature);
center={}; boxes={};
scores={};
% centerCandidate={};
[w,h]=calc_wh(opts);
for x=1:opts.pDetect.xstep:size(im,2)
    for y=1:opts.pDetect.ystep:size(im,1)
        ftr=getFtrHog(hogFeature,x,y,w,h,opts.pDetect.cellSize);
        if isempty(ftr),continue;end;
        t=calcSVMScore(ftr,opts.model.svm,'linear');
        if t>opts.pDetect.threshold
%             centerCandidate{end+1}=[x;y];
            offset=[1 ftr']*opts.model.BETA;
            center{end+1}=offset'+[x;y];
        end
    end
end
% center=centerCandidate;
% clf; imshow(im);
% center1=cat(2,center{:});
% centerCandidate=cat(2,centerCandidate{:});
% hold on;vl_plotpoint(centerCandidate,'.b');
% hold on; vl_plotpoint(center1,'.r');


centersDense={};
range=-1:1;

for i=1:numel(center)
    [score1,center1]=denseSearch(hogFeature,center{i},w,h,opts.model.svm,...
        opts.pDetect.cellSize,range);
    scores{end+1}=score1;
    centersDense{end+1}=center1;
end
scores=cat(2,scores{:});
centersDense=cat(2,centersDense{:});

maxNumBox=size(centersDense,2);
boxes=zeros(maxNumBox,5);
W=opts.pDetect.W; H=opts.pDetect.H; pad=opts.pDetect.pad;
for i=1:maxNumBox
    x1=centersDense(1,i);y1=centersDense(2,i);
    boxes(i,:)=[x1-W/2+pad y1-H/2+pad W-2*pad H-2*pad scores(i)];
end
boxes=bbNms(boxes,'thr',opts.pDetect.fineThreshold);
end