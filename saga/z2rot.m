function [R,v] = z2rot(z)
% Z2ROT Direction of Z axiz to rotation matrix
%	R = Z2ROT(Z) where Z is 1 by 3 vector of
%	z axis direction, generates 3 by 3 rotation
%	matrix R which will result in the specified
%	direction of z axis.
%	[R,A] = Z2ROT(Z) Returns also (Euler) 
%	rotation angles vector A=[THETA PSI], so that
%	the matrix R = ROTMAT(A,'euler').

%  Copyright (c) 1995 by Kirill K. Pankratov
%       kirill@plume.mit.edu
%	05/18/95

if nargin==0, help z2rot, return, end
sz = size(z);
if any(sz~=[1 3]) & any(sz~=[3 1])
   error('z must be a 1 by 3 vector')
end

z = z(:);
z = z./sqrt(z'*z);     % Normalize
th = acos(z(3));

z2 = z(1:2);
len = sqrt(z2'*z2);
z2 = z2./(len+(~len)); % Normalize horizontal part
psi = asin(z2(2));

 % Generate rotational matrix and Euler angles vector
v = [th psi 0];
R = rotmat3(v,'euler');

