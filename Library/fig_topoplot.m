function fig_topoplot(cfg, color, sync)
% 2011. 7. 22
% written by Lee Gwan-Taek

% Common option
% cfg.layout         = 'path/filename.lay'
% cfg.type           = 'both' or 'color' or 'sync'
% cfg.lay_color      = 'black' or 'red' or 'blue' or etc.
% cfg.lay_width      = width of layout
% cfg.electrodes     = 'o' or '.' or ''

% Color option
% cfg.maplimits      = 'absmax' or 'maxmin' or [values]
% cfg.colormap       = colormap
% cfg.color_thr      = double
% cfg.surf_cont      = 'both' or 'surf' or 'cont'

% Sync option
% cfg.pairlabel      = {N of pairs X 2} cell variable
% cfg.synccolor      = 'black' or 'red' or 'blue' or etc.
% cfg.syncwidth      = width of line

    if ~isfield(cfg,'type'),       cfg.type       = 'both';    end;
    if ~isfield(cfg,'lay_color'),  cfg.lay_color  = 'black';   end;
    if ~isfield(cfg,'lay_width'),  cfg.lay_width  = 2;         end;
    if ~isfield(cfg,'electrodes'), cfg.electrodes = 'o';       end;

    if ~isfield(cfg,'maplimits'),  cfg.maplimits  = 'absmax';  end;
    if ~isfield(cfg,'colormap'),   cfg.colormap   = colormap;  end;
    if ~isfield(cfg,'color_thr'),  cfg.color_thr  = [];        end;
    if ~isfield(cfg,'surf_cont'),  cfg.surf_cont  = 'both';    end;
    if ~isfield(cfg,'sig'),        cfg.sig        = [];        end;
    if ~isfield(cfg,'sig_color'),  cfg.sig_color  = 'k';       end;
    if ~isfield(cfg,'sig_size'),   cfg.sig_size   = 12;        end;

    if ~isfield(cfg,'synccolor'),  cfg.synccolor  = 'black';   end;
    if ~isfield(cfg,'syncwidth'),  cfg.syncwidth  = 2;         end;
    if ~isfield(cfg,'sync_thr'),   cfg.sync_thr  = [];         end;


    % Create layout
    lay = my_prepare_layout(cfg.layout);

    if ~strcmp(cfg.type, 'sync');
        plot_color(lay, color, cfg.maplimits, cfg.colormap, cfg.color_thr, cfg.surf_cont)
    end

    if ~strcmp(cfg.type, 'color');
        plot_sync(lay, cfg.pairlabel, sync, cfg.sync_thr, cfg.synccolor, cfg.syncwidth);
    end

    if ~isempty(cfg.sig);
        plot_sig(lay, cfg.sig, cfg.sig_color, cfg.sig_size);
    end
    
    plot_mylay(lay, cfg.lay_color, cfg.lay_width, cfg.electrodes);

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTION
% plot_sig
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_sig(lay, sig, color, size)

    hold on
    
    for i=1 : length(sig)
        X = lay.pos(sig,1);
        Y = lay.pos(sig,2);
        h = text(X,Y,'��', 'FontSize', size, 'Color', color,...
                            'HorizontalAlignment', 'center');
    end

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTION
% plot_sync
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_sync(lay, pairlabel, sync, thr, synccolor, syncwidth)

    hold on

    if ~isempty(thr)
        sync = find(sync > thr);
    end
    
    for i=1 : length(sync)
        chan1 = find(strcmp(lay.label, pairlabel(sync(i),1)));
        chan2 = find(strcmp(lay.label, pairlabel(sync(i),2)));
        X = [lay.pos(chan1,1), lay.pos(chan2,1)];
        Y = [lay.pos(chan1,2), lay.pos(chan2,2)];
        h = line(X, Y);
        set(h, 'color', synccolor);
        set(h, 'linewidth', syncwidth);    
    end

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTION
% plot_mylay
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_mylay(lay, lay_color, lay_width, electrodes)

    hold on;

    point = true;
    box = false;
    label = false;
    mask = true;
    outline = true;
    verbose = false;

    hpos = 0;
    vpos = 0;
    pointsize = 2;
    pointcolor = [0,0,0];
    pointsymbol = electrodes;



    % everything is added to the current figure
    holdflag = ishold;
    hold on

    X      = lay.pos(:,1) + hpos;
    Y      = lay.pos(:,2) + vpos;
    Width  = lay.width;
    Height = lay.height;
    Lbl    = lay.label;

    if point
      if ~isempty(pointsymbol) && ~isempty(pointcolor) && ~isempty(pointsize) % if they're all non-empty, don't use the default
        plot(X, Y, 'marker',pointsymbol,'color',pointcolor,'markersize',pointsize,'linestyle','none');
      else
        plot(X, Y, 'marker','.','color','b','linestyle','none');
        plot(X, Y, 'marker','o','color','y','linestyle','none');
      end
    end

    if label
      text(X+labeloffset, Y+(labeloffset*1.5), Lbl,'fontsize',labelsize);
    end

    if box
      line([X-Width/2 X+Width/2 X+Width/2 X-Width/2 X-Width/2]',[Y-Height/2 Y-Height/2 Y+Height/2 Y+Height/2 Y-Height/2]');
    end

    if outline && isfield(lay, 'outline')
      if verbose  
        fprintf('solid lines indicate the outline, e.g. head shape or sulci\n');
      end
      for i=1:length(lay.outline)
        if ~isempty(lay.outline{i})
          X = lay.outline{i}(:,1) + hpos;
          Y = lay.outline{i}(:,2) + vpos;
          h = line(X, Y);
          set(h, 'color', lay_color);
          set(h, 'linewidth', lay_width);
        end
      end
    end

    if mask && isfield(lay, 'mask')
      if verbose
        fprintf('dashed lines indicate the mask for topograpic interpolation\n');
      end  
      for i=1:length(lay.mask)
        if ~isempty(lay.mask{i})
          X = lay.mask{i}(:,1) + hpos;
          Y = lay.mask{i}(:,2) + vpos;
          % the polygon representing the mask should be closed
          X(end+1) = X(1);
          Y(end+1) = Y(1);
          h = line(X, Y);
          set(h, 'color', 'k');
          set(h, 'linewidth', 1.5);
          set(h, 'linestyle', ':');
        end
      end
    end

    axis auto
    axis equal
    axis off

    if ~holdflag
      hold off
    end

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTION
% plot_color
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_color(lay, color, maplimits, cmap, thr, surf_cont)

    x = lay.pos(:,1);
    y = lay.pos(:,2);

    % find limits for interpolation:
    xmin = +inf;
    xmax = -inf;
    ymin = +inf;
    ymax = -inf;

    for i=1:length(lay.mask)
        xmin = min([xmin; lay.mask{i}(:,1)]);
        xmax = max([xmax; lay.mask{i}(:,1)]);
        ymin = min([ymin; lay.mask{i}(:,2)]);
        ymax = max([ymax; lay.mask{i}(:,2)]);
    end

    xi = linspace(xmin,xmax,100);   % x-axis for interpolation (row vector)
    yi = linspace(ymin,ymax,100);   % y-axis for interpolation (row vector)
    [Xi,Yi,Zi] = griddata(x', y, color, xi', yi, 'v4'); % Interpolate the topographic data

    % calculate colormap limits
    m = size(cmap,1);
    if ischar(maplimits)
        if strcmp(maplimits,'absmax')
          amin = -max(max(abs(Zi)));
          amax = max(max(abs(Zi)));
        elseif strcmp(maplimits,'maxmin')
          amin = min(min(Zi));
          amax = max(max(Zi));
        end
    else
        amin = maplimits(1);
        amax = maplimits(2);
    end

    % FIXME, according to Ingrid and Robert (19 Oct 2009), these deltas probably should be 0
    deltax = xi(2)-xi(1); % length of grid entry
    deltay = yi(2)-yi(1); % length of grid entry

    % apply anatomical mask to the data, i.e. that determines that the interpolated data outside the circle is not displayed
    maskA = false(size(Zi));
    for i=1:length(lay.mask)
        lay.mask{i}(end+1,:) = lay.mask{i}(1,:); % force them to be closed
        maskA(inside_contour([Xi(:) Yi(:)], lay.mask{i})) = true;
    end
    Zi(~maskA) = NaN;

    if ~isempty(thr)
        maskB = ~(Zi < thr & Zi > -thr);
        Zi = Zi .* maskB;
        cmap(33,:) = 1;
    end
    
    hold on

    % Draw topoplot on head
    if strcmp(surf_cont, 'surf')
        h = surface(Xi-deltax/2,Yi-deltay/2,zeros(size(Zi)),Zi,...
            'EdgeColor','none', 'FaceColor','interp');
    elseif strcmp(surf_cont, 'cont')
        contourf(Xi,Yi,Zi,6);
    elseif strcmp(surf_cont, 'both')
        h = surface(Xi-deltax/2,Yi-deltay/2,zeros(size(Zi)),Zi,...
            'EdgeColor','none', 'FaceColor','interp');
        contour(Xi,Yi,Zi,6,'k');
    end

    % set coloraxis
    caxis([amin amax]); % set coloraxis
    colormap(cmap);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTION
