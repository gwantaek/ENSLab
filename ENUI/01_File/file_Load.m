function field = file_Load(name, path, Field)
%----------------------------------------------------------
% Load File
%
% name      : File Name
% path      : File Path
% Field     : 'Head', 'Data', 'FiltData' or 'FreqData'
%
% Author : Gwan-Taek Lee
% Last update : 2012. 2. 6
%----------------------------------------------------------

    if strcmp(Field, 'Head')
        load([path name '.head'], Field, '-mat');
%         Head.FileName = [name '.head'];
        Head.FilePath = path;
        field = Head;
    elseif strcmp(Field, 'Data')
        load([path name], Field, '-mat');
        field = Data;
    elseif strcmp(Field, 'FiltData')
        load([path name '.filt'], Field, '-mat');
        field = FiltData;
    elseif strcmp(Field, 'FreqData')
        load([path name '.freq'], Field, '-mat');
        field = FreqData;
    else
        
        disp('Field Error');
    end          

end