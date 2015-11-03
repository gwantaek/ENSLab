function [handles ok] = pre_ChanRename(handles)
%----------------------------------------------------------
% Channel Rename
%
%
% Author : Gwan-Taek Lee
% Last update : 2012. 2. 6
%----------------------------------------------------------

if (handles.n_file > 0) && strcmpi(handles.mode, 'file')
    
    selitem = handles.i_file;
    oldname = handles.Head(selitem(1)).ChanLabel;
    oldname = util_Cell2Str(oldname,'h');
    parms   = inputdlg({'Rename previous channel labels.'},...
                            'Rename Channels',10,{oldname});
                    
    if ~isempty(parms)        
        newname = gui_GetParms(parms{1}, '%s', ' ');
        for i = 1 : length(selitem)
            handles.Head(selitem(i)).ChanLabel = newname;
        end
        ok = 1;
    else
        ok = 0;
    end
    
else
    msgbox('Select Files!!!','Error','error');
    ok = 0;
end