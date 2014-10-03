function is = inpolyhd(R,Rv,N,Nrm,tol)
% INPOLYHD  True for points inside a polyhedron.
%	IS = INPOLYHD(R,RV,N) determines which
%	points of the set R are inside of a multi-
%	dimensional polyhedron with vertices coordinates
%	RV and facets indices N.
%	R is NP by D matrix (NP - number of points,
%	D - dimension),
%	RV - NV by D matrix of polyhedron vertices 
%	coordinates, 
%	N - NF by D matrix, each row specifies the 
%	points in a facet (indices into rows of matrix RV).
%
%	Returns (quasi)-boolean vector IS of the size
%	NP by 1 which is equal to 1 for points inside
%	the simplex and 0 otherwise.
%
%	IS = INPOLYHD(...,TOL) specifies 
%	For points within TOL distance to the boundary
%	(any facets of a polyhedron) IS  is equal to .5
%	Default for TOL is 10*eps.
%	

%  Calls primitive INSPX0 and possibly ROTMAT (which
%  also calls COMBIN, BINARY).

%  Copyright (c) 1995  by Kirill K. Pankratov
%       kirill@plume.mit.edu
%       09/22/95

% Algorithm: Based on the number of ray intersections.
% For each facet:
% Calculate intersections of rays along 1-st coordinate
% with n-dim facet, 
% project along 1-st coordinate into n-1 dimension,
% find whether this intersection point is inside the
% (n-1)-dim simplex, repeat procedure recursively
% till 2-d case.

 % Defaults and parameters ...........................
tol_dflt = 10*eps;   % Default for tolerance
mult = .001;         % Fractional coefficient

 % Handle input ......................................
if nargin==0, help inpolyhd, return, end
if nargin<3
  error('Not enough input arguments')
end
is_nrm = 0;
if nargin>=4, szNrm = size(Nrm);
else, tol = tol_dflt; end
if nargin==4
  if max(szNrm)>1, is_nrm = 1; tol = tol_dflt;
  else, tol = Nrm;
  end
end


 % Sizes and dimensions ..............................
sz = zeros(4,2);
sz = [size(R); size(Rv); size(N)];
if any(diff(sz(:,2)))
  np = max(max(sz));
  op = sparse(sz(:),1,1,np,1);
  d = find(op==3);  % Space dimension must be equal
  if d==[]
    a = ' Matrices R, RV, N must have the same ';
    a = [a 'number of columns'];
    error(a)
  end
  d = min(d);
  % Transpose if necessary ........
  if sz(1,2)~=d, R = R';   sz(1,:) = sz(1,[2 1]); end
  if sz(2,2)~=d, Rv = Rv'; sz(2,:) = sz(2,[2 1]); end
  if sz(3,2)~=d, N = N';   sz(3,:) = sz(3,[2 1]); end
else
  d = sz(1,2);
end
n_pts = sz(1);
nv = sz(2,1);
n_fac = sz(3,1);
if is_nrm
  if all(szNrm==[n_fac d]), Nrm = Nrm';
  elseif ~all(szNrm==[d n_fac])
    a = ' NRM must have the same size as index matrix N';
    error(a)
  end
end


 % Auxillary ..........................
od = ones(d,1);
op = ones(n_pts,1);
is = zeros(n_pts,1);
tol = max(tol(1),0);

 % Exclude points which are off limits ..............
rmin = min(Rv)-tol;
rmax = max(Rv)+tol;
A = R>=rmin(op,:) & R<=rmax(op,:);
ind = find(all(A'));


 % Quick exit if no points within limits
if ind==[], return, end

 % Extract points within limits ........
np = length(ind);
is_out = np<n_pts;
if is_out
  R = R(ind,:);
  is = zeros(np,1);
  op = ones(np,1);
end


 % Shift coordinates so that the origin is outside ..
rmin = min(Rv);
rmax = max(Rv);
if any(rmin<=0 & rmax>=0) & ~is_nrm
  rmin = rmax-rmin;
  rmax = (1+rand(1,d)).*rmin;
  R = R+rmax(op,:);
  Rv = Rv+rmax(ones(nv,1),:);
end


 % If normals are not input, calculate them ........
if ~is_nrm
  Nrm = zeros(d,n_fac);
  for jj = 1:n_fac
    c_fac = N(jj,:);
    Rs = Rv(c_fac,:);
    Nrm(:,jj) = Rs\od;
  end
end


 % Make sure that the first component is not close to 0
while any(abs(Nrm(1,:))<tol)
  A = rotmat(d);  % Rotational matrix
  Nrm = A'*Nrm;
  R = R*A;
  Rv = Rv*A;
end


 % For each facet calculate intersections
is  = zeros(np,1);
for jj = 1:n_fac
  c_fac = N(jj,:);
  c_nrm = Nrm(:,jj);

  % Find points which can possibly
  % intersect the current facet
  Rs = Rv(c_fac,:);    % Current facet
  rmin = min(Rs)-tol;  % Limits
  rmax = max(Rs)+tol;
  A = R>=rmin(op,:) & R<=rmax(op,:);
  A = A(:,2:d)';

  ii = find(all(A));  % Points within all the limits
  Rc = R(ii,:);        % Extract subset of these points

  if ii~=[]
    x1 = Rc(:,1);        % Snip the first component
    Rc = Rc(:,2:d);
    Rs = Rs(:,2:d);

    % Calculate intersections
    xi = Rc*c_nrm(2:d);
    xi = (1-xi)/c_nrm(1);

    % Call INSPX0 with found points ...........
    c_is = inspx0(Rc,Rs,tol);

    % Check the first component of intersection
    a = xi-x1;
    ii1 = find(abs(a)<tol);
    a = a>0;

    a(ii1) = mult*ones(size(ii1));

    c_is = c_is.*a;
    is(ii) = is(ii)+c_is;

  end  % End if

end  % End for


 % Check if even or odd nmb. of intersections ......
op = floor(is);
ii = find(is>op);
op = op-2*floor(op/2);
op(ii) = .5*ones(size(ii));

 % Combine with excluded points .........
if is_out
  is = zeros(n_pts,1);
  is(ind) = op;
else     % If weren't any excluded points
  is = op;
end

