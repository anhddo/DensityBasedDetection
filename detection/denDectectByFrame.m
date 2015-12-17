function [time,boxes,dispStuff]=denDectectByFrame(img,opts)
time=tic;
% img=getDatasetImg(opts,idx);
[pesClust,denIm,noiseReduce]=pedestrianCluster(img,opts);
writeClustImageToFile;
[boxes,plsDrawingStuff]=denDetect(img,pesClust,opts);
dispStuff=v2struct(denIm,noiseReduce,pesClust,plsDrawingStuff);
time=toc(time);
writeBoundingBoxToFile;

%%
    function writeClustImageToFile
        if opts.debugOpts.dClust
            clf;imshow(img); hold on; vl_plotpoint(pesClust,'.r','MarkerSize',20);
            print(fullfile('temp',['meanshift' num2str(i) '.png']),'-dpng');
        end
    end

    function writeBoundingBoxToFile
        if opts.debugOpts.dBB
            clf;imshow(img);
            hs=bbApply('draw',boxes,'g',1);
            print(fullfile('temp','density',['box' num2str(i) '.png']),'-dpng');
        end
    end

%%
end

function [boxes,plsDrawingStuff]=denDetect(img,pesClust,opts)
[w,h,range,bPad,padIm]=initParameter(opts.pDetect);
hogIms=createHOGImage(padIm,opts);
boxes={};
%use for plsDrawingStuff
for i=1:numel(opts.pDetect.scaleRange)
    allDistance=[]; allCanBox=[];allPlsBox=[];
    s=opts.pDetect.scaleRange(i);
    hogIm=hogIms{i};
    boxes1={}; boxes2={};
    pesClust1=pesClust*s;
    
    findPLSDisplacement;
    if isfield(opts,'gui') && ~isempty(allPlsBox)
        matchScale(i)=matchCenterScale;%find best pls box to draw on demoGUI
    end
    removeOoRBoxAndApplyNMS;
    writeCenPlsToFile;
    writeCenBoxToFile
end
boxes=cat(1,boxes{:});
boxes=bbNms(boxes);
boxes=bbNms(boxes,'ovrDnm','min');

range=-1:1;
boxes1={};
denseSearchForEachBox;

boxes1=cat(1,boxes1{:});
for i=1:size(boxes1,1)
    s=boxes1(i,6);
    boxes1(i,1:4)=boxes1(i,1:4)/s;
end
boxes1=removeOutOfRangeBox(boxes1,pad,m1,n1);

boxes1=bbNms(boxes1);
boxes1=bbNms(boxes1,'ovrDnm','min');
boxes=boxes1(:,1:5);

if isfield(opts,'gui')&& ~isempty(matchScale)
    [~,ind]=min([matchScale.distance]);
    plsDrawingStuff.canBox=matchScale(ind).canBox;
    plsDrawingStuff.plsBox=matchScale(ind).plsBox;
else
    plsDrawingStuff=[];
