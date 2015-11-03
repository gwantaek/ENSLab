function lgt_thr_colormap(thr, max, cmap)
%----------------------------------------------------------
%
% thr     : Threshold value
% minmax  : min / max scale []
% cmap    : Original colormap
% thrcmap : thresholded color map
%
% Author : Gwan-Taek Lee
% Last update : 2011. 09. 05
%----------------------------------------------------------

    if(isempty(cmap))
        cmap = colormap('Jet(256)');
    end
    
    n_cmap = size(cmap,1)/2;
    offset = (thr / max) * n_cmap;
    cmap(floor(n_cmap-offset+1) : ceil(n_cmap+offset),:) = 1;
    
    colormap(cmap);
        
end