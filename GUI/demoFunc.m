function demoFunc(obj,evt,figureObject)
% setLayout;
opts=get(obj,'UserData');
img=getDatasetImg(opts,getFrameId(opts));
isDenBased=strcmp(getMethod,'denBased');
isPLS=strcmp(getMethod,'pls');
if isDenBased
    [time,bbs,dispStuff]=denDectectByFrame(img,opts);
elseif isPLS
    [time,bbs]=plsDetect(img,opts);
end
opts.gui.timePerIm=[opts.gui.timePerIm time];
denBasedDraw;
plsDraw;
updateFrameIdOnGUI;
set(obj,'UserData',opts);
%% nested function
    function plsDraw
        if isPLS
            setAxesPos('2x1',figureObject);
            plotTime(2);
            drawDetectionBox;
            increaseFrameId;
        end
    end
    function denBasedDraw
        if isDenBased
            if isStepByStep
                setAxesPos('2x1',figureObject);
                enableGroupRbtnAndStopTimer
                drawOrinalImg(1);
                drawStepOption;
            else
                setAxesPos('2x2',figureObject);
                drawOrinalImg(2);
                drawEstimationGraph;
                plotTime(4);
                drawDetectionBox;
                increaseFrameId;
            end
        end
    end
    function method=getMethod
        handles=guidata(figureObject);
        if get(handles.densityBasedrbtn,'Value')
            method='denBased';
        else
            method='pls';
        end
    end
    function drawEstimationGraph
        axesObj=getAxes(figureObject,1);
        denEst=opts.gui.denEst;
        denEst=[denEst sum(dispStuff.denIm(:))];
        lw=2;
        try plot1=denEst(end-opts.gui.plotEstRange+1:end);catch, plot1=denEst;end;
        plot(axesObj,plot1,'b','LineWidth',lw);
        hold(axesObj,'on');
        if isfield(opts.pDen,'count')
            count=opts.pDen.count;
            plot2=count(opts.gui.iFrame-numel(plot1)+1:opts.gui.iFrame);
            plot(axesObj,plot2,'r','LineWidth',lw);
            xlabel(axesObj,'frames');
            ylabel(axesObj,'count');
            legend(axesObj,'estimation','groundtruth','Location','southwest');
        end
        opts.gui.denEst=denEst;
    end

    function drawDetectionBox
        % auto run
        %draw detection box
        imshow(img,'Parent',getAxes(figureObject,3));
        for i=1:size(bbs,1)
            bb=bbs(i,1:4);
            rectangle('Position',bb,'Parent',getAxes(figureObject,3),'EdgeColor','b');
        end
    end

    function drawOrinalImg(axesId)
        axesObj=getAxes(figureObject,axesId);
        legend(axesObj,'off');
        xlabel(axesObj,''); ylabel(axesObj,'');
        imshow(img,'Parent',getAxes(figureObject,axesId));
    end

    function v=isStepByStep
        handles=guidata(figureObject);
        sbsBtn=findobj(handles.controlPanel,'Tag','stepByStepCb');
        v=get(sbsBtn,'Value');
    end

    function increaseFrameId
        opts.gui.iFrame=opts.gui.iFrame+1;
    end

    function updateFrameIdOnGUI
        frameNumber=opts.dtsetOpts.indexTestFile(opts.gui.iFrame);
        setFigureHandle('attribute',figureObject,'frameId','String',frameNumber);
    end
    function setLayout
        if isStepByStep
            setAxesPos('2x1',figureObject);
            enableGroupRbtnAndStopTimer
        else
            setAxesPos('2x2',figureObject);
        end;
    end
    function enableGroupRbtnAndStopTimer
        handles=guidata(figureObject);
        handles.grouprbtn.Children=setGroupAttribute(handles.grouprbtn.Children,'Enable','on');
        timer=timerfind('Tag','Timer');
        stop(timer);
        guidata(figureObject,handles);
    end

    function plotTime(axesIdx)
        timePerIm=opts.gui.timePerIm;
        avgTime=mean(timePerIm);
        if numel(timePerIm)>5
            timePerIm=timePerIm(end-4:end);
        else
            timePerIm=padarray(timePerIm,[0 5-numel(timePerIm)],0,'post');
        end
        bar(getAxes(figureObject,axesIdx),1:5,timePerIm,0.8,'FaceColor','b');
        ylabel(getAxes(figureObject,axesIdx),'Time(s)');
        text(0.25,0.25,sprintf('Average Time: %f (s)',avgTime),'Margin',3,...
            'BackgroundColor','w','Color','k','Parent',getAxes(figureObject,axesIdx));
    end

    function drawStepOption
        [dispDen,dispNoiseReduce,dispClust,dispPls]=getOptionValue(figureObject);
        if dispDen
            scale=size(img,1)/size(dispStuff.denIm,1);
            denImdraw=imResample(dispStuff.denIm,scale,'nearest');
            imshow(denImdraw,[],'Parent',getAxes(figureObject,2));
        elseif dispNoiseReduce
            imshow(dispStuff.noiseReduce,[],'Parent',getAxes(figureObject,2));
        elseif dispClust
            centers=dispStuff.pesClust;
            imshow(img,'Parent',getAxes(figureObject,2));
            hold(getAxes(figureObject,2),'on');
            plot(centers(1,:),centers(2,:),'*','Parent',getAxes(figureObject,2));
        elseif dispPls
            try
                drawPls(figureObject,img,dispStuff.plsDrawingStuff);
            catch
            end
        end
    end

