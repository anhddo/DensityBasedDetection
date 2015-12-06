function demoFunc(obj,evt,figureObject)
setLayout;
opts=get(obj,'UserData');
[data.estimationParameter]=plotEstimateGraph(data.video,data.estimationParameter,handles);
setFigureHandle('attribute',figureObject,'frameId','String',opts.gui.frameId);
opts=drawDetection(opts,figureObject);
if ~isStepByStep(figureObject)
    plotTime(opts.gui.timePerIm,figureObject);
    opts.gui.frameId=opts.gui.frameId+opts.gui.framestep;
end;
set(obj,'UserData',opts);
%%

    function setLayout
        if isStepByStep(figureObject)
            setAxesPos('2x1',figureObject);
            enableGroupRbtnAndStopTimer
        else
            setAxesPos('2x2',figureObject);
        end;
    end
    function enableGroupRbtnAndStopTimer
        
%         handles.grouprbtn.Children=setGroupAttribute(handles.grouprbtn.Children,'Enable','on');
%         setHandleValue(figureObject,{'grouprbtn','Children'},
        timer=timerfind('Tag','Timer');
        stop(timer);
    end
%%
end

function v=isStepByStep(hObject)
handles=guidata(hObject);
sbsBtn=findobj(handles.controlPanel,'Tag','stepByStepCb');
v=get(sbsBtn,'Value');
end

function plotTime(time,figureObject)
avgTime=mean(time);
if numel(time)>5
    time=time(end-4:end);
else
    time=padarray(time,[0 5-numel(time)],0,'post');
end
bar(getAxes(figureObject,4),1:5,time,0.8,'FaceColor','b');
ylabel(getAxes(figureObject,4),'Time(s)');
text(0.25,0.25,sprintf('Average Time: %f (s)',avgTime),'Margin',3,...
    'BackgroundColor','w','Color','k','Parent',getAxes(figureObject,4));
end
function axes=getAxes(figureObject,i)
handles=guidata(figureObject);
axes=handles.axesObjs(i);
end
function opts=drawDetection(opts,figureObject)
img=getDatasetImg;
[time,bbs,dispStuff]=denDectectByFrame(img,opts);
if isStepByStep(figureObject)
    imshow(img,'Parent',getAxes(figureObject,1));
else
    % auto run
    opts=drawEst(getAxes(figureObject,1),dispStuff,opts,time);
    %draw detection box
    imshow(img,'Parent',getAxes(figureObject,3));
    for i=1:size(bbs,1)
        bb=bbs(i,1:4);
        rectangle('Position',bb,'Parent',getAxes(figureObject,3),'EdgeColor','b');
    end
end

[dispDen,dispNoiseReduce,dispClust,dispPls]=getOptionValue(figureObject);
if dispDen
    imshow(dispStuff.denIm,[],'Parent',getAxes(figureObject,2));
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
%%
    function img=getDatasetImg
        img=imread(fullfile(opts.dtsetOpts.framesDir,sprintf('seq_%06d.jpg',opts.gui.frameId)));
    end
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

function opts=drawEst(axes1,dispStuff,opts,time)
opts.gui.timePerIm=[opts.gui.timePerIm time];
denEst=[opts.gui.denEst sum(dispStuff.denIm(:))];

cla(axes1);
lw=2;
try plot1=denEst(end-opts.gui.plotEstRange+1:end);catch, plot1=denEst;end;
plot(axes1,plot1,'b','LineWidth',lw);
hold(axes1,'on');
if isfield(opts.pDen,'count')
    count=opts.pDen.count;
    plot2=count(opts.gui.frameId-numel(plot1)+1:opts.gui.frameId)';
    plot(axes1,plot2,'r','LineWidth',lw);
    xlabel(axes1,'frames');
    ylabel(axes1,'count');
    legend(axes1,'estimation','groundtruth','Location','southwest');
end
end

function groupHandles=setGroupAttribute(groupHandles,attribute,value)
for i=1:numel(groupHandles)
    set(groupHandles(i),attribute,value);
end
end