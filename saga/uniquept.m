function [Ro,fo] = uniquept(R,f)
% UNIQUEPT Finding unique points in a set.
%	[RU,FU] = UNIQUEPT(R,F) where R is N by D
%	matrix of coordinates of N points in D-
%	dimensional space, F is N by K matrix of
%	K-dimensional vectors at these points.
%	Returns FU - NU by D matrix of unique
%	points chosen from a set R (NU<=N) and 
%	matrix FU of the size NU by K of values
%	at these unique points.
%	These values are equal to corresponding rows of
%	F for unique points and averaged over values 
%	at all coincident points.
%
%	Example: for 2-d case the syntax can be:
%	[R,z] = uniquept([x(:) y(:)],z(:));

%  Copyright (c) 1995  by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	09/14/95


 % Handle input ..................
if nargin==0, help uniquept, return, end
[np,dim] = size(R);
[np1,dim_f] = size(f);
if np~=np1
  error(' Number of rows in R an F must be equal')
end

 % Find unique points (rows in R)
[Ro,ind,c] = unique(R);
len = length(c);

 % Quick exit if no coincident points
if len==np,
  Ro = R; fo = f; return
end

 % Map values f to fo ...............
fo = zeros(len,dim_f);
for jj = 1:dim_f
  a = sparse(ind,1,f(:,jj));
  fo(:,jj) = full(a)./c;
end

