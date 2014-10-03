function [c,a] = circmsph0(R)
% CIRCMSPH0  Circumsphere for d-dimensional simplex
%	(Primitive for CIRCUMSPH).
%	[C,A] = CIRCMSPH0(R) Accepts matrix R (d+1 by d)
%	with coordinates of d-dimensional simplex (each
%	row is cordinates of a point).
%	Computes the center C and radius A of 
%	circumsphere (d-dimensional sphere passing
%	through all points of a simplex).

%  Copyright (c) 1995 by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/10/95

d = size(R,2);  % Dimension
od = ones(d,1); % Auxillary unit vector

 % Make 1st point origin of coordinate system
r1 = R(1,:);
R = (R(2:d+1,:)-r1(od,:))';

 % Calculate squared length of each edge
s = sum(R.^2);
R = R./s(od,:);

 % Center relative to 1st point - intersection of d
 % planes normal to all edges with 1st point
c = (R'\od);
c = c'/2;

a = sqrt(c*c'); % Radius

c = r1+c;       % Add reference (1st) point

