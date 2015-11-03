function [handles ok] = pre_ChanSetting(handles)
%----------------------------------------------------------
% Bandpass Filter
%
%
% Author : Gwan-Taek Lee
% Last update : 2012. 02. 05.
%----------------------------------------------------------

if (handles.n_file > 0) && strcmpi(handles.mode, 'file')
    
    % Previous setting (Showing the setting of the first file)
    OldChanLab = handles.Head(1).ChanLabel;
    OldRefeLab = util_Cell2Str(OldChanLab(handles.Head(1).RefeChan), 'h');
    OldEvntLab = util_Cell2Str(OldChanLab(handles.Head(1).EvntChan), 'h');
    parms = inputdlg({'Reference Channels.','Event Channels'},...
                        'Channel Setting',1,{OldRefeLab,OldEvntLab});    
    
    % New setting
    if ~isempty(parms) 
        
        selitem = handles.i_file;
        RefeLab = upper(gui_GetParms(parms{1}, '%s', ' '));
        EvntLab = upper(gui_GetParms(parms{2}, '%s', ' '));
        
        for i = 1 : length(selitem)
            
            ChanLab = upper(handles.Head(selitem(i)).ChanLabel);
            
            % Reference Channel
            if strcmp(RefeLab, 'AVERAGE')
                handles.Head(selitem(i)).RefeChan =...
                    sort([handles.Head(selitem(i)).DataChan...
                            handles.Head(selitem(i)).RefeChan]);
            else
                [tmp,RefeIdx] = intersect(ChanLab, RefeLab);
                handles.Head(selitem(i)).RefeChan = sort(RefeIdx);
            end
            
            % Event Channel
            [tmp,EvntIdx] = intersect(ChanLab, EvntLab);
            handles.Head(selitem(i)).EvntChan = sort(EvntIdx);
            
            % Data Channel
            [tmp,DataIdx] = setdiff(ChanLab, [RefeLab; EvntLab]);  % Data Channel Index
            handles.Head(selitem(i)).DataChan = sort(DataIdx);     % Modify header            
            
        end
        
        ok = 1;
    
    else
        ok = 0;
    end
    
    
else
    msgbox('Select Files!!!','Error','error');
    ok = 0;
end