function  [n,d] = fitplane(x,y,z)
% FITPLANE Fitting of a plane or hyperplane to a set
%	of points.
%	[N,D] = FITPLANE(X,Y,Z) Calculates a least
%	squares fit to the normal N  to a plane through
%	a set of points with coordinates X,Y,Z in the
%	form  N(1)*X+N(2)*Y+N(3)*Z = D.
%	Normally N is normalized so that D = 1 unless
%	it is close to zero (a plane goes near
%	coordinate system origin).
%	[N,D] = FITPLANE(X,Y) calculates a similar fit
%	to a line, while
%	[N,D] = FITPLANE(R) calculates a fit to a
%	hyper-plane. In this case each row of R
%	must correspond to coordinates of a certain
%	point in a set, such as
%	R = [x1 y1 z1 t1; x2 y2 z2 t2; ...].

%  Copyright (c) 1995  by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	02/09/95

tol = .01;  % Tolerance for canonocal form reduction

 % Handle input ............................
if nargin==1      % Arbitrary dimension (hyperplane)
  R = x;
  if diff(size(R)) > 0, R = R'; end

elseif nargin==2  % 2-dimensional (line)
  R = [x(:) y(:)];

else              % 3-dimensional (plane)
  R = [x(:) y(:) z(:)];

end

 % Auxillary
szR = size(R);
o = ones(szR(1),1);

 % Make offset (so that plane will not go through
 % the origin)
r0 = 2*min(R)-max(R)-1;
R = R-r0(o,:);

 % Now the fit itself ......................
n = R\o;
d = 1+r0*n;  % Compensate offset

 % Try to reduce it to the canonical form
 % (Nx*X + Ny*Y + Nz*Z = 1) if possible
if abs(d) > tol
  n = n/d;
  d = 1;
end

