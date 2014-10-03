function [Facets,Nrm,Q] = convexh(x,y,z)
% CONVEXH  Convex hull of arbitrary-dimensional set.
%	FAC = CONVEXH(R) returns convex hull FAC of a set
%	with coordinates R. Each row of a matrix R 
%	represents coordinates of a point in a set,
%	such as [xi yi zi ...] while each row of output
%	FAC represent indices of points in a facet in a
%	convex hull.
%	CONVEXH(X,Y,Z) can be used for 3-d sets with
%	coordinates X, Y, Z, and is the same as 
%	CONVEXH([X(:) Y(:) Z(:)]).
%
%	[FAC,NRM] = CONVEXH(...) also returns the outer
%	normal vectors to each facet, size(NRM)=size(FAC).

%  Copyright (c) 1995 by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/05/95

 % Handle input ...........................................
if nargin==0, help convexh, return, end
str_err = '  Error: arguments must be of the same size';

if nargin>1            % Add y to R
  if length(x(:))~=length(y(:))
    error(str_err)
  end
  R = [x(:) y(:)];
  if nargin>2          % Add z to R
    if length(x(:))~=length(z(:))
      error(str_err)
    end
    R = [R z(:)];
  end
else                   % 1 input argument
  R = x;
end

[n_pts,dim] = size(R); % Dimensions of data set

 % Check rank of a set, if deficient, reduce dimension
 % and calculate effective phase space ...............
c_fac = mean(R);
R = R-c_fac(ones(n_pts,1),:);
rnk = rank(R);
if nargout>2, Q=eye(dim); end
if rnk<dim         % If rank is deficient
  Q = orth(R');
  R = R*Q;
  dim = rnk;
  s = '\n Warning: rank = %i is deficient. ';
  s = [s 'Projecting into lower-dimension space.\n'];
  fprintf(s,rnk);
  [Facets,Nrm] = convexh(R);
  return
end

if dim==1 % One-dimensional case .....................
  [Nrm,d0] = min(R);
  [Nrm,d] = max(R);
  Facets = [d0; d];
  return
end

if dim==2 % Two-dimensional case .....................
  [Facets,Nrm] = convex2(R);
  return
end


 % If the program continues, dimension is more than 2.
 % Employ general method (add external points to the 
 % existing hull untill all points are inside or on the
 % hull itself

odim = ones(dim,1);  % Auxillary vector

 % Initialize a polyhedron (simplex)
[c_fac,Facets] = initspx(R);
Facets = sort(Facets')';
r0 = mean(R(c_fac,:));     % Center of init. simplex
R = R-r0(ones(n_pts,1),:); % Change coordinate origin

 % Control point (a point inside initial polyhedron)
r0 = R(Facets(1),:)/2;

 % Calculate normals to initial simplex
active_fac = ones(dim+1,1);
Nrm = zeros(size(Facets));
for jj = 1:dim+1
  % Normal to a current facet
  c_fac = Facets(jj,:);
  c_nrm = R(c_fac,:)\odim;
  t = R*c_nrm;     % Coordinate along the normal
  sgn = -sign(r0*c_nrm-1);
  Nrm(jj,:) = sgn*c_nrm';
  t = t*sgn;
  t(c_fac) = -odim;
  [cc,nn] = max(t);
  active_fac(jj) = nn*(cc>1);   % Outermost point
end

 % Initialize active points mask - zeros for points 
 % belonging to initial facets and their outermost points
active_pts = ones(n_pts,1);
active_pts(c_fac) = zeros(size(c_fac));
c_fac = find(active_fac);

 % Sort initial simplex so that active facets are first
 % Find active facets
i_fac = [find(active_fac); find(~active_fac)];
Facets = Facets(i_fac,:);
Nrm = Nrm(i_fac,:);
active_fac = active_fac(i_fac);

while active_fac(1) % While there are "active" facets ```

  % Add new point to a convex hull
  [Facets,Nrm,active_fac,active_pts] = cvxadd(Facets,Nrm,...
        active_fac,R,active_pts,r0);

end % End while (no more active facets) '''''''''''''''''

