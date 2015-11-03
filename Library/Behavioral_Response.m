%%
[file path] = uigetfiles;

targ_code = '4';
resp_code = '1';

n_file = length(file(:,1));
mat = cell(n_file+1, 4);
mat{1,1} = 'File'; mat{1,2} = 'Right'; mat{1,3} = 'Miss'; mat{1,4} = 'Acc_RT';

for i=1 : n_file
    fid = fopen([path file(i,:)]);
    
    right = 0;
    miss = 0;
    rt = 0;    
    
    while(~feof(fid))
        str = fgets(fid);
        [subj r] = strtok(str);
        [trial r] = strtok(r);
        [type r] = strtok(r);
        [code r] = strtok(r);
        
        if(strcmp(code, targ_code))
            str = fgets(fid);
            [subj r] = strtok(str);
            [trial r] = strtok(r);
            [type r] = strtok(r);
            [code r] = strtok(r);
            
            if(strcmp(code, resp_code))
                [time r] = strtok(r);
                [ttime r] = strtok(r);                
                right = right + 1;
                rt = rt + str2double(ttime);                
            else
                miss = miss + 1;
            end            
        end
    end
    
    mat{i+1,1} = subj;
    mat{i+1,2} = num2str(right);
    mat{i+1,3} = num2str(miss);
    mat{i+1,4} = rt;
    fclose(fid);
end

xlswrite('BR', mat);