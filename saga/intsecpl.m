function  [xo,yo] = intsecpl(xv,yv,xl,yl,trace)
% INTSECPL Intersection of a polygon and a line.
%	[XI,YI] = INTSECPL(XV,YV,XL,YL) calculates
%	intersections XI, YI of a polygon with vertices XV,
%	YV and a line specified by pairs of end coordinates
%	XL = [XL0 XL1], YL = [YL0 YL1]. Line is assumed to
%	continue beyond the range of end points.
%	INTSECPL(XV,YV,[A B]) uses another specification for
%	a line: Y = A*X+B.
%
%	If a line does not intersect polygon, returns empty
%	XI, YI.
%	For convex polygon maximum number of intersections is
%	2, for non-convex polygons multiple intersections are 
%	possible.
%
%	INTSECPL(XV,YV,XL,YL)  by itself or
%	[XI,YI] = INTSECPL(XV,YV,XL,YL,1) plots polygon,
%	a line segment and intersection segment(s) 
%	(part(s) of the same line inside the polygon).

%  Copyright (c) 1995 by Kirill K. Pankratov,
%       kirill@plume.mit.edu.
%       06/25/95, 08/27/95, 09/27/95

%  Calls ISCROSS, INTSECL programs.


 % Defaults and parameters .................................
tol = 1e-14;  % Tolerance
marg = tol;   % Margins for polygon frame
is_ab = 0;    % Default A*X+B  mode

 % Handle input ............................................
if nargin==0, help intsecpl, return, end
if nargin < 3
  error(' Not enough input arguments')
end
if nargin<5, trace = 0; end
if nargin==4  % Check if 4-th arg is trace
  if max(size(yl))==1, trace = yl;  is_ab = 1; end
end
if nargin==3, is_ab = 1; end
trace = trace | nargin<2;
if length(xv)~=length(yv)
  error(' Vectors X, Y must have the same size')
end

 % Auxillary ...........
xv = [xv(:); xv(1)];
yv = [yv(:); yv(1)];
ii = find(abs(diff(xv))<tol & abs(diff(yv))<tol);
xv(ii) = []; yv(ii) = [];
nv = length(xv);
ov = ones(nv-1,1);


  % Polygon frame
lim = [min(xv)-marg max(xv)+marg min(yv)-marg max(yv)+marg];
 % Estimate for diameter
d = sqrt((lim(2)-lim(1)).^2+(lim(4)-lim(3)).^2);


 % Form line segment depending on how line is specified 
if is_ab       % A*X+B  mode ...................

  xl = xl(:);
  if length(xl)<2
    error(' Line is specified by at least two parameters')
  end

  a = xl(1); b = xl(2);
  xl = [lim(1)-1 lim(2)+1];
  yl = a*xl+b;

else          % [X1 X2],[Y1 Y2]  mode ..........

  x0 = (xl(1)+xl(2))/2;
  y0 = (yl(1)+yl(2))/2;
  dx = xl(2)-x0;
  dy = yl(2)-y0;
  dl = max(abs([lim(1:2)-x0 lim(3:4)-y0]));
  d = max(d,dl);
  dl = sqrt(dx.^2+dy.^2);
  dl = max(d,d/dl);
  dx = dx*dl; dy = dy*dl;
  xl = [x0-dx x0+dx];
  yl = [y0-dy y0+dy];

end


 % Find intersecting segments ..............................
is = iscross([xv(1:nv-1) xv(2:nv)]',[yv(1:nv-1) yv(2:nv)]',...
             xl(ov,:)',yl(ov,:)',0);


 % Quick exit if no intersections .........................
if ~any(is)
  if trace
    % Intersection with polygon frame
    [xl,yl] = intsecpl(lim([1 2 2 1]),lim([3 3 4 4]),xl,yl);
    plot(xv,yv,xl,yl) % Plotting itself
  end
  xo = []; yo = []; 
  return
end


 % For segments touching the line (is==.5) find whether pairs of
 % successive segments are on the same side
ii = find(is==.5)';
if ii~=[]
  xo = [ii-1 ii+1];
  xo = xo+(nv-1)*(xo<1);
  yo = iscross([xv(xo(:,1)) xv(xo(:,2))]',[yv(xo(:,1)) yv(xo(:,2))]',...
       xl,yl,tol);
  ii = ii(find(yo==1));
  is(ii) = zeros(size(ii));
end


 % Calculate intersection coordinates ......................
ii = find(is);
oi = ones(size(ii));
[xo,yo] = intsecl([xv(ii) xv(ii+1)]',[yv(ii) yv(ii+1)]',...
                  xl(oi,:)',yl(oi,:)');

dx = find(~finite(xo));
xo(dx) = []; yo(dx) = [];
ii(dx) = []; oi(dx) = [];


 % Sort intersections along the line ..........
xo = xo(:); yo = yo(:);
if any(diff(xo))
  [xo,ii] = sort(xo);
  yo = yo(ii);

else

  [yo,ii] = sort(yo);
  xo = xo(ii);
end

 % Exclude repeated points (degenerate cases)
 % ///////// It seems that this is not needed, figure this
 % later ///////////////////
if length(ii)>1 & 0  % Do not execute
  xx = [xo yo];
  yy = diff(xx)';
  ii = [1 find(any(abs(yy)>tol))+1];
  xo = xx(ii,1); yo = xx(ii,2);
  oi = ones(size(xo));
end


 % Plotting ................................................
if trace
  oi(3:2:length(oi)) = oi(3:2:length(oi))+1;
  oi = cumsum(oi);
  len = max(oi);
  xp = nan*ones(len,1); yp = xp;
  xp(oi) = xo;
  yp(oi) = yo;

  % Intersection with polygon frame
  [xl,yl] = intsecpl(lim([1 2 2 1]),lim([3 3 4 4]),xl,yl);

  plot(xv,yv,xl,yl,xp,yp) % Plotting itself
end

