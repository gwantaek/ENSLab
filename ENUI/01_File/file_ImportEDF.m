function [handles ok] = file_ImportEDF(handles)
%----------------------------------------------------------
% Import EDF
%
%
% Author : Gwan-Taek Lee
% Last update : 2012. 2. 6
%----------------------------------------------------------
global loadpath;
global Head;

[file loadpath] = uigetfile({'*.edf','European Data Format (*.edf)'}, 'MultiSelect','on');
% savepath        = uigetdir(loadpath, 'Save Folder');
savepath = loadpath; % by Lee Chany
parms           = inputdlg({'File Type (EEG, ERP or PSG)'},'Input FileType',1,{'PSG'});

if ~isequal(file,0) && ~isequal(savepath,0) && ~isequal(parms,0)
    
    if ~iscell(file)
        file = {file};
    end
    
    n_file = length(file);
    Head   = struct(file_GetNewHead());
    
    for f = 1 : n_file
        disp(['Importing: ' file{f}]); pause(0.00000000001);
        [Head(f) Data] = ReadEDF(file{f}, loadpath);
        Head(f).FileType = parms{1};
        Head(f).FileName = [strtok(file{f}, '.edf') '.gtb'];
        Head(f).FilePath = [savepath];
        file_Save(Head(f), Data, [], []);
        disp('Done');
    end

    handles.Head   = [handles.Head Head];
    handles.n_file = length(handles.Head);   % Update the number of files
    handles.i_file = handles.n_file;         % Select the last file
    
    ok = 1;
    
else
    
    ok = 0;
    
end
