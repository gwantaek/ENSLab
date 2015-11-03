function varargout = ENUI(varargin)
% ENUI M-file for ENUI.fig
%      ENUI, by itself, creates a new ENUI or raises the existing
%      singleton*.
%
%      H = ENUI returns the handle to a new ENUI or the handle to
%      the existing singleton*.
%
%      ENUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENUI.M with the given input arguments.
%
%      ENUI('Property','Value',...) creates a new ENUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ENUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ENUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ENUI

% Last Modified by GUIDE v2.5 02-Apr-2015 13:58:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ENUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ENUI_OutputFcn, ...
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


% --- Executes just before ENUI is made visible.
function ENUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ENUI (see VARARGIN)

% Choose default command line output for ENUI
handles.output = hObject;

path(path,'01_File');
path(path,'02_Pre');
path(path,'03_EEG');
path(path,'04_ERP');
path(path,'05_PSG');
path(path,'06_Freq');
path(path,'08_Util');
path(path,'09_GUI');
path(path,'10_Library');
path(path,'20_Meta');
path(path,'09_GUI/Fig_ScrollData');


% Initialize
handles.Head = [];
handles.Group = [];
handles.n_file = 0;
handles.i_file = [];
handles.n_group = 0;
handles.i_group = [];
handles.mode = 'file'; % 'file' or 'group'

gui_UpdateFileStatus(handles);
gui_UpdateFileList(handles);
gui_UpdateGroupList(handles);
                  
% Update handles structure
guidata(hObject, handles);
axes(handles.axes2);
a = imread('09_GUI/logo.jpg');
image(a);
axis off;

% UIWAIT makes ENUI wait for user response (see UIRESUME)
% uiwait(handles.Main);


% --- Outputs from this function are returned to the command line.
function varargout = ENUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% ///////////////////////////////////////////////////////////////////
% File Menu Callback
% ///////////////////////////////////////////////////////////////////


% --------------------------------------------------------------------
function M_FileImportEDF_Callback(hObject, eventdata, handles)
% hObject    handle to M_FileImportEDF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles ok] = file_ImportEDF(handles);
if ok
    gui_UpdateFileStatus(handles);
    gui_UpdateFileList(handles);
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function M_FileLoadGTB_Callback(hObject, eventdata, handles)
% hObject    handle to M_FileImportEDF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles ok] = file_LoadGTB(handles);
if ok
    gui_UpdateFileStatus(handles);
    gui_UpdateFileList(handles);
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function M_FileClose_Callback(hObject, eventdata, handles)
% hObject    handle to M_FileClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles ok] = file_CloseGTB(handles);
if ok
    gui_UpdateFileStatus(handles);
    gui_UpdateFileList(handles);
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function M_FileSave_Callback(hObject, eventdata, handles)
% hObject    handle to M_FileSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles ok] = file_SaveGTB(handles, 'Save');
if ok
    gui_UpdateFileStatus(handles);
    gui_UpdateFileList(handles);
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function M_FileSaveAs_Callback(hObject, eventdata, handles)
% hObject    handle to M_FileSaveAs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles ok] = file_SaveGTB(handles, 'SaveAs');
if ok
    gui_UpdateFileStatus(handles);
    gui_UpdateFileList(handles);
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function M_FileSaveAll_Callback(hObject, eventdata, handles)
% hObject    handle to M_FileSaveAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles ok] = file_SaveGTB(handles, 'SaveAll');
if ok
    gui_UpdateFileStatus(handles);
    gui_UpdateFileList(handles);
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function M_FileExit_Callback(hObject, eventdata, handles)
% hObject    handle to M_FileExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % save dialog Ãß°¡
    close;

    
    
    
    
    
    
    
    
% ///////////////////////////////////////////////////////////////////
% Pre-Processing Menu Callback
% ///////////////////////////////////////////////////////////////////    


% --------------------------------------------------------------------
function M_PreChanRename_Callback(hObject, eventdata, handles)
% hObject    handle to M_PreChanRename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles ok] = pre_ChanRename(handles);
if ok
    gui_UpdateFileStatus(handles);
    gui_UpdateFileList(handles);
    guidata(hObject, handles);
end



