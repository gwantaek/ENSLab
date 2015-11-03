function gui_UpdateGroupList(handles)
%----------------------------------------------------------
% Update Group List
%
%
% Author : Gwan-Taek Lee
% Last update : 2012. 02. 04
%----------------------------------------------------------

    if handles.n_group > 0
        
        item = char({handles.Group.Name});
        set(handles.L_Group, 'Value',  handles.i_group);
        set(handles.L_Group, 'String', item);
        
    else
        
        set(handles.L_Group, 'Value',  []);
        set(handles.L_Group, 'String', []);
        
    end
    
end
