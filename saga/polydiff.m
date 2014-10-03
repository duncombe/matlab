function [xo,yo,ind] = polydiff(x1,y1,x2,y2)
% POLYDIFF  Difference of 2 polygons.
%       [XO,YO] = POLYDIFF(X1,Y1,X2,Y2) Calculates polygon(s) P
%	of difference of polygons P1 and P1 with coordinates 
%	X1, Y1 and X2, Y2.
%	The resulting polygon(s) is a set of all points which belong
%	to P1 but not to to P2: P = P1 & ~P2.
%	The input polygons must be non-self-intersecting and
%	simply connected.
%
%       If polygons P1, P2 are not intersecting, returns 
%	coordinates of the first polygon X1, X2.
%	If the result P is not simply connected or consists of several
%	polygons, resulting boundary consists of concatenated 
%	coordinates of these polygons, separated by NaN.

%  Copyright (c) 1995 by Kirill K. Pankratov,
%       kirill@plume.mit.edu.
%       06/25/95  
 
if nargin==0, help polydiff, return, end
 
 % Call POLYBOOL with flag=3
[xo,yo,ind] = polybool(x1,y1,x2,y2,3);

