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
        % ���� ����
    end
    
    save([path name], 'Head','Data', '-v7.3');
    
% 2015. 10. 07 
% �ϳ��� ���Ͽ� �����ϴ� �ɷ� ����
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