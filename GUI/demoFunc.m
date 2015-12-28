function demoFunc(obj,evt,figureObj)
setLayout(figureObj);
opts=getTimerData(figureObj);
img=getDatasetImg(opts,getFrameId(opts));
if isShowResult(figureObj)
    optsList=createOptsList(opts.datasetName);
    prDraw(optsList,{'r','g','b'},getAxes(figureObj,1));
    timeDraw(optsList,getAxes(figureObj,2));
    stopTimer(figureObj);
else
    if isRealTime(figureObj)
        [time,bbs,dispStuff]=detectImage(figureObj);
    else
        [time,bbs,dispStuff]=reRun(figureObj);
    end
    dispStuff.bbs=bbs; dispStuff.img=img;
    updateTimePerIm(figureObj,time);
    demoDraw(figureObj,dispStuff);
    updateFrameIdOnGUI(figureObj);
end
end

function [time,bbs,dispStuff]=detectImage(figureObj)
if isDenBased(figureObj)
    [time,bbs,dispStuff]=denBasedPlsDetect(img,opts);
elseif isDenBasedNoPls(figureObj)
    [time,bbs,dispStuff]=denDetectNoPls(img,opts);
elseif isPls(figureObj)
    [time,bbs]=plsDetect(img,opts);
end
end

function [time,bbs,dispStuff]=getInfo(result,iFrame)
time=result.timeFrame{iFrame};
bbs=result.bbs{iFrame};
dispStuff=result.dispStuff{iFrame};
end
function result=getReRunResult(figureObj)
opts=getTimerData(figureObj);
if isDenBased(figureObj)
    result=opts.reRun.denPls;
elseif isDenBasedNoPls(figureObj)
    result=opts.reRun.denNoPls;
elseif isPls(figureObj)
    result=opts.reRun.pls;
end
end
function [time,bbs,dispStuff]=reRun(figureObj)
opts=getTimerData(figureObj);
iFrame=opts.gui.iFrame;
[time,bbs,dispStuff]=getInfo(getReRunResult(figureObj),iFrame);
end

function v=isRealTime(figureObj)
handles=guidata(figureObj);
v=get(handles.isRealTime,'Value');
end

function axes=getAxes(figureObj,i)
handles=guidata(figureObj);
axes=handles.axesObjs(i);
end

function drawPls(figureObj,dispStuff,axesObj)
%%
    function [subIm,left,top,right,bot]=extractAreaContainBothBox(pad)
        left=min(candidateBox(1),plsBox(1))-pad;
        right=max(candidateBox(1)+candidateBox(3), plsBox(1)+plsBox(3))+pad;
        top=min(candidateBox(2),plsBox(2))-pad;
        bot=max(candidateBox(2)+candidateBox(4), plsBox(2)+plsBox(4))+pad;
        top=round(top);bot=round(bot);left=round(left);right=round(right);
        subIm=dispStuff.img(top:bot,left:right,:);
        subRect=[left top, right-left,bot-top];
        rectangle('Position',subRect,'EdgeColor','g','Parent',getAxes(figureObj,2));
        %         rectangle('Position',plsBox,'EdgeColor','g','Parent',getAxes(figureObj,1));
    end

    function box=shiftBox(box,left,top)
        box(1:2)=box(1:2)-[left top];
    end

    function draw(candidateBox,plsBox)
        axesObj=getAxes(figureObj,1);
        candidateBox=double(candidateBox);
        plsBox=double(plsBox);
        setAxesLimWithImg(axesObj,subIm);
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
candidateBox=bbApply('resize',candidateBox,1,0,0.5);
plsBox=boxes.plsBox;
plsBox=bbApply('resize',plsBox,1,0,0.5);
[subIm,left,top,~,~]=extractAreaContainBothBox(20);
scale=size(dispStuff.img,1)/size(subIm,1);
subIm=imResample(subIm,scale);
candidateBox=shiftBox(candidateBox,left,top);
plsBox=shiftBox(plsBox,left,top);
rescaleCandidateBoxAndPlsBox;
draw(candidateBox,plsBox);

end
function [dispDen,dispNoiseReduce,dispClust,dispPls]=getOptionValue(figureObj)
handles=guidata(figureObj);
dispDen=get(handles.denrbtn,'Value');
dispNoiseReduce=get(handles.noiserbtn,'Value');
dispClust=get(handles.clustrbtn,'Value');
dispPls=get(handles.plsrbtn,'Value');
end
function v=isShowResult(figureObj)
handles=guidata(figureObj);
v=get(handles.isShowResult,'Value');
end
function setLayout(figureObj)
if isStepByStep(figureObj)||isShowResult(figureObj)
    setAxesPos('2x1',figureObj);
