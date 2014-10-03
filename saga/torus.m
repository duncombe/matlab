function [x,y,z] = torus(ro,ri,n)
% TORUS  Plotting toproidal surface.
%	[X,Y,Z] = TORUS(RO,RI) computes coordinates
%	X, Y, Z of a toroidal surface with "internal"
%	radius RI, "outer" (axis) radius RO>RI.
%
%	See also SPHERE, ELLIPSD, CYLINDER

%  Copyright (c) 1995 by Kirill K. Pankratov
%       kirill@plume.mit.edu
%       05/10/95

 % Defaults and parameters ..........
n_dflt = [30 30];
ro_dflt = 2;    % Axis radius twice the "tube"
ri_dflt = 1;

 % Handle input .....................
if nargin==0, ro = ri_dflt; end
if nargin < 2 ri = ri_dflt; end
if nargin < 3, n = [30 30]; end
if n<0 | n==[], n = n_dflt; end
if length(n)==1, n = [n n]; end

 % Calculate torus coordinates ......
vx = linspace(0,2*pi,n(1));
vy = linspace(0,2*pi,n(2));
[x,y] = meshgrid(vx,vy);
z = sin(y);
t = cos(y)*ri+ro+ri/2;
y = t.*sin(x);
x = t.*cos(x);

 % Plotting .........................
if nargout<3,
  s = surface(x,y,z);
  x = s;
end