%%
end


function axes=getAxes(figureObject,i)
handles=guidata(figureObject);
axes=handles.axesObjs(i);
end



function drawPls(figureObject,img,boxes)
%%
    function [x,y]=getCenter(box)
        x=box(1)+box(3)/2;
        y=box(2)+box(4)/2;
    end
    function [subIm,left,top,right,bot]=extractAreaContainBothBox(pad)
        left=min(candidateBox(1),plsBox(1))-pad;
        right=max(candidateBox(1)+candidateBox(3), plsBox(1)+plsBox(3))+pad;
        top=min(candidateBox(2),plsBox(2))-pad;
        bot=max(candidateBox(2)+candidateBox(4), plsBox(2)+plsBox(4))+pad;
        top=round(top);bot=round(bot);left=round(left);right=round(right);
        subIm=img(top:bot,left:right,:);
        subRect=[left top, right-left,bot-top];
        rectangle('Position',subRect,'EdgeColor','g','Parent',getAxes(figureObject,1));
        %         rectangle('Position',plsBox,'EdgeColor','g','Parent',getAxes(figureObject,1));
    end

    function box=shiftBox(box,left,top)
        box(1:2)=box(1:2)-[left top];
    end

    function draw(candidateBox,plsBox)
        axesObj=getAxes(figureObject,2);
        candidateBox=double(candidateBox);
        plsBox=double(plsBox);
        imshow(subIm,'Parent',axesObj);
        rectangle('Position',candidateBox,'EdgeColor','r','Parent',axesObj);
        rectangle('Position',plsBox,'EdgeColor','b','Parent',axesObj);
        hold(axesObj,'on');
        text(candidateBox(1),candidateBox(2),'Box','Parent',axesObj,'Color','white');
        text(plsBox(1),plsBox(2),'PLS Box','Parent',axesObj,'Color','white');
        %         [x1,y1]=getCenter(candidateBox);
        %         [x2,y2]=getCenter(plsBox);
        %         plot(cAxes,[x1 x2],[y1 y2],'g');
    end

    function rescaleCandidateBoxAndPlsBox
        candidateBox=candidateBox*scale;
        plsBox=plsBox*scale;
    end
%%
candidateBox=boxes.canBox;
plsBox=boxes.plsBox;
[subIm,left,top,~,~]=extractAreaContainBothBox(20);
scale=size(img,1)/size(subIm,1);
subIm=imResample(subIm,scale);
candidateBox=shiftBox(candidateBox,left,top);
plsBox=shiftBox(plsBox,left,top);
rescaleCandidateBoxAndPlsBox;
draw(candidateBox,plsBox);

end
function [dispDen,dispNoiseReduce,dispClust,dispPls]=getOptionValue(figureObject)
handles=guidata(figureObject);
dispDen=get(handles.denrbtn,'Value');
dispNoiseReduce=get(handles.noiserbtn,'Value');
dispClust=get(handles.clustrbtn,'Value');
dispPls=get(handles.plsrbtn,'Value');
end

