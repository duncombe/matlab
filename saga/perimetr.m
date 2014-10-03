function  p = perimetr(x,y)
% PERIMETER Perimeter (length) of a polygon.
%	P = PERIMETR(X,Y) Returns perimeter (length) 
%	of a polygon (or a sequence of line segments)
%	defined by coordinates X,Y (vectors of equal length).
%	For closed polygons must be X(1) = X(length(X)) and
%	Y(1) = Y(length(Y)).
%	PERIMETR(X+i*Y) is the same as PERIMETR(X,Y).

%  Copyright (c) 1995 by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/25/95


 % Handle input ..........................
if nargin==0, help perimetr, end
if nargin==1
  y = imag(x);
  x = real(x);
end

 % Check sizes ...........................
if any(size(x)~=size(y))
  error('  Arguments x and y must have the same length')
end

 % Calculate length ......................
p = sum(sqrt(diff(x).^2+diff(y).^2));