% --------------------------------------------------------------------
function M_PreChanSetting_Callback(hObject, eventdata, handles)
% hObject    handle to M_PreChanSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles ok] = pre_ChanSetting(handles);
if ok
    gui_UpdateFileStatus(handles);
    gui_UpdateFileList(handles);
    guidata(hObject, handles);
end



% --------------------------------------------------------------------
function M_PreChanRemove_Callback(hObject, eventdata, handles)
% hObject    handle to M_PreChanRemove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles ok] = pre_ChanDelete(handles);
if ok
    gui_UpdateFileStatus(handles);
    gui_UpdateFileList(handles);
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function M_PreChanCoordinate_Callback(hObject, eventdata, handles)
% hObject    handle to M_PreChanCoordinate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function M_PreFilter_Callback(hObject, eventdata, handles)
% hObject    handle to M_PreFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles ok] = pre_Filter(handles);
if ok
    gui_UpdateFileStatus(handles);
    gui_UpdateFileList(handles);
    guidata(hObject, handles);
end



% --------------------------------------------------------------------
function M_PsgSleepStage_Callback(hObject, eventdata, handles)
% hObject    handle to M_PsgSleepStage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles ok] = psg_SleepStage(handles);
if ok
    gui_UpdateFileStatus(handles);
    gui_UpdateFileList(handles);
    guidata(hObject, handles);
end






% ///////////////////////////////////////////////////////////////////
% PSG Menu Callback
% ///////////////////////////////////////////////////////////////////

% --------------------------------------------------------------------
function M_PsgPowerSpectrum_Callback(hObject, eventdata, handles)
% hObject    handle to M_PsgPowerSpectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function M_Psg_Callback(hObject, eventdata, handles)
% hObject    handle to M_Psg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function M_PsgPowerSpectrumStage_Callback(hObject, eventdata, handles)
% hObject    handle to M_PsgPowerSpectrumStage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
psg_PowerSpectrumStage(handles);


% --------------------------------------------------------------------
function M_PsgPowerSpectrumSeries_Callback(hObject, eventdata, handles)
% hObject    handle to M_PsgPowerSpectrumSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
psg_PowerSpectrumSeries(handles);


% --------------------------------------------------------------------
function M_PsgPowerSpectrumExport_Callback(hObject, eventdata, handles)
% hObject    handle to M_PsgPowerSpectrumExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
psg_PowerSpectrumExport(handles);


% --------------------------------------------------------------------
function M_PsgDetectSpindle_Callback(hObject, eventdata, handles)
% hObject    handle to M_PsgDetectSpindle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles ok] = psg_DetectSpindle(handles);
if ok
    gui_UpdateFileStatus(handles);
    gui_UpdateFileList(handles);
    guidata(hObject, handles);
end




% ///////////////////////////////////////////////////////////////
% GUI Callback
% ///////////////////////////////////////////////////////////////

% --- Executes during object creation, after setting all properties.
function E_Status_CreateFcn(hObject, eventdata, handles)
% hObject    handle to E_Status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function E_Process_Callback(hObject, eventdata, handles)
% hObject    handle to E_Process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of E_Process as text
%        str2double(get(hObject,'String')) returns contents of E_Process as a double


% --- Executes during object creation, after setting all properties.
function E_Process_CreateFcn(hObject, eventdata, handles)
% hObject    handle to E_Process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in L_File.
function L_File_Callback(hObject, eventdata, handles)
% hObject    handle to L_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns L_File contents as cell array
%        contents{get(hObject,'Value')} returns selected item from L_File

i_file = get(hObject, 'Value');
if(i_file > 0)
    handles.i_file = i_file;
    handles.mode   = 'file';    
    gui_UpdateFileStatus(handles);
    guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function L_File_CreateFcn(hObject, eventdata, handles)
% hObject    handle to L_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function E_Status_Callback(hObject, eventdata, handles)
% hObject    handle to E_Status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of E_Status as text
%        str2double(get(hObject,'String')) returns contents of E_Status as a double


% --- Executes on selection change in L_Group.
function L_Group_Callback(hObject, eventdata, handles)
% hObject    handle to L_Group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns L_Group contents as cell array
%        contents{get(hObject,'Value')} returns selected item from L_Group