% my_prepare_layout
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lay = my_prepare_layout(layout)

    disp(['reading layout from file ' layout]);
    lay = readlay(layout);  



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % check whether outline and mask are available
    % if not, add default "circle with triangle" to resemble the head
    % in case of "circle with triangle", the electrode positions should also be
    % scaled
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    rmax  = 0.5;
    l     = 0:2*pi/100:2*pi;
    HeadX = cos(l).*rmax;
    HeadY = sin(l).*rmax;
    NoseX = [0.18*rmax 0 -0.18*rmax];
    NoseY = [rmax-.004 rmax*1.15 rmax-.004];
    EarX  = [.497 .510 .518 .5299 .5419 .54 .547 .532 .510 .489];
    EarY  = [.0555 .0775 .0783 .0746 .0555 -.0055 -.0932 -.1313 -.1384 -.1199];
    % Scale the electrode positions to fit within a unit circle, i.e. electrode radius = 0.45
    ind_scale = strmatch('SCALE', lay.label);
    ind_comnt = strmatch('COMNT', lay.label);
    sel = setdiff(1:length(lay.label), [ind_scale ind_comnt]); % these are excluded for scaling
    x = lay.pos(sel,1);
    y = lay.pos(sel,2);
    xrange = range(x);
    yrange = range(y);
    % First scale the width and height of the box for multiplotting
    lay.width  = lay.width./xrange;
    lay.height = lay.height./yrange;
    % Then shift and scale the electrode positions
    lay.pos(:,1) = 0.9*((lay.pos(:,1)-min(x))/xrange-0.5);
    lay.pos(:,2) = 0.9*((lay.pos(:,2)-min(y))/yrange-0.5);
    % Define the outline of the head, ears and nose
    lay.outline{1} = [HeadX(:) HeadY(:)];
    lay.outline{2} = [NoseX(:) NoseY(:)];
    lay.outline{3} = [ EarX(:)  EarY(:)];
    lay.outline{4} = [-EarX(:)  EarY(:)];
    % Define the anatomical mask based on a circular head
    lay.mask{1} = [HeadX(:) HeadY(:)];
    
end
function lay = readlay(filename)
    if ~exist(filename, 'file')
      error(sprintf('could not open layout file: %s', filename));
    end
    [chNum,X,Y,Width,Height,Lbl,Rem] = textread(filename,'%f %f %f %f %f %q %q');

    if length(Rem)<length(Lbl)
      Rem{length(Lbl)} = [];
    end

    for i=1:length(Lbl)
      if ~isempty(Rem{i})
        % this ensures that channel names with a space in them are also supported (i.e. Neuromag)
        Lbl{i} = [Lbl{i} ' ' Rem{i}];
      end
    end
    lay.pos    = [X Y];
    lay.width  = Width;
    lay.height = Height;
    lay.label  = Lbl;
    return % function readlay  
    
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTION
% inside_contour
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function bool = inside_contour(pos, contour)

    npos = size(pos,1);
    ncnt = size(contour,1);
    x = pos(:,1);
    y = pos(:,2);

    minx = min(x);
    miny = min(y);
    maxx = max(x);
    maxy = max(y);

    bool = true(npos,1);
    bool(x<minx) = false;
    bool(y<miny) = false;
    bool(x>maxx) = false;
    bool(y>maxy) = false;

    % the summed angle over the contour is zero if the point is outside, and 2*pi if the point is inside the contour
    % leave some room for inaccurate f
    critval = 0.1;

    % the remaining points have to be investigated with more attention
    sel = find(bool);
    for i=1:length(sel)
      contourx = contour(:,1) - pos(sel(i),1);
      contoury = contour(:,2) - pos(sel(i),2);
      angle = atan2(contoury, contourx);
      % angle = unwrap(angle);
      angle = my_unwrap(angle);
      total = sum(diff(angle));
      bool(sel(i)) = (abs(total)>critval);
    end
