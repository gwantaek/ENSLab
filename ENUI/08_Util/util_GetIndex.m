function index = util_GetIndex(set, obj)
%----------------------------------------------------------
% Get index of obj from set
%
%
% Author : Gwan-Taek Lee
% Last update : 2012. 02. 05.
%----------------------------------------------------------

    index = zeros(size(obj));
    
    if isnumeric(obj)    
        
        for o = 1 : length(obj(:))
            [~,index(o)] = min(abs(set-obj(o)));
        end
        
    elseif iscell(obj)
        
        for o = 1 : length(obj(:))   % Loop용 변수로 o를 사용
            [~,index(o)] = intersect(set,obj(o));
        end
    
    elseif ischar(obj)
        
        for kk = 1:length(set)
            ele = set{kk};
            if( strcmp(obj, ele) )
                index = kk;
                break;
            end
        end
        
    end
    
    
end