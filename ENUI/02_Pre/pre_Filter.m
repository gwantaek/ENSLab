function [handles ok] = pre_Filter(handles)
%----------------------------------------------------------
% Bandpass Filter
%
%
% Author : Gwan-Taek Lee
% Last update : 2012. 02. 05.
%----------------------------------------------------------

if (handles.n_file > 0) && strcmpi(handles.mode, 'file')
    
    parms = inputdlg({'High-Pass Frequency (Hz)',...
                      'Low-Pass Frequency (Hz)',...
                      'Window','Order'},...
                      'Bandpass Filter',1,{'0.5','55','hann',''});
    
    selitem = handles.i_file;
    if ~isempty(parms)
        
        hp = gui_GetParms(parms{1},'%f',' ');
        lp = gui_GetParms(parms{2},'%f',' ');
        win = parms{3};
        mul = gui_GetParms(parms{4}, '%f', ' ');
        
        for i = 1 : length(selitem)
            Head    = handles.Head(selitem(i));
            disp(['Filtering: ' Head.FileName]); pause(0.000000000001);
            
            name    = Head.FileName;
            path    = Head.FilePath;
            fs      = Head.SampRate;
            Data    = file_Load(name,path,'Data');
            
            Data = util_DataReference(Data, Head.RefeChan);
            
            Data = my_filter(Data,[hp lp], fs);
%             for c = 1 : Head.ChanNum
%                 [Data(c,:) b] = FirFilter(Data(c,:),fs,[hp lp],win,mul);
%             end            

            Head.Filter = [num2str(hp) '-' num2str(lp) 'Hz'];

            disp(['Saving: ' name]); pause(0.000000000001);
            file_Save(Head,Data,[],[]);
            
            handles.Head(selitem(i)) = Head;
        end

        ok = 1;
        figure;freqz(Data);
        disp('Filtering Done');

    else
        ok = 0;
    end
    
else
    ok = 0;
end