end
function x = my_unwrap(x)
    % this is a faster implementation of the MATLAB unwrap function
    % with hopefully the same functionality
    d    = diff(x);
    indx = find(abs(d)>pi);
    for i=indx(:)'
      if d(i)>0
        x((i+1):end) = x((i+1):end) - 2*pi;
      else
        x((i+1):end) = x((i+1):end) + 2*pi;
      end
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTION
% griddata
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [xi,yi,zi] = griddata(x,y,z,xi,yi,method,options)
    %GRIDDATA Data gridding and surface fitting.
    %
    %   GRIDDATA is not recommended. Use TriScatteredInterp instead.
    %
    %   ZI = GRIDDATA(X,Y,Z,XI,YI) fits a surface of the form Z = F(X,Y) to the
    %   data in the (usually) nonuniformly-spaced vectors (X,Y,Z). GRIDDATA
    %   interpolates this surface at the points specified by (XI,YI) to produce
    %   ZI.  The surface always goes through the data points. XI and YI are
    %   usually a uniform grid (as produced by MESHGRID) and is where GRIDDATA
    %   gets its name.
    %
    %   XI can be a row vector, in which case it specifies a matrix with
    %   constant columns. Similarly, YI can be a column vector and it specifies
    %   a matrix with constant rows.
    %
    %   [XI,YI,ZI] = GRIDDATA(X,Y,Z,XI,YI) also returns the XI and YI formed
    %   this way (the results of [XI,YI] = MESHGRID(XI,YI)).
    %
    %   [...] = GRIDDATA(X,Y,Z,XI,YI,METHOD) where METHOD is one of
    %       'linear'    - Triangle-based linear interpolation (default)
    %       'cubic'     - Triangle-based cubic interpolation
    %       'nearest'   - Nearest neighbor interpolation
    %       'v4'        - MATLAB 4 griddata method
    %   defines the type of surface fit to the data. The 'cubic' and 'v4'
    %   methods produce smooth surfaces while 'linear' and 'nearest' have
    %   discontinuities in the first and zero-th derivative respectively.  All
    %   the methods except 'v4' are based on a Delaunay triangulation of the
    %   data.
    %   If METHOD is [], then the default 'linear' method will be used.
    %
    %   [...] = GRIDDATA(X,Y,Z,XI,YI,METHOD,OPTIONS) specifies a cell array of 
    %   strings OPTIONS that were previously used by Qhull. Qhull-specific 
    %   OPTIONS are no longer required and are currently ignored. Support for 
    %   these options will be removed in a future release. 
    %
    %   Example:
    %      x = rand(100,1)*4-2; y = rand(100,1)*4-2; z = x.*exp(-x.^2-y.^2);
    %      ti = -2:.25:2; 
    %      [xi,yi] = meshgrid(ti,ti);
    %      zi = griddata(x,y,z,xi,yi);
    %      mesh(xi,yi,zi), hold on, plot3(x,y,z,'o'), hold off
    %
    %   See also TriScatteredInterp, DelaunayTri, GRIDDATAN, DELAUNAY, 
    %   INTERP2, MESHGRID, DELAUNAYN.

    %   Copyright 1984-2009 The MathWorks, Inc. 
    %   $Revision: 5.33.4.13 $  $Date: 2009/11/16 22:27:09 $

    error(nargchk(5,7,nargin,'struct'));

    [msg,x,y,z,xi,yi] = xyzchk(x,y,z,xi,yi);
    if ~isempty(msg), error(msg); end
    if ndims(x) > 2 || ndims(y) > 2 || ndims(xi) > 2 || ndims(yi) > 2
        error('MATLAB:griddata:HigherDimArray',...
              'X,Y and XI,YI cannot be arrays of dimension greater than two.');
    end

    if ( issparse(x) || issparse(y) || issparse(z) || issparse(xi) || issparse(yi) )
        error('MATLAB:griddata:InvalidDataSparse',...
            'Input data cannot be sparse.');
    end

    if ( ~isreal(x) || ~isreal(y) || ~isreal(xi) || ~isreal(yi) )
        error('MATLAB:griddata:InvalidDataComplex',...
            'Input data cannot be complex.');
    end

    if ( nargin < 6 || isempty(method) ),  method = 'linear'; end
    if ~ischar(method), 
      error('MATLAB:griddata:InvalidMethod',...
            'METHOD must be one of ''linear'',''cubic'',''nearest'', or ''v4''.');
    end

    if nargin == 7
        if ~iscellstr(options)
            error('MATLAB:OptsNotStringCell',...
                  'OPTIONS should be cell array of strings.');           
        end
        opt = options;
    else
        opt = [];
    end

    if numel(x) < 3 || numel(y) < 3
      error('MATLAB:griddata:NotEnoughSamplePts',...
            'Not enough unique sample points specified.');
    end


    % Sort x and y so duplicate points can be averaged before passing to delaunay

    %Need x,y and z to be column vectors
    sz = numel(x);
    x = reshape(x,sz,1);
    y = reshape(y,sz,1);
    z = reshape(z,sz,1);
    sxyz = sortrows([x y z],[2 1]);
    x = sxyz(:,1);
    y = sxyz(:,2);
    z = sxyz(:,3);
    myepsx = eps(0.5 * (max(x) - min(x)))^(1/3);
    myepsy = eps(0.5 * (max(y) - min(y)))^(1/3);
    ind = [0; ((abs(diff(y)) < myepsy) & (abs(diff(x)) < myepsx)); 0];

    if sum(ind) > 0
      warning('MATLAB:griddata:DuplicateDataPoints',['Duplicate x-y data points ' ...
                'detected: using average of the z values.']);
      fs = find(ind(1:end-1) == 0 & ind(2:end) == 1);
      fe = find(ind(1:end-1) == 1 & ind(2:end) == 0);
      for i = 1 : length(fs)
        % averaging z values
        z(fe(i)) = mean(z(fs(i):fe(i)));
      end
      x = x(~ind(2:end));
      y = y(~ind(2:end));
      z = z(~ind(2:end));
    end

    if numel(x) < 3
      error('MATLAB:griddata:NotEnoughSamplePts',...
            'Not enough unique sample points specified.');
    end

    if ~isempty(opt)
        warning('MATLAB:griddata:DeprecatedOptions',...
                ['GRIDDATA will not support Qhull-specific options in a future release.\n',...
                 'Please remove these options when calling GRIDDATA.']);
    end

    switch lower(method),
      case 'linear'
        zi = linear(x,y,z,xi,yi);
      case 'cubic'
        zi = cubic(x,y,z,xi,yi);
      case 'nearest'
        zi = nearest(x,y,z,xi,yi);
      case {'invdist','v4'}
        zi = gdatav4(x,y,z,xi,yi);
      otherwise
        error('MATLAB:griddata:UnknownMethod', 'Unknown method.');
    end

    if nargout<=1, xi = zi; end
