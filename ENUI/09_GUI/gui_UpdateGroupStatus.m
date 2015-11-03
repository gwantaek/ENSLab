function gui_UpdateGroupStatus(handle, Group, Head)
%----------------------------------------------------------
% Update Status
%
% handle   : Status Edit Box
% Group    : Group Struct
% Head     : Head Struct
%
% Author : Gwan-Taek Lee
% Last update : 2012. 02. 04
%----------------------------------------------------------

    n_group = length(Group);
    
    if(n_group > 1)
        
        status = [num2str(n_group) ' groups are selected.'];
        
    elseif(n_group == 0)
        
    else
        
        n_member = length(Group.Member);
        memstr = util_Cell2Str({Head(Group.Member).FileName}, 'v');

        status = ...
            ['Total ' num2str(n_member) ' Members in the ' Group.Name ' group.',...
             char(13) char(13) memstr];
         
    end
    
    set(handle, 'String', status);
            
end