i_group = get(hObject, 'Value');
if(i_group > 0)
    gui_UpdateGroupStatus(handles.E_Status, handles.Group(i_group), handles.Head);
    handles.i_group = i_group;
    handles.mode = 'group';
    guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function L_Group_CreateFcn(hObject, eventdata, handles)
% hObject    handle to L_Group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in B_Group.
function B_Group_Callback(hObject, eventdata, handles)
% hObject    handle to B_Group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gmember = get(handles.L_File, 'Value');

if ~isempty(gmember) && strcmpi(handles.mode, 'file')
    
    parms = inputdlg({'Input Group Name'},'',1,...
                    {['Group ' num2str(handles.n_group+1)]});
                
    if(~isempty(parms))

        gname = parms{1};

        Group = struct(file_GetNewGroup(gname, gmember));
        handles.Group = [handles.Group Group];
        handles.n_group = length(handles.Group);  % Update the number of group
        handles.i_group = handles.n_group;          % Select the last group
        handles.mode = 'group';

        gui_UpdateGroupList(handles);
        gui_UpdateGroupStatus(handles.E_Status,...
                        handles.Group(handles.i_group), handles.Head);
        guidata(hObject, handles);
        
    end
end
  

% --- Executes on button press in B_UnGroup.
function B_UnGroup_Callback(hObject, eventdata, handles)
% hObject    handle to B_UnGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

group = get(handles.L_Group, 'Value');

if(group ~= 0)
    
end


% --------------------------------------------------------------------
function M_PreEvent_Callback(hObject, eventdata, handles)
% hObject    handle to M_PreEvent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function M_PreEventImport_Callback(hObject, eventdata, handles)
% hObject    handle to M_PreEventImport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles ok] = pre_EventImport(handles);
if ok
    gui_UpdateFileStatus(handles);
    gui_UpdateFileList(handles);
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function M_PreEventExport_Callback(hObject, eventdata, handles)
% hObject    handle to M_PreEventExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles ok] = pre_EventExport(handles);
if ok
    gui_UpdateFileStatus(handles);
    gui_UpdateFileList(handles);
    guidata(hObject, handles);
end






% --------------------------------------------------------------------
function M_File_Callback(hObject, eventdata, handles)
% hObject    handle to M_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function M_PreProcessing_Callback(hObject, eventdata, handles)
% hObject    handle to M_PreProcessing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function M_PreChannel_Callback(hObject, eventdata, handles)
% hObject    handle to M_PreChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function M_ScrollingTimeSeries_Callback(hObject, eventdata, handles)
% hObject    handle to M_ScrollingTimeSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selitem = get(handles.L_File,'value');
if ~isempty(selitem) && strcmpi(handles.mode, 'file')
    head = handles.Head(selitem);
    data = file_Load(head.FileName, head.FilePath, 'Data');
    data = util_DataReference(data, head.RefeChan);
	Fig_ScrollData(head, data);
end


% --- Executes during object creation, after setting all properties.
function A_Logo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A_Logo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate A_Logo
img = imread('logo1.png');
image(img, 'Parent', hObject);
axis off;
axis image;


% --------------------------------------------------------------------
function M_Scrolling_Callback(hObject, eventdata, handles)
% hObject    handle to M_Scrolling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function M_ImportSleepSpindle_Callback(hObject, eventdata, handles)
% hObject    handle to M_ImportSleepSpindle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles ok] = psg_ImportSleepSpindle(handles);
if ok
    gui_UpdateFileStatus(handles);
    gui_UpdateFileList(handles);
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function M_SenSpeTable_Callback(hObject, eventdata, handles)
% hObject    handle to M_SenSpeTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
psg_FindSensitivitySpecificityTable(handles);


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --------------------------------------------------------------------
function SAI_Callback(hObject, eventdata, handles)
% hObject    handle to SAI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles ok] = psg_SleepAtoniaIndex(handles);
if ok
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function M_PsgPowerSpectrumExport2_Callback(hObject, eventdata, handles)
% hObject    handle to M_PsgPowerSpectrumExport2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
psg_PowerSpectrumExport2(handles);


% 150402 band & export to excel file------------------------------------
function psg_PowerSpectrumStage_band_Callback(hObject, eventdata, handles)
psg_PowerSpectrumStage_band(handles);
