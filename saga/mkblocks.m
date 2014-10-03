function [x,y,s,nb,nbl,ind,bx,by,Na,Lx,Ly,Sp,npb] = ...
           mkblocks(xb,yb,xi,yi,n0,nmax)
% MKBLOCKS Auxillary routine for block-processing.
%	Used in MINCURVI, OBJMAP, KRIGING.

%  Copyright (c) 1995 by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/25/95

nb = prod(size(xb));
ni = prod(size(xi));
if nb<=nmax, n0=nmax; end

 % Combine known and interp. points in one vector
x = [xb(:); xi(:)];
y = [yb(:); yi(:)];
s = [ones(nb,1); zeros(ni,1)];

 % Calculate "quadtree" .........................
[ind,bx,by,Na,Lx,Ly] = quadtree(x,y,s,n0);
if Na==[],
  Na=1;
  Lx = [min(min(x)) max(max(x))];
  Ly = [min(min(y)) max(max(y))];
end
nbl = size(Na,1);

 % Construct sparse matrix for indexing .........
np = length(ind);
Sp = sparse(ind,1:np,1,nbl,np);

 % Number of points in each block ...............
npb = full(sum(Sp'));

