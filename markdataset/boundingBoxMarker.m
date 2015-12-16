function varargout = boundingBoxMarker(varargin)
% BOUNDINGBOXMARKER MATLAB code for boundingBoxMarker.fig
%      BOUNDINGBOXMARKER, by itself, creates a new BOUNDINGBOXMARKER or raises the existing
%      singleton*.
%
%      H = BOUNDINGBOXMARKER returns the handle to a new BOUNDINGBOXMARKER or the handle to
%      the existing singleton*.
%
%      BOUNDINGBOXMARKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BOUNDINGBOXMARKER.M with the given input arguments.
%
%      BOUNDINGBOXMARKER('Property','Value',...) creates a new BOUNDINGBOXMARKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before boundingBoxMarker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to boundingBoxMarker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help boundingBoxMarker

% Last Modified by GUIDE v2.5 28-Mar-2015 11:03:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @boundingBoxMarker_OpeningFcn, ...
                   'gui_OutputFcn',  @boundingBoxMarker_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before boundingBoxMarker is made visible.
function boundingBoxMarker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to boundingBoxMarker (see VARARGIN)

% Choose default command line output for boundingBoxMarker
handles.output = hObject;
handles.imageID = 1;
handles.sID = 0;
handles.currentRow = 1;
handles.currentCol = 1;
handles.saveReminderCounter = 0;
handles.name_append='';
handles.path2Folder=get(handles.folderPath,'String');
% handles.matfile=fullfile('..','matfile','groundtruth.mat');
handles.matfile=fullfile('..','crescent_dataset','crescentDenGt.mat');
% handles.matfile=fullfile('..','matfile','newOriData_anh.mat');
if (exist(handles.matfile,'file'))
    load(handles.matfile);
    handles.data = newOriData;
    %Point the currentRow pointer to [the last row =/= -100] + 1
    handles.currentRow = max(find(handles.data(:,1) ~= -100)) + 1;
else
    handles.data = zeros(5000,7);
    handles.data(:) = -100;
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes boundingBoxMarker wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = boundingBoxMarker_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function drawOldInfo(imageID, sID, oriData)

imageIdx = oriData(:,1) == (imageID);
folderIdx = oriData(:,2) == sID;
negativeIdx =  oriData(:,7) ~= 0;
rows = logical(imageIdx.*folderIdx.*negativeIdx);
boxes = oriData(rows,3:6);
for b=1:size(boxes,1)
    x = boxes(b,1);
    y = boxes(b,2);
    
    w = (boxes(b,3) - boxes(b,1));
    h = (boxes(b,4) - boxes(b,2));
    
    if (x <= 0)
        x = 1;
    end
    if (y <= 0)
        y = 1;
    end
    if (w <=0)
        w = abs(w);
        x = boxes(b,3);
    end
    if (h <= 0)
        h = abs(h);
        y = boxes(b,4);
    end
    rect = rectangle('Position', [x y w h], 'LineWidth', 0.5, 'EdgeColor', [0 1 0]);
    set(rect,'ButtonDownFcn',@ImageClickCallback);
end

% --- Executes on button press in btnLoad.
function btnLoad_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
%Load image and display bounding/ori information
imgName = ['seq_' sprintf('%06d', handles.imageID) '.jpg'];
fullPath = fullfile(handles.path2Folder,imgName);
img = imread(fullPath);
set(handles.imageIDText, 'String', handles.imageID);
set(handles.text2, 'String', imgName);
hold off;
imageHandle = imshow(img);
hold on;

drawOldInfo(handles.imageID, handles.sID, handles.data);

set(imageHandle,'ButtonDownFcn',@ImageClickCallback);

function folderPath_Callback(hObject, eventdata, handles)
% hObject    handle to folderPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
handles.path2Folder = get(hObject,'String');

guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of folderPath as text
%        str2double(get(hObject,'String')) returns contents of folderPath as a double


% --- Executes during object creation, after setting all properties.
function folderPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to folderPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function imageIDText_Callback(hObject, eventdata, handles)
% hObject    handle to imageIDText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
imageID = get(hObject,'String');
handles.imageID = str2num(imageID);

guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of imageIDText as text
%        str2double(get(hObject,'String')) returns contents of imageIDText as a double


% --- Executes during object creation, after setting all properties.
function imageIDText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageIDText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnNext.
function btnNext_Callback(hObject, eventdata, handles)
% hObject    handle to btnNext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
handles.imageID = handles.imageID+5;

