function edf = lgt_readedf(filename)

    % Load EDF
    fp = fopen(filename,'r','ieee-le');
    if fp == -1,
      error('File not found ...!');
    end

    % Read Header
    hdr = char(fread(fp,256)');
    header = [];
    header.ver = str2double(hdr(1:8));
    header.patient = hdr(9:88);
    header.recording = hdr(89:168);
    header.sdate = hdr(169:176);
    header.stime = hdr(177:184);
    header.length = str2double(hdr(185:192));
    header.reserved = hdr(193:236);
    header.records = str2double(hdr(237:244));
    header.duration = str2double(hdr(245:252));
    header.channels = str2double(hdr(253:256));
    
    header.chanlabel = char(fread(fp,[16,header.channels])');
    header.transducer = char(fread(fp,[80,header.channels])');
    header.physdim = char(fread(fp,[8,header.channels])');    
    header.physmin = str2num(char(fread(fp,[8,header.channels])')); %#ok<ST2NM>
    header.physmax = str2num(char(fread(fp,[8,header.channels])')); %#ok<ST2NM>
    header.digimin = str2num(char(fread(fp,[8,header.channels])')); %#ok<ST2NM>
    header.digimax = str2num(char(fread(fp,[8,header.channels])')); %#ok<ST2NM>
    header.prefilt = char(fread(fp,[80,header.channels])');
    header.samprate = str2num(char(fread(fp,[8,header.channels])')); %#ok<ST2NM>

    % Read Data
    fseek(fp,header.length,-1);
    data = fread(fp,'int16');
    fclose(fp);    
    data = reshape(data, [header.channels length(data)/8]);
    
    edf.header = header;
    edf.data = data;
end