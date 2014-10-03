function Ro = inflate(Ri,p)
% INFLATE Changing convexity of a data set.
% 	RO = INFLATE(RI,P) transforms dataset RI
%	(N by D where N - number of points,
%	d - dimension) as follows: each point is 
%	translated along the line drawn from the 
%	center (mean(R)) so that the new distance
%	to the center is d^(1-P).
%	For 0 < P < 1 this means "inflation" set RO
%	is "more convex" than RI, negative P decreases
%	convexity.
%
%	Used in CONVEX and TRIANLUL programs.

%  Copyright (c) 1995 by Kirill K. Pankratov
%       kirill@plume.mit.edu
%       05/18/95, 09/14/95

 % Defaults and parameters ................
p_dflt = .01;  % Power (1-p)

 % Handle input
if nargin==0, help inflate, return, end
if nargin<2, p = p_dflt; end

 % Sizes and dimensions ...................
[n_pts,d] = size(Ri);
opts = ones(n_pts,1);

r0 = mean(Ri);

Ro = (Ri-r0(opts,:))';
rr1 = max(abs(Ro'))';
Ro = Ro./rr1(:,opts);
rr0 = sqrt(sum(Ro.^2));
rmax = max(rr0);

 % Shift ...............
rshft = rr1'.*(rand(1,d) -.5)*p;
Ro = Ro-rshft(opts,:)';

 % Inflation itself
rr1 = rmax*(rr0/rmax).^(1-p);
rr1 = rr1./rr0;
Ro = Ro.*rr1(ones(d,1),:);

 % Shift back
Ro = Ro'+r0(opts,:)+rshft(opts,:);

