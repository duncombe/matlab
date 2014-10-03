function [Ns,Ni1,Ni2] = spx2nbr(N)
% SPX2NBR List of simplices to a matrix of connections.
%	NC = SPX2NBR(NS) Accepts a matrix N with a list
%	of triangles (or higher-dimensional simplices)
%	such as an output of triangulation/tesselation
%	program. It finds neighbouring points (sharing
%	the same simplex) for each point of a set and
%	produces a (sparse) matrix NC whose i-th column
%	has zeros for points which do not share any
%	simplex with i-th point and a positive integer
%	if they do.
%	[NC,NI1,NI2] = SPX2NBR(NS) also returns
%	auxillary indexing matrices NI1,NI2 which are
%	used in other programs (e.g. gradient estimation
%	such as GRADTLS.M).

%  Copyright (c) 1995 by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/10/95

 % Handle input ............
if nargin==0, help spx2nbr, return, end

 % Dimensions ..............
szN = size(N);
if diff(szN)<0, N = N'; end
d = size(N,1);

 % Indexing ................
vd = 1:d;
od = ones(d,1);
i1 = vd(od,:);
i2 = i1';
i1 = i1(:);
i2 = i2(:);

 % Indexing matrices .......
Ni1 = N(i1,:);
Ni2 = N(i2,:);

 % Matrix of connection itself .........
Ns = sparse(Ni1,Ni2,1);
