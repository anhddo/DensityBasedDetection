function createPadImage(trainposDir,boxes, imPath,opts)
%% create train pos
SH=opts.H+2*opts.padSize;SW=SH/2;
% load(fullfile(matDir,'chooseImgTrain.mat'));
nWritedImg=0;
for i=1:numel(imPath)
    im=im2single(imread(imPath{i}));
    im=imPad(im,opts.padFullIm,'replicate');
    
    box1=boxes{i};
    box1=box1+opts.padFullIm;
    
    for j=1:size(box1,2)
        xcenter=(box1(3,j)+box1(1,j))/2; ycenter=(box1(4,j)+box1(2,j))/2;
        h=box1(4,j)-box1(2,j);
        H1=h/opts.H*SH; W1=H1/2;
        ymin=round(ycenter-H1/2); ymax=round(ycenter+H1/2);
        xmin=round(xcenter-W1/2);xmax=round(xcenter+W1/2);
%         nPes=countPesdestrianInBox(box1,xmin,xmax,ymin,ymax);
%         if nPes>1, continue;end;
        subim=im(ymin:ymax,xmin:xmax,:);
        subim=imresize(subim,[SH SW]);
        imgName=sprintf('%d_%d.jpg',i,j);
%         if ~isChosen(imgName,chooseImgTrain),continue;end;
% check imgName match any filename in plsPatchTrain
        if isempty(opts.choosedImg)
            match=1;
        else
            func=@(x) strcmp(x,imgName);
            match=cellfun(func,opts.choosedImg);
        end;
        if sum(match)
            imwrite(subim,fullfile(trainposDir,imgName));
            nWritedImg=nWritedImg+1;
            if opts.isFlip,
                imwrite(fliplr(subim),fullfile(trainposDir,sprintf('%d_%d_flip.jpg',i,j)));
                nWritedImg=nWritedImg+1;
            end

        end
    end
    if isfield(opts,'maxWritedFile')&&nWritedImg>opts.maxWritedFile
        break;
    end
end
if isfield(opts,'isNoHead') && opts.isNoHead
   pad=round(opts.H*0.2+opts.padSize);
   allSubImPath=bbGt('getFiles',{trainposDir});
   n=numel(allSubImPath);
   p=randperm(n,round(n*0.2));
   allSubImPath=allSubImPath(p);
   for i=1:numel(allSubImPath)
       subIm=imread(allSubImPath{i});
       noHeadIm=subIm(pad:end,:,:);
       noHeadIm=[randi(255,pad,SW,3);noHeadIm];
%        noHeadIm=imPad(noHeadIm,[pad 0 0 0],'replicate');
       [~,name,ext]=fileparts(allSubImPath{i});
       noHeadImPath=fullfile(trainposDir,strcat('noHead',name,ext));
       imwrite(noHeadIm,noHeadImPath);
   end
end
end
%%
function r=isChosen(imgName,chooseImgTrain)
r=false;
for i=1:numel(chooseImgTrain)
    if strcmp(imgName,chooseImgTrain{i})
        r=true;
        return;
    end
end
end
%%
function n=countPesdestrianInBox(box1,xmin,xmax,ymin,ymax)
n=0;
for j=1:size(box1,2)
    x=(box1(3,j)+box1(1,j))/2; y=(box1(4,j)+box1(2,j))/2;
    if x>xmin && x<xmax && y>ymin&&y<ymax
        n=n+1;
    end
end
end