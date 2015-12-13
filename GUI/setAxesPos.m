function setAxesPos(type,hObject)
nAxes=4;
pos=zeros(nAxes,4);
handles=guidata(hObject);
if ~isfield(handles,'axesObjs')
    for i=1:nAxes
        handles.axesObjs(i)=axes('Parent',handles.drawPanel);
    end
end

pos(1,:)=[0 0.7 0.5 0.2];
pos(4,:)=pos(1,:)+[pos(1,3) 0 0 0];
pos(2,:)=[pos(1,1) 0 pos(1,3) 0.5];
pos(3,:)=[pos(4,1) pos(2,2) pos(2,3) pos(2,4)];
visible={'on','on','on','on'};
if strcmp(type,'2x2')
    pos(1,:)=[0.1 0.7 0.4 0.2];
    pos(4,:)=pos(1,:)+[pos(1,3)+0.1 0 -0.1 0];
elseif strcmp(type,'1')
    pos(1,:)=[0 0 1 1];
    visible={'on','off','off','off'};
elseif strcmp(type,'1x2')
    pos(1:2,:)=[0 0 0.5 1;0.5 0 0.5 1];
    visible={'on','on','off','off'};
elseif strcmp(type,'2x1')
    pos(1:2,:)=[0 0 1 0.4;0.1 0.6 0.7 0.5];
    visible={'on','on','off','off'};
end
for i=1:nAxes
    set(handles.axesObjs(i),'Position',pos(i,:));
    set(handles.axesObjs(i),'Visible',visible{i});
    cla(handles.axesObjs(i));
end
guidata(hObject,handles);