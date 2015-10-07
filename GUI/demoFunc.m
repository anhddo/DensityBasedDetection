function demoFunc(obj,evt,handles)
data=get(obj,'UserData');
[data.estimationParameter]=plotEstimateGraph(data.estimationParameter,handles);
frame=data.estimationParameter.frame(end)-1800;
data.detectionParameter=drawDetection(frame,data.detectionParameter,handles);

% time=data.detectionParameter.time(idx);
time=data.detectionParameter.time;
plotTime(time,handles);
set(obj,'UserData',data);
end
function plotTime(time,handles)
avgTime=mean(time);
if numel(time)>5
    time=time(end-4:end);
else
time=padarray(time,[0 5-numel(time)],0,'post');
end
axes4=handles.axes4;
bar(axes4,1:5,time,0.8,'FaceColor','b');
ylabel(axes4,'Time(s)');
text(0.25,0.25,sprintf('Average Time: %f (s)',avgTime),'Margin',3,...
    'BackgroundColor','w','Color','k','Parent',axes4);
end
function data=drawDetection(frame,data,handles)
axes3=handles.axes3;
[time,bbs,oriIm]=denDectectByFrame(frame,data);
data.time=[data.time time];
axes(axes3);
imshow(oriIm,'Parent',axes3);
for i=1:size(bbs,1)
    bb=bbs(i,1:4);
    rectangle('Position',bb,'Parent',axes3,'EdgeColor','g');
end

% hs=bbApply('draw',bbs,'g',1);
% set(hs,'Parent',axes3);
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
e=tic;
denIm=mallden(im,data.pDen);
denIm=denIm.*data.pMapN;
e=toc(e);
data.totalTime=data.totalTime+e;
data.estimation=[data.estimation sum(denIm(:))];

idx=data.frame;
% plotData1=data.estimation;
% plotData2=data.count(data.frame);
try
    idx=data.frame(end-data.range:end);
catch
end
plotData1=data.estimation(idx-1800);
plotData2=data.count(idx);
    
axes1=handles.axes1;
cla(axes1);
lw=2;
plot(axes1,plotData1,'b','LineWidth',lw);
hold(axes1,'on');
plot(axes1,plotData2,'r','LineWidth',lw);
xlabel(axes1,'frames');
ylabel(axes1,'count');
legend(axes1,'estimation','groundtruth','Location','southwest');

axes2=handles.axes2;
% denIm=mat2gray(denIm);
% imshow(denIm,'Parent',axes2);
imagesc(denIm,'Parent',axes2);
end
