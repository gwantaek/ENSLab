function varargout = Fig_ScrollData(varargin)
% FIG_SCROLLDATA M-file for Fig_ScrollData.fig
%      FIG_SCROLLDATA, by itself, creates a new FIG_SCROLLDATA or raises the existing
%      singleton*.
%
%      H = FIG_SCROLLDATA returns the handle to a new FIG_SCROLLDATA or the handle to
%      the existing singleton*.
%
%      FIG_SCROLLDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIG_SCROLLDATA.M with the given input arguments.
%
%      FIG_SCROLLDATA('Property','Value',...) creates a new FIG_SCROLLDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Fig_ScrollData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Fig_ScrollData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Fig_ScrollData

% Last Modified by GUIDE v2.5 26-Mar-2013 14:49:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Fig_ScrollData_OpeningFcn, ...
                   'gui_OutputFcn',  @Fig_ScrollData_OutputFcn, ...
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


% --- Executes just before Fig_ScrollData is made visible.
function Fig_ScrollData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Fig_ScrollData (see VARARGIN)

% Choose default command line output for Fig_ScrollData
handles.output = hObject;

handles.event = 0;

if length(varargin) == 1
    handles.Head = [];
    handles.Data = varargin{1};
elseif length(varargin) == 2
    handles.Head = varargin{1};
    handles.Data = varargin{2};
else
    handles.Head = [];
    handles.Data = [];
end

if isempty(handles.Head)
    
else
    
    n_time = handles.Head.TimeNum;
    n_chan = length(handles.Head.DataChan);
    fs     = handles.Head.SampRate;
    
    sens = 150;
    tdsp = 10;
    tick = 1;    
    cdsp = n_chan;
    
    tmax = n_time-(fs*tdsp)+1;

    % Time Scroll
    set(handles.S_TimeScr, 'Min', 1, 'Max', tmax, 'Value', 1);
    set(handles.S_TimeScr, 'SliderStep', [fs/(tmax-1) (fs/(tmax-1))*10]);
    
    % Chan Scroll
    set(handles.S_ChanScr, 'Enable', 'off');
    set(handles.S_ChanScr, 'Min', 1, 'Max', n_chan, 'Value', 1);
    
    % Sens Scroll
    set(handles.S_SensDsp, 'Min',10, 'Max', 3000, 'Value', sens);
    set(handles.S_SensDsp, 'SliderStep', [10/(1500-10) (10/(1500-10))*10]);

    % Time Dsp
    set(handles.S_TimeDsp, 'Min', 1, 'Max', 30, 'Value', tdsp);
    set(handles.S_TimeDsp, 'SliderStep', [1/(30-1) (1/(30-1))*10]);

    % Chan Dsp
    set(handles.S_ChanDsp, 'Min', 1, 'Max', cdsp, 'Value', cdsp);
    set(handles.S_ChanDsp, 'SliderStep', [1/(cdsp-1) (1/(cdsp-1))*10]);
        
    % Time Tick
    set(handles.S_TickScr, 'Min', 1, 'Max', 30, 'Value', tick);
    set(handles.S_TickScr, 'SliderStep', [1/(30-1) (1/(30-1))*10]);
    
    % Labels
    stime = (handles.Head.StartDate + handles.Head.StartTime);
    etime = util_GetOffTime(stime, handles.Head.SampRate, handles.Head.TimeNum);
    set(handles.L_StartTime, 'String', datestr(stime,'HH.MM.SS'));
    set(handles.L_EndTime,   'String', datestr(etime,'HH.MM.SS'));

    % Event
    if ~isempty(handles.Head.Event)
        set(handles.P_EventList,'String',{handles.Head.Event.Label});
    end

    
    % Initial Update
    fig_UpdateSlider(handles);    
    fig_UpdateAxes(handles);
    fig_UpdateLabel(handles);
    
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Fig_ScrollData wait for user response (see UIRESUME)
% uiwait(handles.Fig_ScrollData);


% --- Outputs from this function are returned to the command line.
function varargout = Fig_ScrollData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function S_TimeScr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to S_TimeScr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function S_ChanScr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to S_ChanScr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function S_ChanDsp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to S_ChanDsp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function S_TimeDsp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to S_TimeDsp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function S_SensDsp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to S_SensDsp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on slider movement.
function S_TimeScr_Callback(hObject, eventdata, handles)
% hObject    handle to S_TimeScr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

fig_UpdateAxes(handles);


% --- Executes when Fig_ScrollData is resized.
function Fig_ScrollData_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to Fig_ScrollData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pos = get(hObject, 'Position');
fig_ResizeScrollData(pos(3), pos(4), handles);


% --- Executes on slider movement.
function S_ChanScr_Callback(hObject, eventdata, handles)
% hObject    handle to S_ChanScr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
   
fig_UpdateSlider(handles);
fig_UpdateAxes(handles);



% --- Executes on slider movement.
function S_ChanDsp_Callback(hObject, eventdata, handles)
% hObject    handle to S_ChanDsp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

fig_UpdateSlider(handles);
fig_UpdateAxes(handles);


% --- Executes on slider movement.
function S_SensDsp_Callback(hObject, eventdata, handles)
% hObject    handle to S_SensDsp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

fig_UpdateAxes(handles);
fig_UpdateLabel(handles);



% --- Executes on slider movement.
function S_TimeDsp_Callback(hObject, eventdata, handles)
% hObject    handle to S_TimeDsp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

fig_UpdateSlider(handles);
fig_UpdateAxes(handles);
fig_UpdateLabel(handles);


% --- Executes on slider movement.
function S_TickScr_Callback(hObject, eventdata, handles)
% hObject    handle to S_TickScr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

fig_UpdateAxes(handles);


% --- Executes during object creation, after setting all properties.
function S_TickScr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to S_TickScr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in B_PrevEvent.
function B_PrevEvent_Callback(hObject, eventdata, handles)
% hObject    handle to B_PrevEvent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fig_Move2Event(handles,-1);
fig_UpdateAxes(handles);


% --- Executes on button press in B_NextEvent.
function B_NextEvent_Callback(hObject, eventdata, handles)
% hObject    handle to B_NextEvent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fig_Move2Event(handles,1);
fig_UpdateAxes(handles);

% --- Executes on selection change in P_EventList.
function P_EventList_Callback(hObject, eventdata, handles)
% hObject    handle to P_EventList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns P_EventList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from P_EventList


% --- Executes during object creation, after setting all properties.
function P_EventList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to P_EventList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over B_PrevEvent.
function B_PrevEvent_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to B_PrevEvent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over B_NextEvent.
function B_NextEvent_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to B_NextEvent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function E_Filter_Callback(hObject, eventdata, handles)
% hObject    handle to E_Filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of E_Filter as text
%        str2double(get(hObject,'String')) returns contents of E_Filter as a double


% --- Executes during object creation, after setting all properties.
function E_Filter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to E_Filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in C_Filter.
function C_Filter_Callback(hObject, eventdata, handles)
% hObject    handle to C_Filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of C_Filter
fig_UpdateAxes(handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over C_Filter.
function C_Filter_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to C_Filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on key press with focus on C_Filter and none of its controls.
function C_Filter_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to C_Filter (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in C_Envelope.
function C_Envelope_Callback(hObject, eventdata, handles)
% hObject    handle to C_Envelope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of C_Envelope
fig_UpdateAxes(handles);