else
    setAxesPos('3',figureObj);
end;
end
function v=isAutorun(figureObj)
handles=guidata(figureObj);
v=get(handles.isAutorun,'Value');
end
function v=isStepByStep(figureObj)
handles=guidata(figureObj);
sbsBtn=findobj(handles.controlPanel,'Tag','stepByStepCb');
v=get(sbsBtn,'Value');
end
function updateFrameIdOnGUI(figureObj)
opts=getTimerData(figureObj);
if opts.gui.iFrame> numel(opts.dtsetOpts.indexTestFile)
    opts.gui.iFrame=1;
    opts.gui.timePerIm=[];
end
frameNumber=opts.dtsetOpts.indexTestFile(opts.gui.iFrame);
setFigureHandle('attribute',figureObj,'frameId','String',frameNumber);
updateTimerData(figureObj,opts);
end
function v=isDenBased(figureObj)
handles=guidata(figureObj);
v=get(handles.densityBasedrbtn,'Value');
end
function v=isDenBasedNoPls(figureObj)
handles=guidata(figureObj);
v=get(handles.densityBasedNonPLSrbtn,'Value');
end
function v=isPls(figureObj)
handles=guidata(figureObj);
v=get(handles.plsBasedrbtn,'Value');
end
function v=isUpdateTimeSequence(figureObj)
opts=getTimerData(figureObj);
v=numel(opts.gui.timePerIm)<opts.gui.iFrame;
end
function updateTimePerIm(figureObj,time)
opts=getTimerData(figureObj);
if isUpdateTimeSequence(figureObj),
    opts.gui.timePerIm=[opts.gui.timePerIm time];
    updateTimerData(figureObj,opts);
end
end
function drawEstimationGraph(figureObj)
opts=getTimerData(figureObj);
axesObj=getAxes(figureObj,1);
cla(axesObj);
lw=2;
result=getReRunResult(figureObj);
estCount=cat(2,result.estCount{:});
iFrame=opts.gui.iFrame;
plot1=estCount(1:iFrame);
if numel(plot1)>opts.gui.plotEstRange
    plot1=plot1(end-opts.gui.plotEstRange:end);
end
plot(axesObj,plot1,'b','LineWidth',lw);
hold(axesObj,'on');
if isfield(opts.pDen,'count')
    count=opts.pDen.count;
    plot2=count(iFrame-numel(plot1)+1:iFrame);
    plot(axesObj,plot2,'r','LineWidth',lw);
    xlabel(axesObj,'frames');
    ylabel(axesObj,'count');
    legend(axesObj,'estimation','groundtruth','Location','southwest');
end
end
function opts=getTimerData(figureObj)
handles=guidata(figureObj);
opts=get(handles.timer,'UserData');
end
function updateTimerData(figureObj,opts)
handles=guidata(figureObj);
set(handles.timer,'UserData',opts);
end
function increaseIFrame(figureObj)
opts=getTimerData(figureObj);
opts.gui.iFrame=opts.gui.iFrame+1;
updateTimerData(figureObj,opts);
end

function plotTime(figureObj,axesIdx)
opts=getTimerData(figureObj);
timePerIm=opts.gui.timePerIm;
avgTime=mean(timePerIm);
if numel(timePerIm)>5
    timePerIm=timePerIm(end-4:end);
else
    timePerIm=padarray(timePerIm,[0 5-numel(timePerIm)],0,'post');
end
axesObj=getAxes(figureObj,axesIdx);
bar(axesObj,1:5,timePerIm,0.8,'FaceColor','b');
ylabel(getAxes(figureObj,axesIdx),'Time(s)');
set(axesObj,'XTickLabel',{'t-4','t-3','t-2','t-1','t'});
text(0.25,0.25,sprintf('Average Time: %f (s)',avgTime),'Margin',3,...
    'BackgroundColor','w','Color','k','Parent',getAxes(figureObj,axesIdx));
end
function setAxesLimWithImg(axesObj,img)
set(axesObj,'Xlim',[0 size(img,2)]);
set(axesObj,'Ylim',[0 size(img,1)]);
end
function drawImgOnAxes(axesObj,img)
setAxesLimWithImg(axesObj,img);
imshow(img,'Parent',axesObj);
end
function drawBox(axesObj,bbs,egdeColor)
hold(axesObj,'on');
for i=1:size(bbs,1)
    bb=bbs(i,1:4);
    rectangle('Position',bb,'Parent',axesObj,'EdgeColor',egdeColor);
