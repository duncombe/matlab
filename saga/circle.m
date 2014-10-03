function [x,y] = circle(r,x,y,clr,lw,np)
% CIRCLE  Plotting circle(s). 
%	CIRCLE(R,X,Y) Plots circles with centers specified by
%	vectors X and Y and radii by vector R (if R is a number
%	all circles have the same radii equal to this number).
%	CIRCLE(R,X,Y,CLR,LW,NP) Specifies additional parameters
%	(scalar or vector): colors CLR, linewidths LW and a 
%	number of points in each circle line NP.
%	CIRCLE([RMIN RMAX],...) Specifies minimum and maximum
%	radii (this affects linewidth) which allows to plot 
%	donut-like circles. 
%	L = CIRCLE(...)  Returns handles of circle lines.
%	[X,Y] = CIRCLE(...) Returns coordinates X,Y instead.
%
%	See also ELLIPSE.

%  Copyright (c) 1995 by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/10/95

 % Defaults and parameters ......................
clr_dflt = get(gca,'colororder');
clr_dflt = clr_dflt(1,:);
lw_dflt = .5;
np_dflt = 100;

 % Handle input .................................
if nargin==0, help circle, return, end
if nargin<6,  np = np_dflt; end
if nargin<5,  lw = lw_dflt; end
if nargin<4,  clr = clr_dflt; end
if nargin<3,  y = 0; end
if nargin<2,  x = 0; end

 % Make sure X and Y are of the same size .......
wid = 0;
if size(r,2)==2
  rmax = max(r');
  rmin = min(r');
  wid = (rmax-rmin)';
  r = (rmax+rmin)/2;
end
x = x(:);
y = y(:);
r = r(:);
if length(x)~=length(y)
  error('  X and Y must have the same lengths')
end

 % Expand color and linewidth parameters in vectors if needed
nc = length(x);
onc = ones(nc,1);
if size(r,1)==1,   r   = r(onc,:);   end
if isstr(clr), clr = clr(:); end
if size(clr,1)==1, clr = clr(onc,:); end
if size(lw,1)==1,  lw  = lw(onc,:);  end

 % Generic coordinates ..........................
t = linspace(0,2*pi,np+1);
c = cos(t);
s = sin(t);

 % Plotting circles .............................
l = zeros(nc,1);
for jj = 1:nc
  xc = r(jj)*c+x(jj);
  yc = r(jj)*s+y(jj);
  l(jj) = line(xc,yc);
  set(l(jj),'color',clr(jj,:))
end

 % Calculate width in points ....
alim = get(gca,'xlim');
old_units = get(gca,'units');
set(gca,'units','points');
apos = get(gca,'pos');
wid = wid*apos(3)./diff(alim);
lw = max(lw,wid);

 % Set linewidth ................
for jj=1:nc
  set(l(jj),'linewidth',lw(jj));
end

set(gca,'units',old_units) % Set units back

if nargout==1, x = l; end
if nargout==2, x = xc; y = yc; end

