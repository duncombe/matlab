function [c,a] = circmsph(R,N)
% CIRCMSPH  Circumspheres for n-dimensional simplices
%	(triangles for 2-d, tetrahedra for 3-d, etc.).
%	[C,A] = CIRCMSPH(R) where R is d+1 by d matrix of 
%	coordinates of d-dimensional simplex, calculate 
%	center C and radius A of its circumspere.
%
%	[C,A] = CIRCMSPH(R,N)  calculate circumspere centers
%	C and radii A for each simplices described by matrices
%	R and N.  R is coordinates of data set (row per point)
%	and N is index matrix of simplices (each row consist of
%	indices into rows of R of points constituing a simplex).
%
%	(Index matrix N is likely to be output of a 
%	triangulation/tesselation program, such as TRIANGUL.M,
%	DELAUNAY.M).

%	Front-end routine, calls primitive CIRCMSPH0.

%  Copyright (c) 1995 by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/10/95

 % Handle input ..............................................
if nargin==0, help circmsph, return, end
if nargin==1
  szR = size(R);
  if diff(szR)>0, R = R'; szR = fliplr(szR); end
  d = szR(2);                  % Dimension
  [c,a] = circmsph0(R);        % Call the primitive
  return
end

szR = size(R);
szN = size(N);
lim1 = [min(min(R)); max(max(R))];
lim2 = [min(min(N)); max(max(N))];
isN(1) = all(all(round(R)==R));
isN(2) = all(all(round(N)==N));
isN = isN.*[lim1(1)>0 lim2(1)>0]; % Find which argument is index matrix

if diff(isN)<0
  c = N; N = R; R = c;
end

if ~any(isN)
  error('   Second argument must be an index matrix')
end

szR = size(R);
szN = size(N);
if diff(szR)>0, R = R'; szR = fliplr(szR); end
d = szR(2);             % Dimension

if ~any(szN==d+1)
  error('  Index matrix N must have d+1 columns')
end
if szN(1)==d+1, N = N'; szN = fliplr(szN); end

n_spx = szN(1);  % Number of simplices (rows in matrix N)


 % Calculate centers and radii of circumspheres 
 % for each simplex 
c = zeros(n_spx,d);
a = zeros(n_spx,1);
for jj = 1:n_spx
  rs = R(N(jj,:),:);
  [cc,ca] = circmsph0(rs);
  c(jj,:) = cc;
  a(jj) = ca;
end
    