end
end
function v=isGtBox(figureObj)
handles=guidata(figureObj);
v=get(handles.isGtBox,'Value');
end
function v=isDetectBox(figureObj)
handles=guidata(figureObj);
v=get(handles.isDetectBox,'Value');
end
function bbs=getGtBox(obj)
opts=getTimerData(obj);
id=getFrameId(opts);
gt=opts.dtsetOpts.gtTestFile;
bbs=gt(gt(:,1)==id,3:6);
bbs=convertBB(bbs','xywh',[]);
end
function v=isDispDetect(figureObj)
handles=guidata(figureObj);
v=get(handles.detectionBoxrbtn,'Value');
end
function drawStepOption(figureObj,dispStuff)
[dispDen,dispNoiseReduce,dispClust,dispPls]=getOptionValue(figureObj);
axesObj=getAxes(figureObj,1);
% cla(axesObj,'reset');
if dispDen
    setAxesLimWithImg(axesObj,dispStuff.denIm);
    imshow(dispStuff.denIm,[],'Parent',axesObj);
elseif dispNoiseReduce
    setAxesLimWithImg(axesObj,dispStuff.noiseReduce);
    imshow(dispStuff.noiseReduce,[],'Parent',axesObj);
elseif dispClust
    centers=dispStuff.pesClust;
    setAxesLimWithImg(axesObj,dispStuff.img);
    imshow(dispStuff.img,'Parent',axesObj);
    hold(axesObj,'on');
    plot(centers(1,:),centers(2,:),'*','Parent',axesObj);
elseif dispPls
    try
        drawPls(figureObj,dispStuff,axesObj);
    catch
    end
elseif isDispDetect(figureObj)
    setAxesPos('1',figureObj);
    drawDetect(figureObj,1,dispStuff);
end
end

function drawDetect(figureObj,axesId,dispStuff)
axesObj=getAxes(figureObj,axesId);
drawImgOnAxes(axesObj,dispStuff.img);
if isDetectBox(figureObj),drawBox(axesObj,dispStuff.bbs,'b');end;
if isGtBox(figureObj),drawBox(axesObj,getGtBox(figureObj),'r');end;
end

function demoDraw(figureObj,dispStuff)
if isStepByStep(figureObj)
    drawImgOnAxes(getAxes(figureObj,2),dispStuff.img);
    drawStepOption(figureObj,dispStuff);
else
    drawEstimationGraph(figureObj);
    plotTime(figureObj,2);
    drawDetect(figureObj,3,dispStuff);
end
if isAutorun(figureObj)
    increaseIFrame(figureObj);
else
    stopTimer(figureObj);
end
end

function stopTimer(figureObj)
handles=guidata(figureObj);
    stop(handles.timer);
end

function timeDraw(optsList,axesObj)
load(optsList{1}.resultOpts.avgTimeFile);denTime=avgtime;
load(optsList{2}.resultOpts.avgTimeFile);plsTime=avgtime;
load(optsList{3}.resultOpts.avgTimeFile);noplsTime=avgtime;
set(axesObj,'XTick',0:3);
bar(axesObj,1,denTime,'r');
hold(axesObj,'on');
bar(axesObj,2,noplsTime,'g');
hold(axesObj,'on');
bar(axesObj,3,plsTime,'b');
hold(axesObj,'on');
set(axesObj,'XTickLabel',{'DenBased(with PLS)','Denbase(non-PLS)','PLS Based'});
hold(axesObj,'on');
ylabel(axesObj,'Time(s)');
end
function prDraw(optsList,drawOpts,axesObj)
cla(axesObj,'reset');
set(axesObj,'Xlim',[0 1]);
set(axesObj,'Ylim',[0 1]);
set(axesObj,'XTick',0:0.05:1);
set(axesObj,'YTick',0:0.05:1);
for i=1:numel(optsList)
    opts=optsList{i};
    [recall,precision]=PRplot(opts);
    hold(axesObj,'on');
    plot(axesObj,precision,recall,drawOpts{i},'LineWidth',2);
end
set(axesObj,'XGrid','on');
set(axesObj,'YGrid','on');

xlabel(axesObj,'precision'); ylabel(axesObj,'recall');
legend(axesObj,'DenBased(with PLS)','Denbase(non-PLS)','PLS Based','Location','southwest');
end
function [recall,precision]=PRplot(opts)
[gt,dt]=bbGt('loadAll',opts.resultOpts.gtTextFolder,opts.resultOpts.detectBox);
[gt,dt] = bbGt('evalRes',gt,dt,0.3);
[recall,precision,~,~] = bbGt('compRoc',gt,dt,0);
end