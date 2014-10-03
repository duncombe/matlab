function R = randisph(n,d)
% RANDISPH  Random points uniformly distributed inside a sphere.
%       R = RANDSPH(N) Generates N points randomly distributed
%       inside a unit 2-d circle with a uniform probability
%       distribution.
%       R = RANDSPH(N,D) Generates N points inside a D-dimensional
%	unit sphere.
 
%  Copyright (c) 1995 by Kirill K. Pankratov
%       kirill@plume.mit.edu
%       05/10/95

 % Handle input ....................................
if nargin==0, help randsph, return, end
if nargin<2, d = 2; end  %  Default is 2-d circle

mult = sqrt(d);
R = rand(d,n*mult);  % Generate n random uniform points
R = R*2-1;           % Make it from -1 to 1

rl = sum(R.^2);      % Distance to each of n points

R = R(:,find(rl<1)); % Find points inside a unit sphere
np = size(R,2);

if np < n            % If not enough points, go back
  Rn = randisph(n-np,d);
  R = [R Rn'];
else
  R = R(:,1:n);
end

R = R';

