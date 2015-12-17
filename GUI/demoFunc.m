function demoFunc(obj,evt,figureObject)
setLayout(figureObject);
opts=getTimerData(figureObject);
img=getDatasetImg(opts,getFrameId(opts));
if isDenBased(figureObject)
    [time,bbs,dispStuff]=denDectectByFrame(img,opts);
elseif isDenBasedNoPls(figureObject)
    [time,bbs,dispStuff]=denDetectNoPls(img,opts);
elseif isPls(figureObject)
    [time,bbs]=plsDetect(img,opts);
end
dispStuff.bbs=bbs; dispStuff.img=img;
updateTimePerIm(figureObject,time);
if isDenBased(figureObject)||isDenBasedNoPls(figureObject)
    updateEstValue(figureObject,dispStuff);
end
demoDraw(figureObject,dispStuff);
updateFrameIdOnGUI(figureObject);
% plsDraw;
% set(obj,'UserData',opts);
%%
end


function axes=getAxes(figureObject,i)
handles=guidata(figureObject);
axes=handles.axesObjs(i);
end

function drawPls(figureObject,dispStuff,axesObj)
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
        subIm=dispStuff.img(top:bot,left:right,:);
        subRect=[left top, right-left,bot-top];
        rectangle('Position',subRect,'EdgeColor','g','Parent',getAxes(figureObject,2));
        %         rectangle('Position',plsBox,'EdgeColor','g','Parent',getAxes(figureObject,1));
    end

    function box=shiftBox(box,left,top)
        box(1:2)=box(1:2)-[left top];
    end

    function draw(candidateBox,plsBox)
        axesObj=getAxes(figureObject,1);
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
boxes=dispStuff.plsDrawingStuff;
candidateBox=boxes.canBox;
plsBox=boxes.plsBox;
[subIm,left,top,~,~]=extractAreaContainBothBox(20);
scale=size(dispStuff.img,1)/size(subIm,1);
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
function setLayout(figureObject)
if isStepByStep(figureObject)
    setAxesPos('2x1',figureObject);
%     enableGroupRbtnAndStopTimer
else
    if isDenBased(figureObject)||isDenBasedNoPls(figureObject)
        setAxesPos('3',figureObject);
    elseif isPls(figureObject)
        setAxesPos('pls',figureObject);
    end
end;
end
function v=isAutorun(figureObj)
handles=guidata(figureObj);
v=get(handles.isAutorun,'Value');
end
function v=isStepByStep(figureObject)
handles=guidata(figureObject);
sbsBtn=findobj(handles.controlPanel,'Tag','stepByStepCb');
v=get(sbsBtn,'Value');
end
function updateFrameIdOnGUI(figureObject)
opts=getTimerData(figureObject);
if opts.gui.iFrame> numel(opts.dtsetOpts.indexTestFile)
    opts.gui.iFrame=1;
    opts.gui.timePerIm=[];
end
frameNumber=opts.dtsetOpts.indexTestFile(opts.gui.iFrame);
setFigureHandle('attribute',figureObject,'frameId','String',frameNumber);
updateTimerData(figureObject,opts);
end
function v=isDenBased(figureObject)
handles=guidata(figureObject);
v=get(handles.densityBasedrbtn,'Value');
end
function v=isDenBasedNoPls(figureObject)
handles=guidata(figureObject);
v=get(handles.densityBasedNonPLSrbtn,'Value');
end
function v=isPls(figureObject)
handles=guidata(figureObject);
v=get(handles.isPLSBased,'Value');
end
function v=isUpdateTimeSequence(figureObject)
opts=getTimerData(figureObject);
v=numel(opts.gui.timePerIm)<opts.gui.iFrame;
end
function v=isUpdateEstimattion(figureObject)
opts=getTimerData(figureObject);
v=numel(opts.gui.denEst)<opts.gui.iFrame;
end
function updateEstValue(figureObject,dispStuff)
if isUpdateEstimattion(figureObject)
    opts=getTimerData(figureObject);
    opts.gui.denEst=[opts.gui.denEst sum(dispStuff.denIm(:))];
    updateTimerData(figureObject,opts);
end

end
function updateTimePerIm(figureObject,time)
opts=getTimerData(figureObject);
if isUpdateTimeSequence(figureObject),
    opts.gui.timePerIm=[opts.gui.timePerIm time];
    updateTimerData(figureObject,opts);
