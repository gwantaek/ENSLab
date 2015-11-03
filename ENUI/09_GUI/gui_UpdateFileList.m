function gui_UpdateFileList(handles)
%----------------------------------------------------------
% Update File List
%
%
% Author : Gwan-Taek Lee
% Last update : 2012. 02. 04
%----------------------------------------------------------

    if handles.n_file > 0
        
        item = char({handles.Head.FileName});
        set(handles.L_File, 'Value',  handles.i_file);
        set(handles.L_File, 'String', item);
        
    else
        
        set(handles.L_File, 'Value',  []);
        set(handles.L_File, 'String', []);
        
    end

end
