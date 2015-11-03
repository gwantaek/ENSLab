function [Head data] = read_EDF(file)
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
% Modified by Chany Lee
% Last update : 2013. 06. 02.
% 
%----------------------------------------------------------

    % Load EDF
    fid = fopen(file,'r');
    if fid == -1,
      error('File not found ...!');
    end

    % Read Header
    hdr          = char(fread(fid,256))';
    Version      = hdr(1:8);
    PatientID    = hdr(9:88);
    RecordingID  = hdr(89:168);
    Start_Data_str = hdr(169:176);
    Start_Time_str = hdr(177:184);
    
    in = 1;
    t = Start_Data_str;
    if( length(find('0123456789'==t(1))) && ...
            length(find('0123456789'==t(2))) && ...
            ('.'==t(3)) && ...
            length(find('0123456789'==t(4))) && ...
            length(find('0123456789'==t(5))) && ...
            ('.'==t(6)) && ...
            length(find('0123456789'==t(7))) && ...
            length(find('0123456789'==t(8))) ...
            )
        StartDate    = datenum(hdr(169:176), 'DD.MM.YY');
    end

    t = Start_Time_str;
    if( length(find('0123456789'==t(1))) && ...
            length(find('0123456789'==t(2))) && ...
            ('.'==t(3)) && ...
            length(find('0123456789'==t(4))) && ...
            length(find('0123456789'==t(5))) && ...
            ('.'==t(6)) && ...
            length(find('0123456789'==t(7))) && ...
            length(find('0123456789'==t(8))) ...
            )
        StartTime    = datenum(hdr(177:184), 'HH.MM.SS');
    end    
       
    
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
    SampNum     = str2num(char(fread(fid,[8,SignalNum])')); %#ok<ST2NM>

    % Read Data
    fseek(fid,HeaderByte,-1);
    RawData = fread(fid,'int16');
    fclose(fid);
    
    RN = floor(length(RawData)/(sum(SampNum)));
    if( RN ~= RecordNum)
        RecordNum = RN;
    end
    
    % ///////////////////////////////////////////////////////////
    % //////////// Make GTB Header & Data format ////////////////
    % ///////////////////////////////////////////////////////////
    
    % Header
    Head.FileType  = [];
    Head.FileName  = file;
    Head.StartDate = floor(StartDate);
    Head.StartTime = (StartTime - floor(StartTime));
    Head.ChanNum   = SignalNum;
    Head.ChanLabel = SignalLabel;
    Head.DataChan  = 1:SignalNum;
    Head.RefeChan  = [];
    Head.EvntChan  = [];
    Head.ResvChan  = [];
    Head.PhysDim   = PhysDim;
    Head.SampNum  = SampNum;
    TimeNum   = length(RawData) / SignalNum;
    Head.TimeNum = TimeNum;
    Head.Filter    = [];
    Head.fs = SampNum/RecordDur;;
    Head.Event     = [];
    Head.Stage     = [];
    Head.Start_Data_str = Start_Data_str;
    Head.Start_Time_str = Start_Time_str;

    % Data (Chan * Time)
%     RawData = reshape(RawData, [SampNum(1) SignalNum RecordNum]);
%     Data = zeros(SignalNum, TimeNum);
    data = cell(SignalNum,1);
%     sPosition = 1;
%     for i = 1:RecordNum
%         for j=1:SignalNum
%             i
%             ePosition = sPosition + SampNum(j) - 1;
%             data{j,(i-1)*SampNum(j)+1:i*SampNum(j)} = RawData(sPosition:ePosition);
%             sPosition = ePosition + 1;
%         end
%     end

    % Calibration
    Cal = (PhysMax-PhysMin) ./ (DigiMax-DigiMin);
    Cal(Cal == inf) = 1;   
    
    Head.Calibration = Cal;
    
    for i=1:SignalNum
        temp = zeros(SampNum(i)*RecordNum,1);
        offset = sum(SampNum(1:i-1));
        inter = sum(SampNum);
        for j = 1:RecordNum
            temp((j-1)*SampNum(i)+1:j*SampNum(i)) = RawData(offset+(j-1)*inter+1:offset+(j-1)*inter+SampNum(i));
        end
        data{i} = temp*Cal(i);
        clear temp;
    end
    
end