function [xo,yo,ind] = polyxor(x1,y1,x2,y2)
% POLYXOR  Exclusive OR of 2 polygons.
%       [XO,YO] = POLYXOR(X1,Y1,X2,Y2) Calculates polygon(s) P
%	of difference of polygons P1 and P1 with coordinates 
%	X1, Y1 and X2, Y2.
%	The resulting polygon(s) is a set of all points which belong
%	either to P1 or to P2 but not to both: 
%	P = (P1 & ~P2) | (P2 & ~P1).
%	The input polygons must be non-self-intersecting and
%	simply connected.
%
%       If polygons P1, P2 are not intersecting, returns 
%	coordinates of the both polygons separated by NaN.
%	If the result P is not simply connected or consists of several
%	polygons, resulting boundary consists of concatenated 
%	coordinates of these polygons, separated by NaN.

%  Copyright (c) 1995 by Kirill K. Pankratov,
%       kirill@plume.mit.edu.
%       06/25/95  
 
if nargin==0, help polyxor, return, end
 
 % Call POLYBOOL twice with flag=3
[xx,yy,ind] = polybool(x1,y1,x2,y2,3);
xo = [xx; nan]; yo = [yy; nan];

[xx,yy,ind] = polybool(x2,y2,x1,y1,3);
xo = [xo; xx]; yo = [yo; yy];

