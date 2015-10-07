function demoFunc(obj,evt,handles)
data=get(obj,'UserData');
data.estimationParameter=plotEstimateGraph(data.estimationParameter,handles);
frame=data.estimationParameter.frame(end)-1800;
drawDetection(frame,data.detectionParameter,handles);
set(obj,'UserData',data);
end
function drawDetection(frame,data,handles)
axes3=handles.axes3;
[totalTime,bbs,oriIm]=denDectectByFrame(frame,data);
axes(axes3);
imshow(oriIm,'Parent',axes3);
hs=bbApply('draw',bbs,'g',1);
set(hs,'Parent',axes3);
end
%%
function data=plotEstimateGraph(data,handles)
if isempty(data.frame)
    data.frame=1801;
else
    data.frame=[data.frame data.frame(end)+1];
end

imPath=fullfile(data.mallParameter.framesDir,sprintf('seq_%06d.jpg',data.frame(end)));
im=getIm(imPath,data.pDen);
denIm=mallden(im,data.pDen);
denIm=denIm.*data.pMapN;
data.estimation=[data.estimation sum(denIm(:))];

plotData1=data.estimation;
plotData2=data.count(data.frame);
try
    idx=data.frame(end-data.range:end);
    plotData1=data.estimation(idx);
    plotData2=data.count(idx);
catch
end

axes1=handles.axes1;
cla(axes1);
plot(axes1,plotData1,'b');
hold(axes1,'on');
plot(axes1,plotData2,'r');
xlabel(axes1,'frames');
ylabel(axes1,'count');
legend(axes1,'estimation','groundtruth','Location','southwest');

axes2=handles.axes2;
imagesc(denIm,'Parent',axes2);
end
