function [xo,yo] = planerot(x,y,ang,x0,y0)
% PLANEROT  Planar rotation.
%	PLANEROT(X,Y,ANG,X0,Y0) Calulates new
%	coordinates XO, YO of points X, Y rotated
%	at angle ANG (positive counter-clockwise)
%	about a points with coordinates (X0,Y0) 
%	(default is (0,0)).
%	ANG is measured in radians (use ANG*pi/180
%	if ANG is expressed in degrees).

%  Copyright (c) 1995 by Kirill K. Pankratov,
%       kirill@plume.mit.edu.
%       06/07/95

 % Handle input .........................
if nargin==0, help planerot, return, end
if nargin<3
  error('  Not enough input arguments')
end
if nargin<4, x0 = 0; y0 = 0; end

sz = size(x);
if all(size(y)==fliplr(sz)), y = y'; end
if ~all(size(y)==sz)
  error('X, Y must have the same size')
end

 % Relative to origin ...................
x = x-x0;
y = y-y0;

 % Rotation SIN and COS ................
c = cos(ang);
s = sin(ang);

 % Rotate ..............................
xo = x*c-y*s;
yo = x*s+y*c;

 % Add origin ..........................
xo = xo+x0;
yo = yo+y0;
