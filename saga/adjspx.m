function [Na,Np] = adjspx(N)
% ADJSPX  Finding adjacent simplices of triangulation.
%	NA = ADJSPX(N)  where N is d+1 by n_spx -
%	triangulation (tesselation) index matrix into d-
%	dimensional set of points.
%	[NA,NP] = ADJSPX(N) also returns a matrix of "opposite
%	points" NP of the same size as NA whith indices of the
%	points belonging to given simplices themselves but not
%	to their adjacent ones.
%	When elements of NA (and correspondingly NP) are 
%	zero it means that a corresponging facet is not 
%	shared by any other simplex, e.g. lies on the 
%	boundary of the convex hull of a triangulated set.

%  Copyright (c) 1995 by Kirill K. Pankratov
%       kirill@plume.mit.edu
%       05/10/95

 % Handle input ..................
if nargin==0, help adjspx, return, end

 % Sizes and dimensions ..........
[d,n_spx] = size(N);
if d>n_spx, N = N'; end
[d,n_spx] = size(N);
n_pts = max(max(N));

 % Auxillary .....................
od = ones(d,1);
a = (1:n_spx);
A = a(od,:);

 % Create sparse matrix with (I,J) elements = 1
 % if there is I_th  point in J-th simplex
S = sparse(N,A,1);

 % Scalar product with itself
S1 = S'*S;
S1 = S1==d-1;
[i1,i2] = find(S1);

 % Total number of adjacent simplices for each simplex
n_adj = full(sum(S1));
vv = (1:d)';
Np = vv(:,ones(1,n_spx));
Np = find(Np<=n_adj(od,:));
Na = zeros(size(N));   % Initialize
Na(Np) = i1;           % Insert indices of adjacent simplices


 % Now find the "opposite point" for each adjacent simplex
if nargout<2, Np = [], return; end
Np = zeros(size(N));
for jj = 1:d

  % Find where there is an adjacent facet
  [i1,i2,n_adj] = find(Na(jj,:));

  % Add point counts in those adjacent facets
  S1 = S+sparse(N(:,n_adj),A(:,i2),2,n_pts,n_spx);

  % For points belonging to both simplices S=3,
  % For points belonging to adjacent simplices S2,
  % For "opposite points" S=1
  [i1,n_adj,a] = find(S1(:,i2)==1);
  Np(jj,i2) = i1';

end

