function setFigureHandle(varargin)
handles=guidata(varargin{2});
type=varargin{1};
if strcmp(type,'value')
    handles=setfield(handles,varargin{3:end-1},varargin{end});
elseif strcmp(type,'attribute')
    set(getfield(handles,varargin{3:end-2}),varargin{end-1},varargin{end});
else
    throw(MException('wrong:option','wrong option'));
end
guidata(varargin{2},handles);