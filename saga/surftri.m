function [po,N] = surftri(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10)
% SURFTRI  Triangulated surface "patchwork" plot.
%	SURFTRI(X,Y) Performs (Delaunay) triangulation
%	of a plane set of (irregular) points with 
%	coordinates X, Y and plots triangulation as a 
%	"patchwork", one patch per triangle, in XY plane.
%	SURFTRI(X,Y,Z,C) Plots triangulated surface 
%	with cooresponding hight data Z	and color data C
%	Color can be specified as a vector of the same 
%	size as X or Y or as a direction of "coloring"
%	axis (direction of color change) in the form
%	[NX NY NZ] or [AZ EL]. Default is vertical
%	direction for 3-d plot (color is proportional
%	to height) and so-called "radial mode" for 2-d
%	plot (see SURFTRI INFO for details).
%	[P,N] = SURFTR(...)  Returns handles P of all 
%	patchs in a surface, one patch per triangle and N
%	- matrix of indices of triangles (the output of the
%	triangulation program TRIANGUL).
%
%	  Examples:
%	1. Simple 2-d triangulation plot
%	surftri(rand(100,2));
%
%	2. 3-d triangulated surface
%	n = 300;
%	r = rand(1,n).^(1/2);
%	t = rand(1,n)*2*pi;
%	x = r.*cos(t); y = r.*sin(t);
%	z = exp(-4*(x.^2+y.^2));
%	surftr(x,y,z),  colormap cool
%
%	SURFTRI INFO (or, equivalently, TYPE SURF3INF)
%	shows some additional information about
%	capabilities and usage of SURFTRI program.
%	See also TRIANGUL,  PATCH, SURF.

%  Copyright (c) 1995 by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/10/95, 05/23/95

 % Check if the first parameter is indices .........
isN = all(all(round(a1)==a1));
lim = [min(min(a1)) max(max(a1))];
isN = isN & any(size(a1)==3) & lim(1)>0;

if isN   % If the first argument is a matrix of indices
  N = a1;
  lim = size(N);
  if lim(1)~=3 & lim(2)==3, N = N'; end
end

 % Set up SURFCHK function call ....................
 % Retrieve combined coordinate matrix R, color data c
 % facecolor fc and edgecolor ec
eval_str = '[R,c,fc,ec] = surf3chk(3';
for jj = 1+isN:nargin
  eval_str = [eval_str ',a' num2str(jj)];
end
eval_str = [eval_str ');'];
eval(eval_str);
d = min(3,size(R,1));

 % Make separate coordinate vectors .......
x = R(1,:);
y = R(2,:);
if d>2, z = R(3,:); end


 % If no inices matrix, triangulate .....................
if ~isN, N = triangul(x,y); end

 % Reshape everything into triangles ...... 
ntri = size(N,2);
x = reshape(x(N),3,ntri);
y = reshape(y(N),3,ntri);
if d>2, z = reshape(z(N),3,ntri); end
if size(c,1)==1, c = reshape(c(N),3,ntri); end

 % If "flat" mode, one color datum per triangle .........
if ~strcmp(fc,'interp') & all(size(c)>1), c = mean(c); end

 % Plot one patch per triangle ..........................
%cla
view(d)
if d==2
 p = patch(x,y,c);
else
  p = patch(x,y,z,c);
end

set(p,'facecolor',fc)
set(p,'edgecolor',ec)

if nargout>0, po = p; end

