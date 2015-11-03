%% EDF to SET file
eeglab;close;clear;

save_dir = '00_data/';

[file path] = uigetfiles;

for i=1 : length(file(:,1))
    [paradigm, r] = strtok(file(i,:), '_');
    [no, r] = strtok(r, '_');
    [initial, r] = strtok(r, '_');
    [block, r] = strtok(r, '_');

    % Block ������ _block �κ��� ����
    setname = [no '_' initial '_' block];            
    filename = [paradigm '_' strtok(no,'.') '.set'];        
    
    subject = [paradigm '_' strtok(no,'.')];

    EEG = pop_biosig([path file(i,:)],'importevent','off','blockepoch','off');
    EEG.setname = setname;
    EEG.subject = subject;
    EEG.condition = block;
    pop_saveset( EEG,  'filename', filename, 'filepath', save_dir);
end

clear all; 