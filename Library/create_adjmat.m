function adjmat = create_adjmat(node_pair, node_order)
%----------------------------------------------------------
% Create adjacency (connectivity) matrix from the matrix of node pair
%
% node_pair   : the matrix of node pair (ex. PLV)
% node_order  : realign the order of node
% adjmat      : adjacency matrix (the number of node X the number of node)
%
% Author : Gwan-Taek Lee
% Last update : 2011. 01. 03
%----------------------------------------------------------
    
    nNode = length(node_order);
    
    if (nchoosek(nNode, 2) ~= length(node_pair))
        
        error('The number of node is not consistenct with the node of pair');
        
    else
        
        adjmat = zeros(nNode);
        node_idx = nchoosek(node_order, 2);

        k = 1;
        for r = 1 : nNode
            for c = r + (1 : nNode - r)
                adjmat(node_idx(k, 1), node_idx(k, 2)) = node_pair(k);
                k = k + 1;
            end
        end

        adjmat = adjmat + adjmat';
    end
end