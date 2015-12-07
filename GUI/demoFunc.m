function demoFunc(obj,evt,figureObject)
setLayout;
opts=get(obj,'UserData');
updateFrameIdOnGUI;
img=getDatasetImg;
[time,bbs,dispStuff]=denDectectByFrame(img,opts);
if isStepByStep
    drawOrinalImg(1);
    drawStepOption;
else
    drawOrinalImg(2);
    drawEstimationGraph;
    plotTime;
    drawDetectionBox;
    increaseFrameId;
end
set(obj,'UserData',opts);
%% nested function
    function drawEstimationGraph
        axesObj=getAxes(figureObject,1);
        opts.gui.timePerIm=[opts.gui.timePerIm time];
        denEst=opts.gui.denEst;
        denEst=[denEst sum(dispStuff.denIm(:))];
        cla(axesObj);
        lw=2;
        try plot1=denEst(end-opts.gui.plotEstRange+1:end);catch, plot1=denEst;end;
        plot(axesObj,plot1,'b','LineWidth',lw);
        hold(axesObj,'on');
        if isfield(opts.pDen,'count')
            count=opts.pDen.count;
            plot2=count(opts.gui.frameId-numel(plot1)+1:opts.gui.frameId)';
            plot(axesObj,plot2,'r','LineWidth',lw);
            xlabel(axesObj,'frames');
            ylabel(axesObj,'count');
            legend(axesObj,'estimation','groundtruth','Location','southwest');
        end
        opts.gui.denEst=denEst;
    end

    function img=getDatasetImg
        img=imread(fullfile(opts.dtsetOpts.framesDir,sprintf('seq_%06d.jpg',opts.gui.frameId)));
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
        imshow(img,'Parent',getAxes(figureObject,axesId));
    end
    function v=isStepByStep
        handles=guidata(figureObject);
        sbsBtn=findobj(handles.controlPanel,'Tag','stepByStepCb');
        v=get(sbsBtn,'Value');
    end

    function increaseFrameId
        opts.gui.frameId=opts.gui.frameId+opts.gui.framestep;
    end

    function updateFrameIdOnGUI
        setFigureHandle('attribute',figureObject,'frameId','String',opts.gui.frameId);
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

    function plotTime
        timePerIm=opts.gui.timePerIm;
        avgTime=mean(timePerIm);
        if numel(timePerIm)>5
            timePerIm=timePerIm(end-4:end);
        else
            timePerIm=padarray(timePerIm,[0 5-numel(timePerIm)],0,'post');
        end
        bar(getAxes(figureObject,4),1:5,timePerIm,0.8,'FaceColor','b');
        ylabel(getAxes(figureObject,4),'Time(s)');
        text(0.25,0.25,sprintf('Average Time: %f (s)',avgTime),'Margin',3,...
            'BackgroundColor','w','Color','k','Parent',getAxes(figureObject,4));
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
                drawPls(getAxes(figureObject,2),img,dispStuff.plsDrawingStuff);
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



function drawPls(cAxes,img,boxes)
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
    end

    function box=shiftBox(box,left,top)
        box(1:2)=box(1:2)-[left top];
    end

    function draw(cAxes,candidateBox,plsBox)
        [x1,y1]=getCenter(candidateBox);
        [x2,y2]=getCenter(plsBox);
        % set(axes,'NextPlot','add');
        cla(cAxes);
        imshow(subIm,'Parent',cAxes);
        rectangle('Position',candidateBox,'EdgeColor','r','Parent',cAxes);
        rectangle('Position',plsBox,'EdgeColor','b','Parent',cAxes);
        hold(cAxes,'on');
        plot(cAxes,[x1 x2],[y1 y2],'g');
    end

    function rescaleCandidateBoxAndPlsBox
        candidateBox=candidateBox*scale;
        plsBox=plsBox*scale;
    end
%%
candidateBox=boxes.canBox;
plsBox=boxes.plsBox;
[subIm,left,top,~,~]=extractAreaContainBothBox(10);
scale=size(img,1)/size(subIm,1);
subIm=imResample(subIm,scale);
candidateBox=shiftBox(candidateBox,left,top);
plsBox=shiftBox(plsBox,left,top);
rescaleCandidateBoxAndPlsBox;
draw(cAxes,candidateBox,plsBox);

end
function [dispDen,dispNoiseReduce,dispClust,dispPls]=getOptionValue(figureObject)
handles=guidata(figureObject);
dispDen=get(handles.denrbtn,'Value');
dispNoiseReduce=get(handles.noiserbtn,'Value');
dispClust=get(handles.clustrbtn,'Value');
dispPls=get(handles.plsrbtn,'Value');
end

