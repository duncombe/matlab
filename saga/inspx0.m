function is = inspx0(R,Rs,tol)
% INSPX0 True for points inside an n-dimensional simplex.
%	IS = INSPX0(R,RS,TOL)  Accepts coordinates R of 
%	the size NP by D, where NP is a number of points 
%	and D is dimension and coordinates RS (D+1 by D)
%	of the vertices of a simplex; also optional scalar
%	TOL (tolerance for distance to the boundary).
%	Returns (quasi)-boolean vector IS of the size
%	NP by 1 which is equal to 1 for points inside
%	the simplex and 0 otherwise.
%	For points within TOL distance to the boundary
%	(any facets of a simplex) IS  is equal to some
%	fractional number. Default for TOL is 10*eps.
%
%	Primitive for INPOLYHD routine.

%  Copyright (c) 1995  by Kirill K. Pankratov
%       kirill@plume.mit.edu
%       09/22/95

 % Defaults and parameters .........................
tol_dflt = 10*eps;
mult = .001;

 % Handle input ....................................
if nargin<3, tol = tol_dflt; end

 % Sizes and dimensions
[dd,d] = size(Rs);   % Dimension
[np,d1] = size(R);   % Number of points


 % Auxillary .......................................
od = ones(d,1);
op = ones(np,1);
is = zeros(np,1);


 % 2-d case (triangles) ............................
if d==2

  Nrm = Rs([2 3 1],:)-Rs;
  ind = find(abs(Nrm(:,2))>=tol);

  for jj = 1:length(ind)
    nn = ind(jj);
    b = Nrm(nn,:);
    n1 = (R(:,2)-Rs(nn,2))/b(2);
    xi = Rs(nn,1)+n1*b(1);
    n1 = (n1>=0) & (n1<=1);

    a = xi-R(:,1);
    ii = [ii; find( (abs(a)<tol) & n1 )];
    is = is+(a>0 & n1);
  end

  a = floor(is);
  is = a==1;
  is(ii) = mult*ones(size(ii));   

  return
end


 % Shift coordinates so that the origin is outside
sc = [min(Rs); max(Rs)];
if any(sc(1,:)<=0 & sc(2,:)>=0)
  sc = diff(sc);
  r0 = (1+rand(1,d)).*sc;
  R = R+r0(ones(np,1),:);
  Rs = Rs+r0(ones(d+1,1),:);
end


 % Calculate normals ...................
Nrm = eye(d+1);
for jj=1:d+1
  ii = find(~Nrm(:,jj));
  Nrm(1:d,jj) = Rs(ii,:)\od;
end
Nrm = Nrm(1:d,:)';


 % Check if the first component is not 0
while any(abs(Nrm(:,1))<tol)
  A = rotmat(d);  % Rotational matrix
  Nrm = Nrm*A;
  R = R*A;
  Rs = Rs*A;
end


 % Snip the first component ............
n1 = Nrm(:,1); Nrm = Nrm(:,2:d);
x1 = R(:,1); R = R(:,2:d);
Rs = Rs(:,2:d);

A = ~eye(d+1);
is = zeros(np,1);
for jj = 1:d+1
  r0 = Nrm(jj,:);
  xi = R*r0';
  xi = (1-xi)./n1(jj);

  % Take care of first coordinate
  a = xi-x1;
  ii = find(abs(a)<tol);
  a = a>0;
  a(ii) = mult*ones(size(ii));

  % Recursive call
  io = inspx0(R,Rs(find(A(:,jj)),:));

  io = io.*a;

  is = is+io;

end

 % Check odd or even nmb. of intersections
io = floor(is);
ii = find(is-io);      % Close to boundary
is = io-2*floor(io/2);
is(ii) = mult*ones(size(ii));
