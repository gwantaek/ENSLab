function file_Save(Head, Data)
%----------------------------------------------------------
% Save File
%
% Head      : 
% Data      :
% FiltData  :
% FreqData  :
%
% Author : Gwan-Taek Lee
% Last update : 2012. 2. 6
%----------------------------------------------------------

    name = Head.FileName;
    path = Head.FilePath;

    if ~isempty(dir([path name]))
        % 파일 생성
    end
    
    save([path name], 'Head','Data', '-v7.3');
    
% 2015. 10. 07 
% 하나의 파일에 저장하는 걸로 변경
% Lee, Gwan-Taek
%     if ~isempty(Data)
%         save([path name], 'Data', '-v7.3');
%     end
%     
%     if ~isempty(FiltData)
%         save([path name '.filt'], 'FiltData', '-v7.3');
%     end
%     
%     if ~isempty(FreqData)
%         save([path name '.freq'], 'FreqData', '-v7.3');
%     end

end