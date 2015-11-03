function [handles ok] = file_LoadGTB(handles)
%----------------------------------------------------------
% Load GTB
%
%
% Author : Gwan-Taek Lee
% Last update : 2012. 2. 6
%----------------------------------------------------------

global loadpath;
global Head;

[file loadpath] = uigetfile({'*.*','GTBrainWave Format (*.*)'}, 'MultiSelect','on');
savepath = loadpath; % by Lee Chany
path = savepath;

if ~isequal(file, 0)
    
    if ~iscell(file)
        file = {file};
    end
    
    n_file = length(file); 
    Head   = struct(file_GetNewHead());
    
    for i = 1 : n_file
        disp(['Loading: ' file{i}]); pause(0.00000000001);
        Head(i) = file_Load(file{i}, path, 'Head');
%         Head(i) = file_Load(file{i}, path, 'Data');
    end

    handles.Head = [handles.Head Head];
    handles.n_file = length(handles.Head);   % Update the number of files
    handles.i_file = handles.n_file;         % Select the last file

    ok = 1;
    
else
    
    ok = 0;
    
end