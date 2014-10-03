function [Ro,B] = project(Ri,n)
% PROJECT Projection of a set of points on a plane or hyperplane.
%	[RP,B] = PROJECT(R,N)  calculates projection of a set of
%	points in a matrix R on a plane with normal vector N.
%	Each row of R contains coordinates of a point of a set,
%	such as R = [x1 y1 z1; x2 y2 z2; ...].
%	Output matrix RP has the same dimension as R. Its first
%	column contains projections of all points of R into a
%	normal vector N and other columns are coordinates in an
%	orthogonal basis in the (hyper)plane perpendicular to 
%	the normal N.
%	Also returns orthonormal basis B, whose first column is
%	a (normalized) N and the rest are  basis in a 
%	perpendicular (hyper)plane.
%	Ouput matrices RP and B have the following properties:
%	RP*RP' = R*R',  B'*B = I.

%  Copyright (c) 1995  by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	02/09/95

if nargin < 2
  error('  Not enough input arguments')
end

n = n(:);        % Make normal a column vector

dim = length(n); % Dimension

 % Check sizes
szR = size(Ri);
aa = szR==dim;
if ~any(aa)
  error('  Number of columns in matrix R must match length of N')
elseif aa(1) & ~aa(2)
  Ri = Ri';
end

n = n/norm(n);   % Normalize

B = eye(dim);    % Initialize orthogonal basis

 % Find a basis vector with maximum projection on the 
 % normal n (to be excluded)
[aa,nn] = find(max(abs(n)));

stay = ones(size(n));
stay(nn) = 0;    % Mask: stay - 1, exclude - 0

 % Extract projections of all basis vectors on n
B = B-n*n';

B = B(:,stay);  % Exclude basis vector most parallel to n

B = orth(B);    % Orthoganalize the rest

B = [n B];      % Add n to the new orthogonal basis

Ro = Ri*B';     % Coordinate transformation

