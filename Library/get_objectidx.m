function idx = get_objectidx(objs, set)
%---------------------------------------------------------------------
% Find the index of the closest (or identical) 'obj' from the 'set'
%
% objs   : To find objects
% set    : The set of numbers
% idx    : The indexes of objs from the set
%
% Author : Gwan-Taek Lee
% Last update : 2012. 02. 02.
%---------------------------------------------------------------------

    n_obj = length(objs(:));
    n_set = length(set(:));
    idx = zeros(size(objs));    
    
    if isnumeric(set)
        % Numeric type
        for o = 1 : n_obj
            [~,idx(o)] = min(abs(set - objs(o)));
        end
            
    elseif iscell(set)
        % Cell type
        for o = 1 : n_obj
            for s = 1 : n_set
                if (strcmp(objs(o),set(s)))
                    idx(o) = s;
                    break;
                end
            end
        end

    elseif ischar(set)
        % String type
        
    else
        
    end

    
end