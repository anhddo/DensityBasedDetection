function varargout = demoGUI(varargin)
% DEMO MATLAB code for demo.fig
%      DEMO, by itself, creates a new DEMO or raises the existing
%      singleton*.
%
%      H = DEMO returns the handle to a new DEMO or the handle to
%      the existing singleton*.
%
%      DEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEMO.M with the given input arguments.
%
%      DEMO('Property','Value',...) creates a new DEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before demo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help demo

% Last Modified by GUIDE v2.5 23-Dec-2015 21:37:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @demo_OpeningFcn, ...
    'gui_OutputFcn',  @demo_OutputFcn, ...
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


% --- Executes just before demo is made visible.
function demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to demo (see VARARGIN)

% Choose default command line output for demo
handles.output = hObject;
dataTag=getChoosedDataset(handles);
opts=GUIinitData(dataTag);
handles.timer=timer('ExecutionMode','fixedSpacing','Period',0.001,...
    'TimerFcn',{@demoFunc,hObject},'UserData',opts,'Tag','Timer');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes demo wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function tag=getChoosedDataset(handles)
popup=handles.datasetPopup;
v=get(popup,'Value');
switch v
    case 1
        tag='mall';
    case 2
        tag='vivo1';
    case 3
        tag='crescent';
end
% --- Outputs from this function are returned to the command line.
function varargout = demo_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in startbtn.
function startbtn_Callback(hObject, eventdata, handles)
% hObject    handle to startbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
start(handles.timer);


% --- Executes on button press in pausebtn.
function pausebtn_Callback(hObject, eventdata, handles)
% hObject    handle to pausebtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop(handles.timer);
set(handles.isAutorun,'Value',0);
% set(findobj('Tag','isAutorun'),'Value',0);

% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop(handles.timer);
delete(handles.timer);


% --- Executes on button press in estbox.
function estbox_Callback(hObject, eventdata, handles)
% hObject    handle to estbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of estbox


% --- Executes on button press in isGtBox.
function isGtBox_Callback(hObject, eventdata, handles)
% hObject    handle to isGtBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of isGtBox
try
    start(handles.timer);
catch
end
% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in browseBtn.
function browseBtn_Callback(hObject, eventdata, handles)
% hObject    handle to browseBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName,~] = uigetfile('*','Select input video');
userData=get(handles.timer,'UserData');
userData.video=VideoReader(fullfile(PathName,FileName));
set(handles.timer,'UserData',userData);



function videoInputText_Callback(hObject, eventdata, handles)
% hObject    handle to videoInputText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of videoInputText as text
%        str2double(get(hObject,'String')) returns contents of videoInputText as a double


% --- Executes during object creation, after setting all properties.
function videoInputText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to videoInputText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
value=get(hObject,'Value');
% listString=get(hObject,'String');
% disOption=listString{value};
userData=get(handles.timer,'UserData');
userData.disOption=value;

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function frameId_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameId (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when selected object is changed in grouprbtn.
function grouprbtn_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in grouprbtn
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str=get(eventdata.NewValue,'Tag');
data=get(handles.timer,'UserData');
data.step=str;
set(handles.timer,'UserData',data);
start(handles.timer);


% --- Executes on button press in plsrbtn.
function plsrbtn_Callback(hObject, eventdata, handles)
% hObject    handle to plsrbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plsrbtn
function denrbtn_Callback(hObject, eventdata, handles)
function noiserbtn_Callback(hObject, eventdata, handles)
function clustrbtn_Callback(hObject, eventdata, handles)
function prevFrameBtn_Callback(hObject, eventdata, handles)
ajustFrameNumber(handles,'dec');
function Next_Callback(hObject, eventdata, handles)
ajustFrameNumber(handles,'inc');

function ajustFrameNumber(handles,type)
opts=get(handles.timer,'UserData');
if strcmp(type,'inc')
    if opts.gui.iFrame+opts.gui.framestep<=numel(opts.dtsetOpts.indexTestFile)
        opts.gui.iFrame=opts.gui.iFrame+opts.gui.framestep;
    end
elseif strcmp(type,'dec')
    if opts.gui.iFrame-opts.gui.framestep>=1
        opts.gui.iFrame=opts.gui.iFrame-opts.gui.framestep;
    end
end
set(handles.timer,'UserData',opts);
start(handles.timer);

function stepByStepCb_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    handles.grouprbtn.Children=setGroupAttribute(handles.grouprbtn.Children,'Enable','on');
else
    handles.grouprbtn.Children=setGroupAttribute(handles.grouprbtn.Children,'Enable','off');
end
if get(handles.densityBasedNonPLSrbtn,'Value')
    set(handles.plsrbtn,'Enable','off');
end
start(handles.timer);

function frameId_Callback(hObject, eventdata, handles)
opts=get(handles.timer,'UserData');
opts.gui.frameId=str2num(get(hObject,'String'));
set(handles.timer,'UserData',opts);
% set(handles.timer,'TimerFcn',{@demoFunc,handles});
start(handles.timer);

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in dataset.
function dataset_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in dataset
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in datasetPopup.
function datasetPopup_Callback(hObject, eventdata, handles)
% hObject    handle to datasetPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns datasetPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from datasetPopup
stop(handles.timer);
delete(handles.timer);
dataTag=getChoosedDataset(handles);
opts=GUIinitData(dataTag);
handles.timer=timer('ExecutionMode','fixedSpacing','Period',0.001,...
    'TimerFcn',{@demoFunc,hObject},'UserData',opts,'Tag','Timer');
% Update handles structure
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function datasetPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datasetPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in densityBasedrbtn.
function densityBasedrbtn_Callback(hObject, eventdata, handles)
% hObject    handle to densityBasedrbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of densityBasedrbtn


% --- Executes on button press in plsBasedrbtn.
function plsBasedrbtn_Callback(hObject, eventdata, handles)
% hObject    handle to plsBasedrbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plsBasedrbtn


% --- Executes on button press in isDetectBox.
function isDetectBox_Callback(hObject, eventdata, handles)
% hObject    handle to isDetectBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isDetectBox


% --- Executes on button press in isAutorun.
function isAutorun_Callback(hObject, eventdata, handles)
% hObject    handle to isAutorun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isAutorun
if get(hObject,'Value')
    set(handles.stepByStepCb,'Enable','off');
else
    set(handles.stepByStepCb,'Enable','on');
end


% --- Executes on button press in densityBasedNonPLSrbtn.
function densityBasedNonPLSrbtn_Callback(hObject, eventdata, handles)
% hObject    handle to densityBasedNonPLSrbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of densityBasedNonPLSrbtn


% --- Executes on button press in isRealTime.
function isRealTime_Callback(hObject, eventdata, handles)
% hObject    handle to isRealTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isRealTime
