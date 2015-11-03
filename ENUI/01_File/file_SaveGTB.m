function [handles ok] = file_SaveGTB(handles, mode)
%----------------------------------------------------------
% Save GTB
%
%
% Author : Gwan-Taek Lee
% Last update : 2012. 2. 6
%----------------------------------------------------------

if (handles.n_file > 0) && strcmpi(handles.mode, 'file')
    
    selitem = handles.i_file;
    
    switch mode
        case 'Save'            
            for f = 1 : length(selitem)
                disp(['Saving: ' handles.Head(selitem(f)).FileName]); pause(0.00000000001);
                %file_Save(handles.Head(selitem(f)),[],[],[]);
                file_Save(handles.Head(selitem(f)), );
            end
            ok = 1;

        case 'SaveAs'     
            if length(selitem) > 1  
                
                % Multi files Save AS ///////////////////////////////                
                parms = inputdlg({'Input Suffix. (ex. filename_SUFFIX.gtb)'},'',1,{'_Suff'});
                path  = uigetdir([], 'Save Folder');
                if ~isempty(parms) && ~isequal(path, 0)
                    for f = 1 : length(selitem)
                        oldname = strtok(handles.Head(selitem(f)).FileName, '.gtb');
                        disp(['Saving: ' oldname]); pause(0.00000000001);
                        handles.Head(selitem(f)).FileName = [oldname parms{1} '.gtb'];
                        handles.Head(selitem(f)).FilePath = [path '/'];
                        file_Save(handles.Head(selitem(f)),[],[],[]);
%                         file_Save(handles.Head(selitem(f)),Data,[],[]);
                    end
                    ok = 1;
                else
                    ok = 0;
                end
            else
                
                % Single file Save AS ///////////////////////////////
                rawdata_name = handles.Head.FileName ;
                [file path] = uiputfile({'*.gtb','GTBrainWave Format (*.gtb)'}, 'Save As');
                if ~isequal(file, 0)
                    disp(['Saving: ' file]); pause(0.00000000001);
                    handles.Head(selitem).FileName = file;
                    handles.Head(selitem).FilePath = path;
                    file_Save(handles.Head(selitem),[],[],[]);
                    % `150401 copy file.GTB=====================
                    copyfile([path rawdata_name],[path file]) 
                    % _________________________________________
                    ok = 1;
                else
                    ok = 0;
                end
                
            end
            
        case 'SaveAll'
            

    end

    
else
    msgbox('Select Files!!!','Error','error');
    ok = 0;
end