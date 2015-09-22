function boxes=findCenter(im,model,BETA,p)
show=false;
v2struct(p);
s=1;
p.h=H/cellSize;p.w=W/cellSize;
f=reshape(model.w,p.h,p.w,[]);
centers={};boxes={};scores={};
if show,
    close all;
    imshow(im);
end
for s=scaleRange
    im1= imResample(im, s) ;
    boxes1=findCenter1(im1,model,BETA,p);
%     print(fullfile('temp',['center' num2str(i) '_' num2str(s) '.png']),'-dpng');
    if isempty(boxes1),continue;end;
    boxes1(:,1:4)=boxes1(:,1:4)/s;
    boxes{end+1}=boxes1;
end
boxes=cat(1,boxes{:});
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
function boxes=findCenter1(im,model,BETA,p)
v2struct(p);

hogFeature=computeHog(im,hogType);
[m,n,~]=size(hogFeature);
center={}; boxes={};
scores={};
% centerCandidate={};
for x=1:xstep:size(im,2)
    for y=1:ystep:size(im,1)
        ftr=getFtrHog(hogFeature,x,y,w,h,cellSize);
        if isempty(ftr),continue;end;
        t=calcSVMScore(ftr,model,'linear');
        if t>threshold
%             centerCandidate{end+1}=[x;y];
            offset=[1 ftr']*BETA;
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


centersDense={}; range=-1:1;

for i=1:numel(center)
    [score1,center1]=denseSearch(hogFeature,center{i},w,h,model,cellSize,range);
    scores{end+1}=score1;
    centersDense{end+1}=center1;
end
scores=cat(2,scores{:});
centersDense=cat(2,centersDense{:});

maxNumBox=size(centersDense,2);
boxes=zeros(maxNumBox,5);
for i=1:maxNumBox
    x1=centersDense(1,i);y1=centersDense(2,i);
    boxes(i,:)=[x1-W/2+pad y1-H/2+pad W-2*pad H-2*pad scores(i)];
end
boxes=bbNms(boxes,'thr',fineThreshold);
end