function str = util_Cell2Str(cellarr, axis)
%---------------------------------------------------------------------
% Concatenate elements of cell array
%       H: {'aa','bb','cc'} -> 'aa bb cc'
%       V: {'aa','bb','cc'} -> 'aa
%                               bb
%                               cc'
%
% cellarr  : Cell Array
% axis     : 'H' or 'V'
% str      : String
%
% Author : Gwan-Taek Lee
% Last update : 2012. 02. 06.
%---------------------------------------------------------------------

    str = '';
    if(~iscell(cellarr))
        cellarr = {cellarr};
    end
    
    if(strcmpi(axis, 'H'))
        for a = 1 : length(cellarr)
            str = [str cellarr{a} ' '];
        end
    elseif(strcmpi(axis, 'V'))
        for a = 1 : length(cellarr)
            str = [str cellarr{a} char(10)];
        end        
    end
     
end