end
end
function drawEstimationGraph(figureObject)
opts=getTimerData(figureObject);
axesObj=getAxes(figureObject,1);
denEst=opts.gui.denEst;

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

end
function opts=getTimerData(figureObject)
handles=guidata(figureObject);
opts=get(handles.timer,'UserData');
end
function updateTimerData(figureObject,opts)
handles=guidata(figureObject);
set(handles.timer,'UserData',opts);
end
function increaseIFrame(figureObject)
opts=getTimerData(figureObject);
opts.gui.iFrame=opts.gui.iFrame+1;
updateTimerData(figureObject,opts);
end

function plotTime(figureObject,axesIdx)
opts=getTimerData(figureObject);
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
function drawOrinalImg(figureObject,axesId,img)
imshow(img,'Parent',getAxes(figureObject,axesId));
end
function drawBox(figureObject,axesIdx,bbs,egdeColor)
hold(getAxes(figureObject,axesIdx),'on');
for i=1:size(bbs,1)
    bb=bbs(i,1:4);
    rectangle('Position',bb,'Parent',getAxes(figureObject,axesIdx),'EdgeColor',egdeColor);
end
end
function v=isGtBox(figureObject)
handles=guidata(figureObject);
v=get(handles.isGtBox,'Value');
end
function v=isDetectBox(figureObject)
handles=guidata(figureObject);
v=get(handles.isDetectBox,'Value');
end
function bbs=getGtBox(obj)
opts=getTimerData(obj);
id=getFrameId(opts);
gt=opts.dtsetOpts.gtTestFile;
bbs=gt(gt(:,1)==id,3:6);
bbs=convertBB(bbs','xywh',[]);
end
function v=isDispDetect(figureObject)
handles=guidata(figureObject);
v=get(handles.detectionBoxrbtn,'Value');
end
function drawStepOption(figureObject,dispStuff)
[dispDen,dispNoiseReduce,dispClust,dispPls]=getOptionValue(figureObject);
axesObj=getAxes(figureObject,1);
if dispDen
    scale=size(dispStuff.img,1)/size(dispStuff.denIm,1);
    denImdraw=imResample(dispStuff.denIm,scale,'nearest');
    imshow(denImdraw,[],'Parent',axesObj);
elseif dispNoiseReduce
    imshow(dispStuff.noiseReduce,[],'Parent',axesObj);
elseif dispClust
    centers=dispStuff.pesClust;
    imshow(dispStuff.img,'Parent',axesObj);
    hold(axesObj,'on');
    plot(centers(1,:),centers(2,:),'*','Parent',axesObj);
elseif dispPls
    try
        drawPls(figureObject,dispStuff,axesObj);
    catch    
    end
elseif isDispDetect(figureObject)
    setAxesPos('1',figureObject);
    drawOrinalImg(figureObject,1,dispStuff.img);
    if isDetectBox(figureObject),drawBox(figureObject,1,dispStuff.bbs,'b');end;
    if isGtBox(figureObject),drawBox(figureObject,1,getGtBox(figureObj),'r');end;
end
end
function drawDetect(figureObj,axesId,dispStuff)
drawOrinalImg(figureObj,axesId,dispStuff.img);
if isDetectBox(figureObj),drawBox(figureObj,axesId,dispStuff.bbs,'b');end;
if isGtBox(figureObj),drawBox(figureObj,axesId,getGtBox(figureObj),'r');end;
end
function demoDraw(figureObj,dispStuff)
if isStepByStep(figureObj)
    drawOrinalImg(figureObj,2,dispStuff.img);
     drawStepOption(figureObj,dispStuff);
else
    if isDenBased(figureObj)||isDenBasedNoPls(figureObj)
        drawEstimationGraph(figureObj);
        plotTime(figureObj,2);
        drawDetect(figureObj,3,dispStuff);
    elseif isPls(figureObj)
        plotTime(figureObj,1);
        drawDetect(figureObj,2,dispStuff)
    end
end
if isAutorun(figureObj)
    increaseIFrame(figureObj);
else
    handles=guidata(figureObj);
    stop(handles.timer);
end
% if isDenBased
%
%         setAxesPos('2x1',figureObject);
%         enableGroupRbtnAndStopTimer
%
%         drawStepOption;
%     else
%         setAxesPos('2x2',figureObject);
%         drawOrinalImg(2);
%
%
%
% end
end
