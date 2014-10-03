function R = randsph(n,d)
% RANDSPH  Random points uniformly distributed on a sphere.
%	R = RANDSPH(N) Generates N points randomly distributed
%	on a unit 3-d sphere with a uniform probability
%	distribution.
%	R = RANDSPH(N,D) Generates N points on D-dimensional sphere.

%  Copyright (c) 1995  by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/08/95

 % Handle input ....................................
if nargin==0, help randsph, return, end
if nargin<2, d = 3; end  %  Default is 3-d sphere

R = randn(d,n);          % Generate n random normal points

rl = sqrt(sum(R.^2));    % Distance to each of n points

R = R./rl(ones(d,1),:);  % Normalize coordinates by distance
                         % to make it lie on a unit sphere

R = R';