end
%%
    function IfBiggerThanFineThreshold(x,y,cenPes,threshold)
        W=opts.pDetect.W; H=opts.pDetect.H;
        if threshold>opts.pDetect.fineThreshold,
            %             boxes1 is plsbox,boxes2 is Candidatebox
            boxes1{end+1}=[x-W/2+bPad,y-H/2+bPad,W-2*bPad,H-2*bPad,threshold,i];
            boxes2{end+1}=[cenPes(1)-W/2+bPad,cenPes(2)-H/2+bPad,W-2*bPad,H-2*bPad,threshold,i];
            %             cenCandidate{end+1}=cenPes;
            %             cenPls{end+1}=[x;y];
            % removeOutOfRangeBox If Distance BiggerThan MaxDistance
            % use for draw pls box on demoGUI
            distance=sum(power([cenPes(1)-x cenPes(2)-y],2))/s;
            allDistance=[allDistance distance];
            [canBox,plsBox]=rmOoRBox;
            if ~isempty(canBox)
                allCanBox=[allCanBox; canBox];
                allPlsBox=[allPlsBox; plsBox];
            end
        end
    end

    function [canBox,plsBox]=rmOoRBox
        canBoxTemp=removeOutOfRangeBox(boxes2{end}/s,pad,m1,n1);
        plsBoxTemp=removeOutOfRangeBox(boxes1{end}/s,pad,m1,n1);
        canBox=[]; plsBox=[];
        if ~(isempty(canBoxTemp)||isempty(plsBoxTemp))
            canBox=canBoxTemp(1:4); plsBox=plsBoxTemp(1:4);
        end
    end

    function denseSearchForEachBox
        W=opts.pDetect.W; H=opts.pDetect.H;
        for i=1:size(boxes,1)
            bb=boxes(i,:);
            sInd=bb(6);
            s=opts.pDetect.scaleRange(sInd);
            x=bb(1)+bb(3)/2;y=bb(2)+bb(4)/2;
            cenPes=([x;y]+pad)*s;
            [score,centerDense]=denseSearch(hogIms{sInd},cenPes,w,h,opts.model.svm,...
                opts.pDetect.cellSize,range);
            boxes2={};
            for k=1:size(centerDense,2)
                x=centerDense(1,k); y=centerDense(2,k);
                boxes1{end+1}=[x-W/2+bPad,y-H/2+bPad,W-2*bPad,H-2*bPad,score(k),s];
            end
        end
    end

    function match=matchCenterScale
        frameId=opts.dtsetOpts.indexTestFile(opts.gui.iFrame);
        groundtruthTest=opts.dtsetOpts.gtTestFile;
        idx= groundtruthTest(:,1)==frameId;
        groundTruthFrame=groundtruthTest(idx,3:6);
        x=(groundTruthFrame(:,1)+groundTruthFrame(:,3))/2;
        y=(groundTruthFrame(:,2)+groundTruthFrame(:,4))/2;
        center=[x';y']';
        plsCenter=[allPlsBox(:,1)+allPlsBox(:,3)/2 allPlsBox(:,2)+allPlsBox(:,4)/2];
        dist=pdist2(center,plsCenter);
        [M,colIdx]=min(dist,[],2);
        [~,row]=min(M);
        col=colIdx(row);
        %         a=dist<dist(row,col);
        match.plsBox=allPlsBox(col,:);
        match.canBox=allCanBox(col,:);
        match.distance=dist(row,col);
        %         sum(a(:))
        
        %         dx=(center(1,1)-plsCenter(1,1));
        %         dy=(center(1,2)-plsCenter(1,2));
        %         a=dx*dx+dy*dy;
        
        %     distance=center-
    end

    function findPLSDisplacement
        for j=1:size(pesClust1,2)
            cenPes=pesClust1(:,j);
            [x,y]=newPlsPos(hogIm,opts,cenPes(1),cenPes(2),w,h,...
                opts.pDetect.cellSize,opts.pDetect.threshold);
            if isempty(x),continue;end;
            
            ftr=getFtrHog(hogIm,x,y,w,h,opts.pDetect.cellSize);
            if isempty(ftr),continue;end;
            IfBiggerThanFineThreshold(x,y,cenPes,calcSVMScore(ftr,opts.model.svm,'linear'));
        end
    end

    function removeOoRBoxAndApplyNMS
        if ~isempty(boxes1)
            boxes1=cat(1,boxes1{:});
            boxes1(:,1:4)=boxes1(:,1:4)/s;
            boxes1=removeOutOfRangeBox(boxes1,pad,m1,n1);
            boxes1=bbNms(boxes1,'thr',opts.pDetect.fineThreshold);
            
            boxes2=cat(1,boxes2{:});
            boxes2(:,1:4)=boxes2(:,1:4)/s;
            boxes2=removeOutOfRangeBox(boxes2,pad,m1,n1);
            boxes2=bbNms(boxes2,'thr',opts.pDetect.fineThreshold);
            
            if ~isempty(boxes1),boxes{end+1}=boxes1;end;
        end
    end

    function writeCenBoxToFile
        if opts.debugOpts.dCenBox && ~isempty(boxes1)
            clf;imshow(img);
            bbApply('draw',boxes1,'g',1,'--');
            print(fullfile('temp',['box' num2str(i) '_' num2str(s) '.png']),'-dpng');
        end
    end

    function writeCenPlsToFile
        if opts.debugOpts.dCenPls && ~isempty(boxes1)
            h=figure;imshow(img,'Parent',h);
            % box2 is candidatebox
            imWidth=size(img,2);imHeight=size(img,1);
            x1=(boxes1(1)+boxes1(3)/2)/imWidth; y1=(imHeight-(boxes1(2)+boxes1(4)/2))/imHeight;
            x2=(boxes2(1)+boxes2(3)/2)/imWidth; y2=(imHeight-(boxes2(2)+boxes2(4)/2))/imHeight;
            X=[x1 x2];Y=[y1 y2];
            %             arrow=annotation('arrow','Position',[x1 x2 x2-x1 y2-y1],'Units','pixels');
            arrow=annotation('arrow','X',[0.1 0.3],'Y',[0.1 0.3],'Units','pixels','Parent',h);
            %             set(arrow,'X',[x1 y1]); set(arrow,'Y',[x2 y2]);
            bbApply('draw',boxes2(:,1:4),'b',1);
            bbApply('draw',boxes1(:,1:4),'r',1);
            
            print(fullfile('temp',['cenPls' num2str(i) '_' num2str(s) '.png']),'-dpng');
        end
    end


    function [w,h,range,bPad,padImg]=initParameter(opts)
        w=opts.W/opts.cellSize;h=opts.H/opts.cellSize;
        [m1,n1,~]=size(img);
        pad=floor(m1/16);padImg=imPad(img,pad,'replicate');
        pesClust=pesClust+pad;
        range=-1:1;
        bPad=16;
    end




end
%%
function [x1,y1]=newPlsPos(hogIm,opts,x,y,w,h,cellSize,threshold)
x1=[];y1=[];
ftr=getFtrHog(hogIm,x,y,w,h,cellSize);
if isempty(ftr),return;end;
score=calcSVMScore(ftr,opts.model.svm,'linear');
if score<threshold,return;end;
offset=[1 ftr(:)']*opts.model.BETA;
x1=x+offset(1);y1=y+offset(2);
end
function testpedestrianCluster
[~,fnm,~]=fileparts(testFiles{i});
%     imwrite(loadImage(testFiles{i},'rgb'),fullfile('temp',[fnm '.png']));
imwrite(mat2gray(den),fullfile('temp',[fnm '_den.png']));
clf;
imshow(loadImage(testFiles{i},'rgb'));
hold on;
vl_plotpoint(clustCent*pDen.spacing);
print(fullfile('temp',[fnm 'clust.png']),'-dpng');
end
