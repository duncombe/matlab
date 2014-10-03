function [x,y,z] = knots(n,rat,w,h,np)
% KNOTS Plotting periodic "knots" surface.
%	[X,Y,Z] = KNOTS(N) Calculates coordinates of 
%	periodic "knot" surface of the order N
%	(default is 3).
%	[X,Y,Z] = KNOTS(N,RAT,W,H,NP) also specifies
%	ratio RAT of minimal to maximal radius in a
%	horizontal plane, tube radius (half-thickness) W,
%	maximum "height" H and number of points NP along
%	each leg.
%
%	See also TUBES, TORUS, ELLIPSD.

%  Copyright (c) 1995 by Kirill K. Pankratov
%       kirill@plume.mit.edu
%       05/17/95

 % Defaults and parameters ..............
n_dflt = 3;
rat_dflt = 1/3;
w_dflt = .1;
h_dflt = .5;
np_dflt = 80;

 % Handle input .........................
if nargin < 1, n = n_dflt; end
if nargin < 5, np = np_dflt; end
if nargin < 4, h = h_dflt; end
if nargin < 3, w = w_dflt; end
if nargin < 2, rat = rat_dflt; end
if nargin < 1, n = n_dflt; end

if n==[],     n = n_dflt;   end;   n = n(1);
if rat==[], rat = rat_dflt; end;   rat = rat(1);
if w==[],     w = w_dflt;   end;   w = w(1);
if h==[],     h = h_dflt;   end;   h = h(1);
if np==[],    np = np_dflt; end;   np = np(1);


 % Calculate elementary leg of axis .....
cc = 2*(1-1/n);
th = linspace(0,pi,np)';
xa = cos(th);
ya = rat*sin(th);
[th,r] = cart2pol(xa,ya);

 % Extend n times (to make it periodic)
th = th*cc;
xa = th;
ya = r;
for jj = 2:n
  xa = [xa; xa(length(xa))+th(2:np)];
  ya = [ya; r(2:np)];
end

[xa,ya] = pol2cart(xa,ya);
th = linspace(0,2*pi*(n-1),length(xa));
cc = 1-1/n;
za = h*sin(th/cc);


 % Calculate surface coordinates in TUBES function
[x,y,z] = tubes(xa,ya,za,w);

 % Plotting .....................................
if nargout<2, x = surface(x,y,z); end