%Load image and display bounding/ori information
imgName = ['seq_' sprintf('%06d', handles.imageID) '.jpg'];
fullPath = fullfile(handles.path2Folder ,imgName);
img = imread(fullPath);
set(handles.imageIDText, 'String', handles.imageID);
set(handles.text2, 'String', imgName);
hold off;
imageHandle = imshow(img);
hold on;

drawOldInfo(handles.imageID, handles.sID, handles.data);
set(imageHandle,'ButtonDownFcn',@ImageClickCallback);
guidata(hObject, handles);


% --- Executes on button press in btnPrevious.
function btnPrevious_Callback(hObject, eventdata, handles)
% hObject    handle to btnPrevious (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
handles.imageID = handles.imageID-51;
if (handles.imageID <= 0)
    handles.imageID = 1;
end
%Load image and display bounding/ori information
imgName = ['seq_' sprintf('%06d', handles.imageID) '.jpg'];
fullPath = fullfile(handles.path2Folder ,imgName);


img = imread(fullPath);

set(handles.imageIDText, 'String', handles.imageID);
set(handles.text2, 'String', imgName);
hold off;
imageHandle = imshow(img);
hold on;

drawOldInfo(handles.imageID, handles.sID, handles.data);
set(imageHandle,'ButtonDownFcn',@ImageClickCallback);
guidata(hObject, handles);


% --- Executes on button press in btnUndo.
function btnUndo_Callback(hObject, eventdata, handles)
% hObject    handle to btnUndo (see GCBO)
% eventdata  reserved - to be defined in a future version of btnlo
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
if (sum(handles.data(handles.currentRow,:)) == -700)
    handles.currentRow = handles.currentRow - 1;
    handles.data(handles.currentRow,:) = -100;
else
    handles.data(handles.currentRow,:) = -100;
end

if(handles.currentRow <=0 )
    handles.currentRow = 1;
end
handles.currentCol = 1;
imgName = ['seq_' sprintf('%06d', handles.imageID) '.jpg'];
fullPath = fullfile(handles.path2Folder ,imgName);
img = imread(fullPath);
hold off;
imageHandle = imshow(img);
hold on;

drawOldInfo(handles.imageID, handles.sID, handles.data);
set(imageHandle,'ButtonDownFcn',@ImageClickCallback);

guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of oriRadio

% --- Executes on button press in btnSave.
function btnSave_Callback(hObject, eventdata, handles)
handles.saveReminderCounter = 0;
% set(handles.saveReminder, 'String', '');
newOriData = handles.data;
% matfile=get(handles.matfile,'String');
matfile=handles.matfile;
save(matfile,'newOriData');
guidata(hObject, handles);
% hObject    handle to btnSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in btnBrowse.
function btnBrowse_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
handles.path2Folder = uigetdir();
%Taking last letter as sID
handles.data(handles.currentRow,2) = handles.sID;

set(handles.folderPath, 'String', handles.path2Folder);
guidata(hObject,handles);
% hObject    handle to btnBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Display bounding box and orientation line on image
function infoDisplay (data, r, isBox)
    x1 = data(r,3);
    y1 = data(r,4);
    x2 = data(r,5);
    y2 = data(r,6);
    if (x1 >= x2)
        x = x2;
    else
        x = x1;
    end
    if (y1 >= y2)
        y = y2;
    else
        y = y1;
    end
    w = abs(x2-x1+1);
    h = abs(y2-y1+1);
    r = rectangle('Position',[x,y,w,h],'LineWidth',0.5,'EdgeColor',[0 1 0]);
    set(r,'ButtonDownFcn',@ImageClickCallback);

    
% --- 
function ImageClickCallback ( hObject , eventData )
handles = guidata(hObject);
axesHandle  = get(hObject,'Parent');
coordinates = get(axesHandle,'CurrentPoint'); 
coordinates = coordinates(1,1:2);
handles.currentCol = handles.currentCol + 2;
r = handles.currentRow;
c = handles.currentCol;
handles.data(r,c) = coordinates(1);
handles.data(r,c+1) = coordinates(2);


if (handles.currentCol == 5)
   infoDisplay (handles.data, r, 1)
   handles.data(handles.currentRow, 1) = handles.imageID;
   handles.data(handles.currentRow, 2) = handles.sID;
   handles.data(r,7) = 1;
   handles.currentCol = 1;
   handles.currentRow = handles.currentRow + 1;
end

if (handles.currentCol == 9)
   infoDisplay (handles.data, r, 0);
   %Move to another row
   
end
% disp(handles.data(r,:));
guidata(hObject,handles);
