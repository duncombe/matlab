function [xo,yo,ind] = polyuni(x1,y1,x2,y2)
% POLYUNI  Union of 2 polygons.
%       [XO,YO] = POLYINT(X1,Y1,X2,Y2) Calculates polygon(s) P
%       which is (are) union of polygons P1 and P2 with coordinates 
%	X1, Y1 and X2, Y2.
%	The resulting polygon(s) is a set of all points which belong
%	either to P1 or to P2: P = P1 | P2.
%	The input polygons must be non-self-intersecting and
%	simply connected.
%
%       If polygons P1, P2 are not intersecting, returns 
%	coordinates of the both polygons separated by NaN.
%	If both P1 and P2 are convex, their boundaries can have no 
%	more than 2 intersections. The result is also a convex 
%	polygon.
%       If the result P is not simply connected (such as a polygon
%	with a "hole") the resulting contour consist of counter-
%	clockwise "outer boundary" and one or more clock-wise 
%	"inner boundaries" around "holes".
 
%  Copyright (c) 1995 by Kirill K. Pankratov,
%       kirill@plume.mit.edu.
%       06/25/95  
 
if nargin==0, help polyuni, return, end
 
 % Call POLYBOOL with flag=2 ..........
[xo,yo,ind] = polybool(x1,y1,x2,y2,2);

