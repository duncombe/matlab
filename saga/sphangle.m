function [ang,d] = sphangle(phi1,theta1,phi2,theta2)
% SPHANGLE  Spherical angle and distance between 2 points on
%	a unit sphere.
%	[ANG,D] = SPHANGLE(PHI1,THETA1,PHI2,THETA2)
%	computes spherical angle (great circle) and
%	3-dimensional distance between points ona sphere
%	given by spherical coordinates PHI (longitude) and
%	THETA (latitude), both in degrees.
%	All input variables PHI1,THETA1,PHI2,THETA2 must be 
%	scalars or matrices of the same size.
%	Returns spherical angle ANG in radians, so that the
%	distance along the sphere is  Dsph = R*ANG,
%	where R - radius.
%	D is a 3-dimensional distance between 2 points
%	(for unit radius). It is related to ANG as follows:
%	D = 2*sin(ANG/2).

%  Copyright (c) 1995 by Kirill K. Pankratov
%       kirill@plume.mit.edu
%       08/17/94, 05/18/95

 % Handle input ....................................................
if nargin==0, help sphangle, end
if nargin<4                % Check if all 4 entered
  error('  Not enough input arguments')
end
sz = [size(phi1); size(theta1); size(phi2); size(theta2)];
if any(diff(prod(sz')))
  error(['  Arguments phi1, theta1, phi2, theta2  must have '...
  'the same size'])
end

 % Make input column vectors and angles in radians.
d2r = pi/180;         % Degrees to radians
phi1 = phi1(:)*d2r; theta1 = theta1(:)*d2r;
phi2 = phi2(:)*d2r; theta2 = theta2(:)*d2r;

 % Calculate cartesian coordinates r = (x,y,z)
r1 = [cos(phi1).*cos(theta1) sin(phi1).*cos(theta1) sin(theta1)]';
r2 = [cos(phi2).*cos(theta2) sin(phi2).*cos(theta2) sin(theta2)]';

 % Calculate the 1/2 area of triangle built on the 2 points and the
 % sphere center using cross-product
s = cross(r1,r2);
s = sqrt(sum(s.*s));
sg = sign(dot(r1,r2));   % If angle is <pi/2 or >pi/2

 % Make angle  arcsin(s) for s<pi/2  or pi-arcsin(s) for s>pi/2
ang = pi*(sg<0)+pi/2*(sg==0)+sg.*asin(s); % ANG is arcsin of area

 % Output .....................................................
ang = reshape(ang,sz(1,1),sz(1,2));  % Reshape to original size
d = 2*sin(ang/2);                    % 3-dimensional distance

