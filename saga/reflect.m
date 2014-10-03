function  [xo,yo] = reflect(x,y,ax)
% REFLECT  Planar reflection about an axis.
%	[XO,YO]=REFLECT(X,Y,AX) returns coordinates X0,Y0
%	reflected about an axis AX.
%
%	AX line can be input in one of the following modes:
%	[X0 Y0 X1 Y1]  defines a line with end coordinates
%		(X0,Y0), (X1,Y1).
%	[X0 Y0 ANG]   specifies starting point and
%		direction of the line 
%		(same as [X0 Y0 X0+cos(ANG) Y0+sin(ANG)])
%	[X1 Y1]  assumes beginning at (0,0)
%		(same as [0 0 X1 Y1])
%	ANG     (scalar) specifies direction
%		(same as [0 0 cos(ANG) sin(ANG)]).
%
%	ANG must be expressed in radians (use ANG*pi/180
%       if ANG is expressed in degrees).

%  Copyright (c) 1995 by Kirill K. Pankratov,
%       kirill@plume.mit.edu.
%       06/07/95

if nargin==0, help reflect, return, end
if nargin<3
  error(' Not enough input arguments')
end

sz = size(x);
if all(size(y)==fliplr(sz)), y = y'; end
if ~all(size(y)==sz)
  error('X, Y must have the same size')
end

ax = ax'; ax = ax(:)';
la = length(ax);
if la==3
  ax = [ax(1:2) ax(1)+cos(ax(3)) ax(2)+sin(ax(3))];
elseif la==2
  ax = [0 0 ax];
elseif la==1
  ax = [0 0 cos(ax) sin(ax)];
end

nrm = ax([3 4])-ax([1 2]);
len = sqrt(nrm*nrm');
nrm = nrm/len;

x = x-ax(1);
y = y-ax(2);
p = x*nrm(1)+y*nrm(2);
xo = x-nrm(1)*p;
yo = y-nrm(2)*p;

xo = -xo+nrm(1)*p+ax(1);
yo = -yo+nrm(2)*p+ax(2);
