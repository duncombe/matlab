function [x,y,z] = mebius(n,wid,rat,np)
% MEBIUS Plotting mebius strip.
%	[X,Y,Z] = MEBIUS(N,W,RAT,NP) calculates
%	coordinates of a "Mebius strip" surface -
%	a torn, twisted and reconnected "belt".
%	N (order) - the number of times it is twisted
%	before reconnecting (default is 1 - classical
%	Mebius strip), W is the width relative to
%	radius, RAT is the ratio of width to thickness
%	NP is a number of points along the tube.
%	S=MEBIUS(...) Plots the surface and returns 
%	surface handle instead of coordinates.
%
%	See also TUBES, TORUS, KNOTS, SURFACE.

%  Copyright (c) 1995 by Kirill K. Pankratov
%       kirill@plume.mit.edu
%       05/18/95


 % Defaults and parameters ................
wid_dflt = .3;  % Strip width (relative to radius)
rat_dflt = 8;   % Ratio of width to thickness
np_dflt = 150;  % Nmb. of points aling the tube


 % Handle input ...........................
if nargin<1, n = 1; end
if nargin<2, wid = wid_dflt; end
if nargin<3, rat = rat_dflt; end
if nargin<4, np = np_dflt; end


 % Create twisted tube
v = linspace(0,2*pi,np);
xa = ones(size(v));
ya = v;
za = zeros(size(v));
[x,y,z] = tubes(xa,ya,za,wid*[1 1/rat],...
           [cos(v*n/2); za; sin(v*n/2)]',30);

 % Bend the tube into a circle ...........
sz = size(x);
o2 = ones(1,sz(2));
c = cos(v'); t = x.*c(:,o2);
c = sin(v'); y = x.*c(:,o2);
x = t;

 % Plot surface ..........................
if nargout<2
  s = surface(x,y,z);
  x = s;
end
