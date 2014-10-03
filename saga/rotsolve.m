function [A,b] = rotsolve(R1,R2)
% ROTSOLVE  Solving solid body rotation problem.
%	[A,b] = ROTSOLVE(R1,R2) solves the matrix
%	equation 
%	A*R1 + b(:,[1 1 1]) = R2,
%	where A - 3 by 3 rotation matrix: inv(A)=A',
%	b - 3 by 1 vector (translation), R1 and R2 
%	are 3 by 3 matrices of initial and final 
%	coordinates of 3 points (a,b,c) of a solid body:
%	     |xa1 xb1 xc1|         |xa2 xb2 xc2|
%	R1 = |ya1 yb1 yc1| ,  R2 = |ya2 yb2 yc2| 
%	     |za1 zb1 zc1|         |za2 zb2 zc2|

%  Copyright (c) 1995 by Kirill K. Pankratov
%       kirill@plume.mit.edu
%       01/23/95, 05/22/95

%   Outline of calculations .....................
%   Make a problem separable for A and b:
%   Calculate matrices D1 and D2 of differences 
%   rb-ra, rc-ra and cross product (rb-ra)x(rc-ra)
%   In difference form:
%    A*D1 = D2        ==>    A = D2/D1        [1]
%    A^(-1)*D2 = D1
%   For rotational matrix  A^(-1)=A':
%    (A'*D2)' = D1' or, in another form:
%    D2'*A = D1'      ==>    A = D2'\D1'      [2]
%   Combining two estimates [1] and [2] in a l.s. sense:
%    A = [I; I]\[D2/D1; D2'\D1']
%   Now estimate translation vector  b:
%    b = mean((R2-A*R1)')

 % Handle input ................................
if nargin == 0, help rotsolve, return, end
if nargin == 1
 error( 'Not enough input arguments')
end
is_3by3 = all(size(R1)==[3 3]) & all(size(R2)==[3 3]);
if ~is_3by3
  error('Input arguments R1 and R2 must be 3 by 3 matrices')
end

 % Matrices of differences .....................
 % Initial
D1 = R1(:,[2 3 1])-R1;
D1(:,3) = cross(D1(:,1),D1(:,2));
 % Final
D2 = R2(:,[2 3 1])-R2;
D2(:,3) = cross(D2(:,1),D2(:,2));

 % Combine 2 estimates in a least squares sense
I = eye(3);
A = [I; I]\[D2/D1; D2'\D1'];

 % Now estimate the translation vector
b = R2-A*R1;
b = mean(b')';