end
function zi = linear(x,y,z,xi,yi)
    %LINEAR Triangle-based linear interpolation

    %   Reference: David F. Watson, "Contouring: A guide
    %   to the analysis and display of spacial data", Pergamon, 1994.


    siz = size(xi);
    xi = xi(:); yi = yi(:); % Treat these as columns
    x = x(:); y = y(:); z = z(:);

    dt = DelaunayTri(x,y);
    scopedWarnOff = warning('off', 'MATLAB:TriRep:EmptyTri2DWarnId');
    restoreWarnOff = onCleanup(@()warning(scopedWarnOff));
    dtt = dt.Triangulation;
    if isempty(dtt)
      error('MATLAB:griddata:EmptyTriangulation','Error computing Delaunay triangulation. The sample datapoints may be collinear.');
    end


    if(isreal(z))
        F = TriScatteredInterp(dt,z);
        zi = F(xi,yi);
    else
        zre = real(z);
        zim = imag(z);
        F = TriScatteredInterp(dt,zre);
        zire = F(xi,yi);
        F.V = zim;
        ziim = F(xi,yi);
        zi = complex(zire,ziim);
    end
    zi = reshape(zi,siz);
end
function zi = cubic(x,y,z,xi,yi)
    %TRIANGLE Triangle-based cubic interpolation

    %   Reference: T. Y. Yang, "Finite Element Structural Analysis",
    %   Prentice Hall, 1986.  pp. 446-449.
    %
    %   Reference: David F. Watson, "Contouring: A guide
    %   to the analysis and display of spacial data", Pergamon, 1994.

    % Triangularize the data

    dt = DelaunayTri([x(:) y(:)]);
    scopedWarnOff = warning('off', 'MATLAB:TriRep:EmptyTri2DWarnId');
    restoreWarnOff = onCleanup(@()warning(scopedWarnOff));
    tri = dt.Triangulation;
    if isempty(tri), 
      error('MATLAB:griddata:EmptyTriangulation','Error computing Delaunay triangulation. The sample datapoints may be collinear.');
    end

    % Find the enclosing triangle (t)
    siz = size(xi);
    t = dt.pointLocation(xi(:),yi(:));
    t = reshape(t,siz);

    if(isreal(z))
        zi = cubicmx(x,y,z,xi,yi,tri,t);
    else
        zre = real(z);
        zim = imag(z); 
        zire = cubicmx(x,y,zre,xi,yi,tri,t);
        ziim = cubicmx(x,y,zim,xi,yi,tri,t);
        zi = complex(zire,ziim);
    end
end
function zi = nearest(x,y,z,xi,yi)
    %NEAREST Triangle-based nearest neightbor interpolation

    %   Reference: David F. Watson, "Contouring: A guide
    %   to the analysis and display of spacial data", Pergamon, 1994.

    siz = size(xi);
    xi = xi(:); yi = yi(:); % Treat these a columns
    dt = DelaunayTri(x,y);
    scopedWarnOff = warning('off', 'MATLAB:TriRep:EmptyTri2DWarnId');
    restoreWarnOff = onCleanup(@()warning(scopedWarnOff));
    dtt = dt.Triangulation;
    if isempty(dtt)
      error('MATLAB:griddata:EmptyTriangulation','Error computing Delaunay triangulation. The sample datapoints may be collinear.');
    end

    k = dt.nearestNeighbor(xi,yi);
    zi = k;
    d = find(isfinite(k));
    zi(d) = z(k(d));
    zi = reshape(zi,siz);
