function data = util_DataReference(data, refe)
%----------------------------------------------------------
% New Group
%
% data   : Chan * Time
% refe   : Reference channel indexes
%
% Author : Gwan-Taek Lee
% Last update : 2012. 02. 03.
%----------------------------------------------------------

    if ~isempty(refe)
        n_chan = size(data, 1);
        data = data - repmat(mean(data(refe,:), 1), [n_chan 1]);
    end
    
end