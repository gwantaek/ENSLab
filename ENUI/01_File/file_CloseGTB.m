function [handles ok] = file_CloseGTB(handles)
%----------------------------------------------------------
% Load GTB
%
%
% Author : Gwan-Taek Lee
% Last update : 2012. 2. 6
%----------------------------------------------------------

if handles.n_file > 0 && strcmpi(handles.mode, 'file')
    
    button = questdlg('Close files?', 'Close', 'Yes','Save','Cancel','Yes');
    
    if strcmpi(button, 'Cancel')
        ok = 0;
    else
        
        if strcmpi(button, 'Save')
            
        end
        
        % 그룹 제거 코드 추가
        
        handles.Head(handles.i_file) = [];
        handles.n_file = length(handles.Head);
        if(handles.n_file == 0)
            handles.i_file = [];
        else
            handles.i_file = 1;
        end
        ok = 1;
        
    end

else
    msgbox('Select Files!!!','Error','error');
    ok = 0;    
end