end
function [xi,yi,zi] = gdatav4(x,y,z,xi,yi)
    %GDATAV4 MATLAB 4 GRIDDATA interpolation

    %   Reference:  David T. Sandwell, Biharmonic spline
    %   interpolation of GEOS-3 and SEASAT altimeter
    %   data, Geophysical Research Letters, 2, 139-142,
    %   1987.  Describes interpolation using value or
    %   gradient of value in any dimension.

    xy = x(:) + y(:)*sqrt(-1);

    % Determine distances between points
    d = xy(:,ones(1,length(xy)));
    d = abs(d - d.');
    n = size(d,1);
    % Replace zeros along diagonal with ones (so these don't show up in the
    % find below or in the Green's function calculation).
    d(1:n+1:numel(d)) = ones(1,n);

    non = find(d == 0, 1);
    if ~isempty(non),
      % If we've made it to here, then some points aren't distinct.  Remove
      % the non-distinct points by averaging.
      [r,c] = find(d == 0);
      k = find(r < c);
      r = r(k); c = c(k); % Extract unique (row,col) pairs
      v = (z(r) + z(c))/2; % Average non-distinct pairs

      rep = find(diff(c)==0);
      if ~isempty(rep), % More than two points need to be averaged.
        runs = find(diff(diff(c)==0)==1)+1;
        for i=1:length(runs),
          k = (c==c(runs(i))); % All the points in a run
          v(runs(i)) = mean(z([r(k);c(runs(i))])); % Average (again)
        end
      end
      z(r) = v;
      if ~isempty(rep),
        z(r(runs)) = v(runs); % Make sure average is in the dataset
      end

      % Now remove the extra points.
      z(c) = [];
      xy(c,:) = [];
      xy(:,c) = [];
      d(c,:) = [];
      d(:,c) = [];

      % Determine the non distinct points
      ndp = sort([r;c]);
      ndp(ndp(1:length(ndp)-1)==ndp(2:length(ndp))) = [];

      warning('MATLAB:griddata:NonDistinctPoints',['Averaged %d non-distinct ' ...
                'points.\n         Indices are: %s.'],length(ndp),num2str(ndp'))
    end

    % Determine weights for interpolation
    g = (d.^2) .* (log(d)-1);   % Green's function.
    % Fixup value of Green's function along diagonal
    g(1:size(d,1)+1:numel(d)) = zeros(size(d,1),1);
    weights = g \ z(:);

    [m,n] = size(xi);
    zi = zeros(size(xi));
    jay = sqrt(-1);
    xy = xy.';

    % Evaluate at requested points (xi,yi).  Loop to save memory.
    for i=1:m
      for j=1:n
        d = abs(xi(i,j)+jay*yi(i,j) - xy);
        mask = find(d == 0);
        if ~isempty(mask), d(mask) = ones(length(mask),1); end
        g = (d.^2) .* (log(d)-1);   % Green's function.
        % Value of Green's function at zero
        if ~isempty(mask), g(mask) = zeros(length(mask),1); end
        zi(i,j) = g * weights;
      end
    end

    if nargout<=1,
      xi = zi;
    end

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTION
% countour / countourf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [cout, hand] = contour(varargin)
    %CONTOUR Contour plot.
    %   CONTOUR(Z) is a contour plot of matrix Z treating the values in Z
    %   as heights above a plane.  A contour plot are the level curves
    %   of Z for some values V.  The values V are chosen automatically.
    %   CONTOUR(X,Y,Z) X and Y specify the (x,y) coordinates of the
    %   surface as for SURF. The X and Y data will be transposed or sorted
    %   to bring it to MESHGRID form depending on the span of the first
    %   row and column of X (to orient the data) and the order of the
    %   first row of X and the first column of Y (to sorted the data). The
    %   X and Y data must be consistently sorted in that if the first
    %   element of a column of X is larger than the first element of
    %   another column that all elements in the first column are larger
    %   than the corresponding elements of the second. Similarly Y must be
    %   consistently sorted along rows.
    %   CONTOUR(Z,N) and CONTOUR(X,Y,Z,N) draw N contour lines,
    %   overriding the automatic value.
    %   CONTOUR(Z,V) and CONTOUR(X,Y,Z,V) draw LENGTH(V) contour lines
    %   at the values specified in vector V.  Use CONTOUR(Z,[v v]) or
    %   CONTOUR(X,Y,Z,[v v]) to compute a single contour at the level v.
    %   CONTOUR(AX,...) plots into AX instead of GCA.
    %   [C,H] = CONTOUR(...) returns contour matrix C as described in
    %   CONTOURC and a handle H to a contourgroup object.  This handle can
    %   be used as input to CLABEL.
    %
    %   The contours are normally colored based on the current colormap
    %   and are drawn as PATCH objects. You can override this behavior
    %   with the syntax CONTOUR(...,LINESPEC) to draw the contours
    %   with the color and linetype specified. See the help for PLOT
    %   for more information about LINESPEC values.
    %
    %   The above inputs to CONTOUR can be followed by property/value
    %   pairs to specify additional properties of the contour object.
    %
    %   Uses code by R. Pawlowicz to handle parametric surfaces and
    %   inline contour labels.
    %
    %   Example:
    %      [c,h] = contour(peaks); clabel(c,h), colorbar
    %
    %   See also CONTOUR3, CONTOURF, CLABEL, COLORBAR, MESHGRID.
    
    %   Additional details:
    %
    %   CONTOUR uses CONTOUR3 to do most of the contouring.  Unless
    %   a linestyle is specified, CONTOUR will draw PATCH objects
    %   with edge color taken from the current colormap.  When a linestyle
    %   is specified, LINE objects are drawn.
    %
    %   Thanks to R. Pawlowicz (IOS) rich@ios.bc.ca for 'contours.m' and
    %   'clabel.m/inline_labels' so that contour now works with parametric
    %   surfaces and inline contour labels.
    
    %   Copyright 1984-2009 The MathWorks, Inc.
    %   $Revision: 5.18.4.20 $  $Date: 2009/03/30 23:41:27 $
    
    % First we check whether Handle Graphics uses MATLAB classes
    isHGUsingMATLABClasses = feature('HGUsingMATLABClasses');
    
    % Next we check whether to use the V6 Plot API
    [v6,args] = usev6plotapi(varargin{:},'-mfilename',mfilename);
    
    if isHGUsingMATLABClasses
        [c,h] = contourHGUsingMATLABClasses(args{:});
    else
        if v6
            [c,h] = Lcontourv6(args{:});
        else
            % Parse possible Axes input
            error(nargchk(1,inf,nargin,'struct'));
            [cax,args] = axescheck(args{:});
            [pvpairs,args,msg] = parseargs(args);
            if ~isempty(msg), error(msg); end
            
            if isempty(cax) || ishghandle(cax,'axes')
                cax = newplot(cax);
                parax = cax;
                hold_state = ishold(cax);
            else
                parax = cax;
                cax = ancestor(cax,'axes');
                hold_state = true;
            end
            
            h = specgraph.contourgroup('Parent',parax,pvpairs{:});
            set(h,'RefreshMode','auto');
            c = get(h,'ContourMatrix');
            
            if ~hold_state
                view(cax,2);
                set(cax,'Box','on','Layer','top');
                grid(cax,'off')
            end
            plotdoneevent(cax,h);
            h = double(h);
        end
    end
    
    if nargout > 0
        cout = c;
        hand = h;
    end
end
function [c,h] = Lcontourv6(varargin)
    % Parse possible Axes input
    error(nargchk(1,6,nargin,'struct'));
    [cax,args] = axescheck(varargin{:});
    
    cax = newplot(cax);
    
    [c,h,msg] = contour3(cax,args{:});
    if ~isempty(msg), error(msg); end
    
    set(h,'ZData',[]);
    
    if ~ishold(cax)
        view(cax,2);
        set(cax,'Box','on');
        grid(cax,'off')
    end
end
function [cout,hand,cf] = contourf(varargin)
    %CONTOURF Filled contour plot.
    %    CONTOURF(...) is the same as CONTOUR(...) except that the areas
    %    between contours are filled with colors according to the Z-value
    %    for each level.  Contour regions with data values at or above a
    %    given level are filled with the color that maps to the interval.
    %
    %    NaN's in the Z-data leave white holes with black borders in the
    %    contour plot.
    %
    %    When you use the CONTOUR(Z,V) syntax to specify a vector of contour
    %    levels (V must increase monotonically), contour regions with
    %    Z-values less than V(1) are not filled (are rendered in white).
    %    To fill such regions with a color, make V(1) less than or equal to
    %    the minimum Z-data value.
    %
    %    C = CONTOURF(...) returns contour matrix C as described in CONTOURC
    %    and used by CLABEL.
    %
    %    [C,H] = CONTOURF(...) also returns a handle H to a CONTOURGROUP object.
    %
    %    Example:
    %       z = peaks;
    %       [c,h] = contourf(z); clabel(c,h), colorbar
    %
    %       z = peaks;
    %       contourf(z, [min(z(:)) -6:8] )
    %
    %    See also CONTOUR, CONTOUR3, CLABEL, COLORBAR.
    
    %   Author: R. Pawlowicz (IOS)  rich@ios.bc.ca   12/14/94
    %   Copyright 1984-2009 The MathWorks, Inc.
    %   $Revision: 1.31.4.20 $  $Date: 2009/10/24 19:18:32 $
    
    % First we check whether Handle Graphics uses MATLAB classes
    isHGUsingMATLABClasses = feature('HGUsingMATLABClasses');
    
    % Next we check whether to use the V6 Plot API
    [v6,args] = usev6plotapi(varargin{:},'-mfilename',mfilename);
    
    if isHGUsingMATLABClasses
        if (nargout == 3)
            warning(['MATLAB:', lower(mfilename), ':EmptyV6OutputArgument'],...
                ['The V6 compatibility output argument from %s',...
                ' has been set to the empty matrix.',...
                '  This will become an error in a future release.'], upper(mfilename));
        end
        [c,h] = contourfHGUsingMATLABClasses(args{:});
        cs = [];
    else
        if v6 || (nargout == 3)
            if (nargout == 3)
                warning(['MATLAB:', lower(mfilename), ':DeprecatedV6OutputArgument'],...
                    ['The V6 compatibility output argument from %s',...
                    ' is deprecated.',...
                    ' This will no longer be supported in a future release.'], upper(mfilename));
            end
            [c,h,cs] = Lcontourfv6(args{:});
        else
            % Parse possible Axes input
            error(nargchk(1,inf,nargin,'struct'));
            [cax,args] = axescheck(args{:});
            [pvpairs,args,msg] = parseargs(args);
            if ~isempty(msg), error(msg); end
            
            if isempty(cax) || ishghandle(cax,'axes')
                cax = newplot(cax);
                parax = cax;
                hold_state = ishold(cax);
            else
                parax = cax;
                cax = ancestor(cax,'axes');
                hold_state = true;
            end
            
            h = specgraph.contourgroup('Parent',parax,'Fill','on',...
                'LineColor',[0 0 0],pvpairs{:});
            set(h,'RefreshMode','auto');
            c = get(h,'ContourMatrix');
            cs = [];
            
            if ~hold_state
                view(cax,2);
                set(cax,'Box','on','Layer','top');
                grid(cax,'off')
            end
            plotdoneevent(cax,h);
            h = double(h);
        end
    end
    
    if nargout > 0
        cout = c;
        hand = h;
        cf = cs;
    end
end
function [c,h,CS] = Lcontourfv6(varargin)
    % Parse possible Axes input
    error(nargchk(1,6,nargin,'struct'));
    [cax,args,nargs] = axescheck(varargin{:});
    
    % Create the plot
    cax = newplot(cax);
    
    % Check for empty arguments.
    for i = 1:nargs
        if isempty(args{i})
            error('MATLAB:contourf:EmptyInput','Input argument is empty');
        end
    end
    
    % Trim off the last arg if it's a string (line_spec).
    nin = nargs;
    if ischar(args{end})
        [lin,col,mark,msg] = colstyle(args{end});
        if ~isempty(msg), error(msg); end
        nin = nin - 1;
    else
        lin = '';
        col = '';
    end
    
    if (nin == 4),
        [x,y,z,nv] = deal(args{1:4});
        if (size(y,1)==1), y=y'; end;
        if (size(x,2)==1), x=x'; end;
        [mz,nz] = size(z);
    elseif (nin == 3),
        [x,y,z] = deal(args{1:3});
        nv = [];
        if (size(y,1)==1), y=y'; end;
        if (size(x,2)==1), x=x'; end;
        [mz,nz] = size(z);
    elseif (nin == 2),
        [z,nv] = deal(args{1:2});
        [mz,nz] = size(z);
        x = 1:nz;
        y = (1:mz)';
    elseif (nin == 1),
        z = args{1};
        [mz,nz] = size(z);
        x = 1:nz;
        y = (1:mz)';
        nv = [];
    end
    
    if nin <= 2,
        [mc,nc] = size(args{1});
        lims = [1 nc 1 mc];
    else
        lims = [min(args{1}(:)),max(args{1}(:)), ...
            min(args{2}(:)),max(args{2}(:))];
    end
    
    i = find(isfinite(z));
    minz = min(z(i));
    maxz = max(z(i));
    if ~any(i)
        error('MATLAB:contourf:NonFiniteData','Contour not rendered for non-finite ZData');
    elseif isempty(z) || (maxz == minz)
        error('MATLAB:contourf:ConstantData','Contour not rendered for constant ZData');
    end
    
    % Generate default contour levels if they aren't specified
    if length(nv) <= 1
        if isempty(nv)
            CS=contourc([minz maxz ; minz maxz]);
        else
            CS=contourc([minz maxz ; minz maxz],nv);
        end
        
        % Find the levels
        ii = 1;
        nv = minz; % Include minz so that the contours are totally filled
        while (ii < size(CS,2)),
            nv=[nv CS(1,ii)];
            ii = ii + CS(2,ii) + 1;
        end
    end
    
    % Don't fill contours below the lowest level specified in nv.
    % To fill all contours, specify a value of nv lower than the
    % minimum of the surface.
    draw_min=0;
    if any(nv <= minz),
        draw_min=1;
    end
    
    % Get the unique levels
    nv = sort([minz nv(:)']);
    zi = [1, find(diff(nv))+1];
    nv = nv(zi);
    
    % Surround the matrix by a very low region to get closed contours, and
    % replace any NaN with low numbers as well.
    
    zz=[ repmat(NaN,1,nz+2) ; repmat(NaN,mz,1) z repmat(NaN,mz,1) ; repmat(NaN,1,nz+2)];
    kk=find(isnan(zz(:)));
    zz(kk)=minz-1e4*(maxz-minz)+zeros(size(kk));
    
    xx = [2*x(:,1)-x(:,2), x, 2*x(:,nz)-x(:,nz-1)];
    yy = [2*y(1,:)-y(2,:); y; 2*y(mz,:)-y(mz-1,:)];
    if (min(size(yy))==1),
        [CS,msg]=contours(xx,yy,zz,nv);
    else
        [CS,msg]=contours(xx([ 1 1:mz mz],:),yy(:,[1 1:nz nz]),zz,nv);
    end;
    if ~isempty(msg), error(msg); end
    
    % Find the indices of the curves in the c matrix, and get the
    % area of closed curves in order to draw patches correctly.
    ii = 1;
    ncurves = 0;
    I = [];
    Area=[];
    while (ii < size(CS,2)),
        nl=CS(2,ii);
        ncurves = ncurves + 1;
        I(ncurves) = ii;
        xp=CS(1,ii+(1:nl));  % First patch
        yp=CS(2,ii+(1:nl));
        Area(ncurves)=sum( diff(xp).*(yp(1:nl-1)+yp(2:nl))/2 );
        ii = ii + nl + 1;
    end
    
    if ~ishold(cax),
        view(cax,2);
        set(cax,'box','on');
        set(cax,'xlim',lims(1:2),'ylim',lims(3:4))
    end
    
    % Plot patches in order of decreasing size. This makes sure that
    % all the levels get drawn, not matter if we are going up a hill or
    % down into a hole. When going down we shift levels though, you can
    % tell whether we are going up or down by checking the sign of the
    % area (since curves are oriented so that the high side is always
    % the same side). Lowest curve is largest and encloses higher data
    % always.
    
    fig = ancestor(cax,'figure');
    H=[];
    [FA,IA]=sort(-abs(Area));
    if ~ischar(get(cax,'color'))
        bg = get(cax,'color');
    else
        bg = get(fig,'color');
    end
    if isempty(col)
        edgec = get(fig,'DefaultSurfaceEdgeColor');
    else
        edgec = col;
    end
    if isempty(lin)
        edgestyle = get(fig,'DefaultPatchLineStyle');
    else
        edgestyle = lin;
    end
    
    % Tolerance for edge comparison
    xtol = 0.1*(lims(2)-lims(1))/size(z,2);
    ytol = 0.1*(lims(4)-lims(3))/size(z,1);
    
    if nargout>0
        cout = [];
    end
    for jj=IA,
        nl=CS(2,I(jj));
        lev=CS(1,I(jj));
        if (lev ~= minz || draw_min ),
            xp=CS(1,I(jj)+(1:nl));
            yp=CS(2,I(jj)+(1:nl));
            clev = lev;           % color for filled region above this level
            if (sign(Area(jj)) ~=sign(Area(IA(1))) ),
                kk=find(nv==lev);
                kk0 = 1 + sum(nv<=minz) * (~draw_min);
                if (kk > kk0)
                    clev=nv(kk-1);    % in valley, use color for lower level
                elseif (kk == kk0)
                    clev=NaN;
                else
                    clev=NaN;         % missing data section
                    lev=NaN;
                end
            end
            
            if (isfinite(clev)),
                H=[H;patch(xp,yp,clev,'facecolor','flat','edgecolor',edgec, ...
                    'linestyle',edgestyle,'userdata',lev,'parent',cax)];
            else
                H=[H;patch(xp,yp,clev,'facecolor',bg,'edgecolor',edgec, ...
                    'linestyle',edgestyle,'userdata',CS(1,I(jj)),'parent',cax)];
            end
            
            if nargout>0
                % Ignore contours that lie along a boundary
                
                % Get +1 along lower boundary, -1 along upper, 0 in middle
                tx = (abs(xp - lims(1)) < xtol ) - (abs(xp - lims(2)) < xtol);
                ty = (abs(yp - lims(3)) < ytol ) - (abs(yp - lims(4)) < ytol);
                
                % Locate points with a boundary contour segment leading up to them
                bcf = find((tx & [0 ~diff(tx)]) | (ty & [0 ~diff(ty)]));
                
                if (~isempty(bcf))
                    % Get a logical vector that has 0 inserted before each such location
                    wuns = true(1,length(xp) + length(bcf));
                    wuns(bcf + (0:(length(bcf)-1))) = 0;
                    
                    % Create new arrays so that NaN breaks each boundary contour segment
                    xp1 = NaN * wuns;
                    yp1 = xp1;
                    xp1(wuns) = xp;
                    yp1(wuns) = yp;
                    
                    % Remove unnecessary elements
                    if (length(xp1) > 2)
                        % Blank out segments consisting of a single point
                        tx = ([1 isnan(xp1(1:end-1))] & [isnan(xp1(2:end)) 1]);
                        xp1(tx) = NaN;
                        
                        % Remove consecutive NaNs or NaNs on either end
                        tx = isnan(xp1) & [isnan(xp1(2:end)) 1];
                        xp1(tx) = [];
                        yp1(tx) = [];
                        if (length(xp1)>2 && isnan(xp1(1)))
                            xp1 = xp1(2:end);
                            yp1 = yp1(2:end);
                        end
                        
                        % No empty contours allowed
                        if isempty(xp1)
                            xp1 = NaN;
                            yp1 = NaN;
                        end
                    end
                    
                    % Update the contour segments and their length
                    xp = xp1;
                    yp = yp1;
                    nl = length(xp);
                end
                
                cout = [cout,[lev xp;nl yp]];
            end
        end
    end
    
    numPatches = length(H);
    if numPatches>1
        for i=1:numPatches
            set(H(i), 'faceoffsetfactor', 0, 'faceoffsetbias', (1e-3)+(numPatches-i)/(numPatches-1)/30);
        end
    end
    
    c = cout;
    h = H;
end
function [pvpairs,args,msg] = parseargs(args)
    msg = '';
    % separate pv-pairs from opening arguments
    [args,pvpairs] = parseparams(args);
    
    % check for special string arguments trailing data arguments
    if ~isempty(pvpairs)
        [l,c,m,tmsg]=colstyle(pvpairs{1});
        if isempty(tmsg)
            args = {args{:},pvpairs{1}};
            pvpairs = pvpairs(2:end);
        end
        msg = checkpvpairs(pvpairs);
    end
    
    nargs = length(args);
    x = [];
    y = [];
    z = [];
    if ischar(args{end})
        [l,c,m,tmsg] = colstyle(args{end});
        if ~isempty(tmsg),
            msg = sprintf('Unknown option "%s".',args{end});
        end
        if ~isempty(c)
            pvpairs = {'LineColor',c,pvpairs{:}};
        end
        if ~isempty(l)
            pvpairs = {'LineStyle',l,pvpairs{:}};
        end
        nargs = nargs - 1;
    end
    if (nargs == 2) || (nargs == 4)
        if (nargs == 2)
            z = datachk(args{1});
            pvpairs = {'ZData',z,pvpairs{:}};
        else
            x = datachk(args{1});
            y = datachk(args{2});
            z = datachk(args{3});
            pvpairs = {'XData',x,'YData',y,'ZData',z,pvpairs{:}};
        end
        if (length(args{nargs}) == 1) && (fix(args{nargs}) == args{nargs})
            % N
            zmin = min(real(double(z(:))));
            zmax = max(real(double(z(:))));
            if args{nargs} == 1
                pvpairs = {'LevelList',(zmin+zmax)/2, pvpairs{:}};
            else
                levs = linspace(zmin,zmax,args{nargs}+2);
                pvpairs = {'LevelList',levs(2:end-1),pvpairs{:}};
            end
        else
            % levels
            pvpairs = {'LevelList',unique(args{nargs}),pvpairs{:}};
        end
    elseif (nargs == 1)
        z = datachk(args{1});
        pvpairs = {'ZData',z,pvpairs{:}};
    elseif (nargs == 3)
        x = datachk(args{1});
        y = datachk(args{2});
        z = datachk(args{3});
        pvpairs = {'XData',x,'YData',y,'ZData',z,pvpairs{:}};
    end
    % Make sure that the data is consistent if x and y are specified.
    if ~isempty(x)
        msg = xyzcheck(x,y,z);
    end
    if ~isempty(z) && isempty(msg)
        k = find(isfinite(z));
        zmax = max(z(k));
        zmin = min(z(k));
        if ~any(k)
            warning('MATLAB:contour:NonFiniteData','Contour not rendered for non-finite ZData');
        elseif isempty(z) || (zmax == zmin)
            warning('MATLAB:contour:ConstantData','Contour not rendered for constant ZData');
        end
    end
    args = [];
end
function [regargs, proppairs]=parseparams(args)
%PARSEPARAMS Finds first string argument.
%   [REG, PROP]=PARSEPARAMS(ARGS) takes cell array ARGS and
%   separates it into two argument sets:
%      REG being all arguments up to, but excluding, the
%   first string argument encountered in ARGS.
%      PROP contains all other arguments after, and including,
%   the first string argument encountered.
%
%   PARSEPARAMS is intended to isolate possible property
%   value pairs in functions using VARARGIN as the input
%   argument.

%   Chris Portal 2-17-98
%   Copyright 1984-2002 The MathWorks, Inc. 
%   $Revision: 1.6 $  $Date: 2002/04/10 17:07:59 $

    charsrch=[];

    for i=1:length(args),
       charsrch=[charsrch ischar(args{i})];
    end

    charindx=find(charsrch);

    if isempty(charindx),
       regargs=args;
       proppairs=args(1:0);
    else
       regargs=args(1:charindx(1)-1);
       proppairs=args(charindx(1):end);
    end

end
function msg = checkpvpairs(pvpairs,linestyle)
%CHECKPVPAIRS Check length of property value pair inputs
%   MSG = CHECKPVPAIRS(PAIRS) returns an error message if the
%   length of the supplied cell array of property value pairs is
%   incorrect. The message is tailored to accepting LINESPEC as an
%   option convenience input argument.

%   Copyright 1984-2004 The MathWorks, Inc.

    msg = '';
    npvpairs = length(pvpairs)/2;
    if nargin == 1, linestyle = true; end
    if (length(pvpairs) == 1) && linestyle
      msg = struct('message','Error in color/linetype argument.',...
                   'identifier',id('UnrecognizedLineStyleParameter'));
    elseif npvpairs ~= fix(npvpairs)
      msg = struct('message','Incorrect number of inputs for property-value pairs.',...
                   'identifier',id('EvenPropValuePairs'));
    end
end
function str = id(str)
    str = ['MATLAB:checkpvpairs:' str];
end
function y = datachk(x)
%DATACHK Convert input to full, double data for plotting
%  Y=DATACHK(X) creates a full, double array from X and returns it in Y.
%  If X is a cell array each element is converted elementwise.

%   Copyright 1984-2005 The MathWorks, Inc. 

    if iscell(x)
        y = cellfun(@datachk,x,'UniformOutput',false);
    else
        y = full(double(x));
    end
end
function [msg,nx,ny] = xyzcheck(x,y,z,zname)
%XYZCHECK  Check arguments to 2.5D data routines.
%   [MSG,X,Y] = XYZCHECK(X,Y,Z) checks the input arguments
%   and returns either an error message structure in MSG or 
%   valid X,Y. The ERROR function describes the format and 
%   use of the error structure.
%
%   See also ERROR

%   Copyright 1984-2006 The MathWorks, Inc. 
%   $Revision: 1.6.4.3 $  $Date: 2009/11/13 04:37:56 $

    msg = struct([]);
    nx = x;
    ny = y;

    sz = size(z);

    if nargin < 4
        zname = 'Z';
    end

    if ndims(z)~=2
      msg = makemsg('ZNot2D',sprintf('%s must be a 2D array.',zname));
      return
    end
    if min(sz)<2
      msg = makemsg('ZPlanar',sprintf('%s must be size 2x2 or greater.',zname)); 
      return
    end

    nonempty = ~[isempty(x) isempty(y)];
    if any(nonempty) && ~all(nonempty)
      msg = makemsg('XYMixedEmpty','X,Y must both be empty or both non-empty.');
      return;
    end

    if ~isempty(nx) && ~isequal(size(nx), sz)
      nx = nx(:);
      if length(nx)~=sz(2)
        msg = makemsg('XZSizeMismatch',sprintf('The size of X must match the size of %s or the number of columns of %s.',zname,zname));
        return
      else
        nx = repmat(nx',[sz(1) 1]);
      end
    end

    if ~isempty(ny) && ~isequal(size(ny), sz)
      ny = ny(:);
      if length(ny)~=sz(1)
        msg = makemsg('YZSizeMismatch',sprintf('The size of Y must match the size of %s or the number of rows of %s.',zname,zname));
        return
      else
        ny = repmat(ny,[1 sz(2)]);
      end
    end
end
function msg = makemsg(id,str)
    msg.identifier = ['MATLAB:xyzcheck:' id];
    msg.message = str;
end