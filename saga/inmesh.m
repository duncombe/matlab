function  [in,A,S] = inmesh(xm,ym,x,y)
% INMESH  Determines which mesh cell points belong to.
%	[IN,A] = INMESH(XM,YM,X,Y) Returns vector
%	IN with indices of the mesh cells for
%	a set of points X, Y (0 if does not belong
%	to any cell) and matrix A (4 by nmb. of points)
%	with areas of elementary triangles formed by
%	points X, Y and all edges f relevant cells
%	(this is useful for interpolation from cell
%	vertices).

%  Copyright (c) 1995  by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	02/27/95


l_bl = 10;  % Block size

 % Sizes ..................
x = x(:)'; y = y(:)';
l = length(x); 
[nv,nm] = size(xm);
n_bl = ceil(l/l_bl);

 % Auxillary ..............
om = ones(1,nm);
ov = ones(1,nv);
v1 = 1:nv;
v2 = [2:nv 1];
a = zeros(1,nm);

 % Calculate limits for each facet ...............
xml = [min(xm); max(xm)]';
yml = [min(ym); max(ym)]';

 % Make a preliminary test for ranges ............
for jb = 1:n_bl
  i_bl = (jb-1)*l_bl+1:jb*l_bl;
  if jb == n_bl, i_bl = (jb-1)*l_bl+1:l; end
  o_bl = ones(size(i_bl));
  A = x(om,i_bl)>=xml(:,o_bl) & x(om,i_bl)<=xml(:,2*o_bl);
  A = A & y(om,i_bl)>=yml(:,o_bl) & y(om,i_bl)<=yml(:,2*o_bl);
  S = [S sparse(A)];
end

 % Check if inside (the cross-product)
[im,ip] = find(S);  % Find possible inside indices
a(im) = ones(size(im));

 % Find area of relevant cells  ..................
ind = find(a);
A = -(xm(v2,ind)-xm(v1,ind)).*(ym(v1,ind)+ym(v2,ind));
a(ind) = sum(A);

xd = xm(:,im)-x(ov,ip);
yd = ym(:,im)-y(ov,ip);

A = xd(v1,:).*yd(v2,:);
A = A-xd(v2,:).*yd(v1,:);

ind = find(all(abs(sign(A)-sign(a(ov,im)))<=1));

 % Initialize output index vector
in = zeros(size(x));

ip = ip(ind);

 % Find and remove repeated indices ip
ii = find(~diff(ip))+1;
ip(ii) = []; ind(ii) = [];

A = A(:,ind);
im = im(ind);
in(ip) = im;

A = [a(im); A(v2,:)];   % Returned matrix A

