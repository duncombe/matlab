function  [x,y,z] = ellipsd(smax,nrm,n)
% ELLIPSD  Plotting ellipsoid.
%	ELLIPSD(SA,NRM,N) plots ellipsoid with
%	semiaxes vector SA=[SAX SAY SAZ] and
%	axes orientation given in the matrix NRM.
%	N specifies dimension of coordinate matrices
%	X, Y, Z (all NxN matrices).
%	[x,y,z] = ELLIPSD(...) does not plot the surface
%	but instead returns coordinate matrices X, Y, Z.

%  Copyright (c) 1995 by Kirill K. Pankratov
%       kirill@plume.mit.edu
%       05/16/95

 % Handle input .....................
smax0 = [1 1 1];
if nargin==0, smax = [1 1 1]; end
if nargin < 3, n=20; end
if nargin < 2, nrm = eye(3); end
smax0(1:length(smax)) = smax(:)';


 % Calculate orientation ............
sz = size(nrm);
if all(sz==[3 3])
  R=nrm;
elseif all(sz==[3 1]) | all(sz==[1 3])
  R = z2rot(nrm);
elseif all(sz==[2 1]) | all(sz==[1 2])
  R = rotmat3([nrm 0],'euler');
end

 % Create a sphere ..................
[x,y,z] = sphere(n);
[mm,nn] = size(x);

 % Rotate coordinates ...............
C = [x(:)*smax(1) y(:)*smax(1) z(:)*smax(3)];
C = C*R;
clr = z;

 % Split coordinate matrix into x,y,z
x = C(:,1); y = C(:,2); z = C(:,3);
x = reshape(x,mm,nn);
y = reshape(y,mm,nn);
z = reshape(z,mm,nn);

 % Plotting .........................
if nargout<2,  x = surface(x,y,z,clr); end

