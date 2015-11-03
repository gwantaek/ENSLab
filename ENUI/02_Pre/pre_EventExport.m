function [handles ok] = pre_EventExport(handles)
%----------------------------------------------------------
% Import Sleep Stage Log Files
%
% Head       : Header
% selitem    : Selected File
% parms      : GUI Input Parameter
% logpath    : Log Files path 
%                - must same gtb and log filename
%                - aaa.gtb & aaa.xls
% logext     : Log Extension
%
% Author : Gwan-Taek Lee
% Last update : 2012. 02. 05.
%----------------------------------------------------------

if (handles.n_file == 1) && strcmpi(handles.mode, 'file')

    [file path] = uiputfile('*.xls','Excel file (*.xls)');
                       
    if ~isempty(file)
        Head = handles.Head(handles.i_file);

        if ~isempty(Head)
            out = cell(2,3);
            out(1,1) = {'Label'};
            out(1,2) = {'Channel'};
            out(1,3) = {'Time'};

            pt = 2;
            for e = 1 : length(Head.Event)
                for t = 1 : length(Head.Event(e).Time)
                    out(pt,1) = {Head.Event(e).Label};
                    out(pt,2) = Head.Event(e).Channel(1);
                    out(pt,3) = {Head.Event(e).Time(t)};
                    pt = pt + 1;
                end
            end
            
            xlswrite([path file], out);
            ok = 1;
        else
            ok = 0;
        end        
        
    else
        ok = 0;
    end
                    
else
    msgbox('Select Files!!!','Error','error');
    ok = 0;
end