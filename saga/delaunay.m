function [D,Ro] = delaunay(R)
% DELAUNAY Delaunay tesselation of n-dimensional sets.
% 	D = DELAUNAY(R) where R is n_pts by d matrix
%	of coordinates of n_pts d-dimensional points
%	computes Delaunay tesselation and returns
%	index matrix D (n_spx by d+1) of
%	d-dimensional simplices (polyhedra of d+1 points).

% ALGORITHM:
%	1. Map data R onto d+1 - dimensional paraboloid
%	2. Compute convex hull of this set in d+1 dimensions
%	3. Remove facets pointing "downward"
%	   You get Delaunay.

%  Copyright (c) 1995 by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/10/95, 09/01/95 (paraboloid)

 % Handle input ........................
if nargin==0, help delaunay, return, end

Ro = R;
[n_pts,d] = size(Ro);
if n_pts<d, Ro = Ro'; [n_pts,d] = size(Ro); end

 % Map to a paraboloid of d+1 dimension ...............
%Ro = mapsph(Ro,-2*pi);  % Sphere ca
sqR = sum((Ro.^2)');
Ro = [Ro sqR'];

 % Compute convex hull ............................
[D,Nrm] = convexh(Ro);

 % Remove "bottom" facets .........................
s = find(Nrm(:,d+1)>=0);
D(s,:) = [];
