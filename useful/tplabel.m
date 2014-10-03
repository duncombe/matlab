function out=tplabel(PASSES)
%
% TPLABEL:            Write the pass number on a groundtrack map, at the point
%                     where the groundtrack intersects with the edge of the
%                     current axes.  TPLABEL is useful to find what
%                     groundtracks cover an area of interest.  To find all 
%                     possible groundtracks in a region, plot the region, and 
%                     then use TPMAP(1:254) and then TPLABEL(1:254).
%
% USAGE:              HANDLES = TPLABEL(PASSES).
%
% 
% WARNING:            TPLABEL has no knowledge of the tic mark locations, and 
%                     so this may get messy.  If the tplabels are too close 
%                     together, try stretching the window, or the region of 
%                     your plot to a slightly smaller one, or label only a 
%                     subset of the mapped groundtracks.
%
% SEE ALSO:           TPMAP

%                     Deirdre Byrne, 17 January 1995


orbitfile = '~/matlab/useful/jason.mat';

if exist(orbitfile) == 2
  eval(['load ' orbitfile])
else
  disp([ 'Unable to find ' orbitfile])
  return
end

wesn = axis; xr = diff(wesn(1:2)); yr = diff(wesn(3:4));
tolx = xr*0.01; toly = yr*0.01;
if nargin == 0
  help tplabel
  return
end

% initialize return argument if one is requested
if nargout == 1;
  out = [];
end

for i = 1:length(PASSES)
  irev = PASSES(i);

  % track coordinates for this pass
  x = reftrack(:,1) + eqxlon(irev);
  
  % put as many longitudes as possible within range of the axes
  if any(x < wesn(1));
    j = find(x < wesn(1));
    x(j) = x(j)+360;
  end
  if any(x > wesn(2));
    j = find(x > wesn(2));
    x(j) = x(j)-360;
  end
  
  % latitude, ascending or descending
  if rem(irev,2) == 0;
    y = flipud(reftrack(:,2));
  else
    y = reftrack(:,2);
  end

  % create the label
  arg = sprintf('%3.3i', irev);
  
  % initialize some variables -- text handle and alongtrack index.
  texthandle = [];
  inx = [];
  
  % find out if track exits top of axis frame within axis limits.
  % if so, label will be at the top 
  inx = find( (y >= (wesn(4) - toly)) & (y <= (wesn(4) + toly)) );
  if ~isempty(inx)
    if any( x(inx) >= wesn(1) & x(inx) <= wesn(2) )
      j = find( (y(inx) - wesn(4)) == min(y(inx) - wesn(4)) );
      texthandle=text(x(inx(j)), y(inx(j)), arg, 'vert', 'bottom', ...
	  'horiz', 'center');
    else
      inx = find( (x >= (wesn(2) - tolx)) & (x <= (wesn(2) + tolx)) );
    end
  else
    inx = find( (x >= (wesn(2) - tolx)) & (x <= (wesn(2) + tolx)) );
  end
  
  % the second choice is to label along the R.H. side of the axis
  if isempty(texthandle) & ~isempty(inx)
    if any( y(inx) >= wesn(3) & y(inx) <= wesn(4) )
      j = find( (x(inx) - wesn(2)) == min(x(inx) - wesn(2)) );
      texthandle=text(x(inx(j)), y(inx(j)), arg, ...
	      'vert', 'middle', 'horiz', 'left');
    else
      inx = find( (x >= (wesn(1) - tolx)) & (x <= (wesn(1) + tolx)) );
    end
  else
    inx = find( (x >= (wesn(1) - tolx)) & (x <= (wesn(1) + tolx)) );
  end
  
  % if track line does not exit top or R.H. side of axis box,
  % try the L.H. side:
  if isempty(texthandle) & ~isempty(inx)
    if any( y(inx) >= wesn(3) & y(inx) <= wesn(4) )
      j = find( (x(inx) - wesn(1)) == min(x(inx) - wesn(1)) );
      texthandle=text(x(inx(j)), y(inx(j)), arg, 'vert', 'middle', ...
		      'horiz', 'right');
    else
      inx = find( (y >= (wesn(3) - toly)) & (y <= (wesn(3) + toly)) );
    end
  else
    inx = find( (y >= (wesn(3) - toly)) & (y <= (wesn(3) + toly)) );
  end
  
  % lastly, try the bottom
  if isempty(texthandle) & ~isempty(inx)
    if any( x(inx) >= wesn(1) & x(inx) <= wesn(2) )
      j = find( (y(inx) - wesn(3)) == max(y(inx) - wesn(3)) );
      texthandle=text(x(inx(j)), y(inx(j)), arg, 'vert', 'top', ...
		      'horiz', 'center');
    end
  end

  if nargout == 1
    if ~isempty(texthandle)
      out = texthandle;
    end
  end

end
return
