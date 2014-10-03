function [is,num] = isdln(N,R,tol)
% ISDLN  Find if triangulation/tesselation is a Delaunay one.
%	[IS,NUM] = ISDLN(N,R) accepts tesselation index matrix
%	N (n_spx by d+1) each rows with indices of points constituing
%	an individual simplex and matrix R (n_pts by d) with each
%	row consisting of coordinates of a d-dimensional point.
%	Returns boolean number IS which is 1 if tesselation
%	satisfy criterium for Delaunay one (empty circumsphere
%	of each simplex) and 0 if not. Also returns vector NUM
%	(n_spx by 1) with indices of closest points to the centres
%	of circumspheres of each simplex which does not satisfy
%	this criterium.  

%  Algorithm:  Based on empty circumsphere criterium.
%	The program calculates circumsphere centers and radii for
%	each simplex and checks if there are any other points
%	inside each circumsphere; if there are, triangulation is
%	not a Delaynay one.

%  Copyright (c) 1995 by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/10/95

 % Defaults and parameters
tol_dflt = 1e-9;    % Tolerance

 % Handle input ..................................
if nargin==0, help isdln, return, end
if nargin<3, tol = tol_dflt; end
if nargin<2
  error('  Not enough input arguments')
end

 % Transpose if necessary ........................
[n_pts,d] = size(R);
if n_pts<d, R = R'; d = n_pts; end
[cc,nn] = size(N);
if nn~=d+1 & cc==d+1, N = N'; end

 % Sizes and dimensioning vectors ................
[n_pts,d] = size(R);
n_spx = size(N,1);
od1 = ones(d+1,1);
opts = ones(n_pts,1);
cf = 1-tol;

 % Find circumspheres for each simplex ...........
[c,a] = circmsph(R,N);
a = a;

 % For each simplex check if there are other points
 % inside its circumsphere .......................
num = zeros(n_spx,1);
for jj=1:n_spx
  Rd = (R-c(jj*opts,:))';
  r2 = sqrt(sum(Rd.^2));
  r2(N(jj,:)) = od1*max(r2)+1;
  is_inside  = any(r2<a(jj)*cf);
  if is_inside
    [cc,nn] = min(r2);
    num(jj) = nn;
  end
end

  % Boolean number output: 1 - Delaunay, 0 - not
is = ~any(num);

