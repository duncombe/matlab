function e = convex2(x,y)
% CONVEX2  Finds a convex hull of a 2-dimensional set of points.
%	N = CONVEX2(X,Y)  Returns indices of elements of X, Y
%	set constituing convex hull, so that the convex hull 
%	coordinates are X(N), Y(N).
%	CONVEX2(X+Y*i) is the same as CONVEX2(X,Y).

%	CONVEX2 uses a primitive (recursion) routine CONVEX20.

%  Copyright (c) 1995 by Kirill K. Pankratov
%       kirill@plume.mit.edu
%  	04/24/94, 02/22/95, 04/19/95

 % Hande input ..............................................
if nargin==0, help convex2, return, end
if nargin==1, y = imag(x); x = real(x); end  % Complex input

x = x(:);
y = y(:);
l = length(x);
if length(y)~=l
  error('  Vectors x, y must have the same length')
end

[x0,n0] = max(x);    % Find the left point
[x1,n1] = min(x);    % Find the right point

if n0==n1 % If all x are equal, find extremal y
  [x0,n0] = max(y);  % Find the upper point
  [x1,n1] = min(y);  % Find the lower point
end
if n0==n1, e = n0; return, end    % Single point

 % Recursively find all points on the convex hull ..........
e1 = convex20(n0,n1,(1:l)',x,y);  % Upper  half-arc
e2 = convex20(n1,n0,(1:l)',x,y);  % Lower half-arc

e = [e1; e2];  % Combine two half-arcs

