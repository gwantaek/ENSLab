


function [Head Data] = ReadEDF(file, path)

%----------------------------------------------------------

% Load EDF Files and create new GTB file

%

% file       : File Name

% path       : Load Path (.edf)

%

% Head       : Header

% Data       : Data

%

% Author : Gwan-Taek Lee

% Last update : 2012. 02. 03.

%----------------------------------------------------------




    % Load EDF

    fid = fopen([path file],'r','ieee-le');

    if fid == -1,

      error('File not found ...!');

    end




    % Read Header

    hdr          = char(fread(fid,256)');

    Version      = hdr(1:8);

    PatientID    = hdr(9:88);

    RecordingID  = hdr(89:168);

    StartDate    = datenum(hdr(169:176), 'DD.MM.YY');

    StartTime    = datenum(hdr(177:184), 'HH.MM.SS');

    HeaderByte   = str2double(hdr(185:192));

    Reserved     = hdr(193:236);

    RecordNum    = str2double(hdr(237:244));

    RecordDur    = str2double(hdr(245:252));

    SignalNum    = str2double(hdr(253:256));    

    SignalLabel  = cellstr(char(fread(fid,[16,SignalNum])'));    

    Transducer   = cellstr(char(fread(fid,[80,SignalNum])'));

    PhysDim      = cellstr(char(fread(fid,[8,SignalNum])'));

    PhysMin      = str2num(char(fread(fid,[8,SignalNum])')); %#ok<ST2NM>

    PhysMax      = str2num(char(fread(fid,[8,SignalNum])')); %#ok<ST2NM>

    DigiMin      = str2num(char(fread(fid,[8,SignalNum])')); %#ok<ST2NM>

    DigiMax      = str2num(char(fread(fid,[8,SignalNum])')); %#ok<ST2NM>      

	PreFilter    = cellstr(char(fread(fid,[80,SignalNum])'));

    SampRate     = str2num(char(fread(fid,[8,SignalNum])')); %#ok<ST2NM>




    % Read Data

    fseek(fid,HeaderByte,-1);

    RawData = fread(fid,'int16');

    fclose(fid);    







    

    % ///////////////////////////////////////////////////////////

    % //////////// Make GTB Header & Data format ////////////////

    % ///////////////////////////////////////////////////////////

    

    % Header

    Head.FileType  = [];

    Head.FileName  = file;

    Head.FilePath  = path;

    Head.StartDate = floor(StartDate);

    Head.StartTime = (StartTime - floor(StartTime));

    Head.ChanNum   = SignalNum;

    Head.ChanLabel = SignalLabel;

    Head.DataChan  = 1:SignalNum;

    Head.RefeChan  = [];

    Head.EvntChan  = [];

    Head.ResvChan  = [];

    Head.PhysDim   = PhysDim;

    Head.SampRate  = SampRate(1) / RecordDur;

    Head.TimeNum   = length(RawData) / SignalNum;

    Head.Filter    = [];

    Head.Freq      = [];

    Head.Event     = [];

    Head.Stage     = [];

    

    % Data (Chan * Time)

    RawData = reshape(RawData, [SampRate(1) SignalNum RecordNum]);

    Data = zeros(SignalNum, Head.TimeNum);

    

    % Calibration

    if( min(DigiMax) == 0 && max(DigiMax) == 0 )

        Cal = (PhysMax-PhysMin) / 65535;

    else

        Cal = (PhysMax-PhysMin) ./ (DigiMax-DigiMin);

    end

    Cal(Cal == inf) = 1;

    

    for s = 1 : SignalNum

        Data(s,:) = reshape(squeeze(RawData(:,s,:)), [1 Head.TimeNum]) * Cal(s);

    end

    for i=1:SignalNum

        if( strcmpi(Head.PhysDim{i}, 'mV') )

            Data(i,:) = Data(i,:)*1000.;

        end

    end

    

end