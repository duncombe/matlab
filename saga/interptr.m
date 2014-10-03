function  zi = interptr(x,y,z,xi,yi,opt,p)
% INTERPTR  Interpolation from 2-d irregular points by a
%	triangulation method.
%	ZI = INTERPTR(X,Y,Z,XI,YI) Returns values ZI at
%	points with coordinates XI, YI interpolated from
%	points with coordinates X, Y and values Z.
%	For points XI, YI outside of convex hull of a set
%	X, Y returns NAN (these points do not belong to any 
%	triangle of a set X, Y).
%	ZI = INTERPTR(X,Y,Z,XI,YI,OPT,P)  also has option
%	for blending with gradient estimation: OPT(1)=1 or 'g';
%	and extrapolation beyond the convex hull:
%	OPT(2)=1 or OPT='e'.  OPT = 'eg' or 'ge' means both
%	options are specified. Parameter P (in the range
%	[0 1]) controls "toutness" of the surface in case of
%	gradient estimation: P=0 correspond to a tout
%	surface (without gradient information), while P=1
%	corresponds to an "elastic" surface.
%
%	See also TRIANGUL, GRIDDATA.

%  Copyright (c) 1995  by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	02/27/95, 05/25/95, 09/15/95

 % Defaults and parameters ..............................
is_grad = 0;  % Is gradient information to be included
is_extr = 0;  % Is extrapolate beyond the convex hull
p_dflt = 1;   % "Toutness parameter" for gradient information

 % Handle input .........................................
error(nargchk(5,7,nargin)) % Must be 5 input arguments
if nargin>=6        % Options for gradient and extrapolation
  if isstr(opt)
    is_grad = any(opt=='g');
    is_extr = any(opt=='e');
  else
    is_grad = opt(1);
    is_extr = opt(2);
  end
end
if nargin < 7, p = p_dflt; end  % Toutness parameter ....

 % Check input coordinates and make matrices XI, YI
 % if necessary
[msg,x,y,z,xi,yi] = xyzchk(x,y,z,xi,yi);
if length(msg)>0, error(msg); end

 % Auxillary ..........................
szi = size(xi);
xi = xi(:)';
yi = yi(:)';
l = length(xi);
o3 = ones(3,1);

 % Check for coincident points ............
[A,z] = uniquept([x(:) y(:)],z(:));
x = A(:,1); y = A(:,2);

 % Triangulate a set of points ..........................
[i3,nc] = triangul(x,y);
n3 = size(i3,2);

 % Reshape into triangles ...............................
x3 = reshape(x(i3),3,n3);
y3 = reshape(y(i3),3,n3);
d = reshape(z(i3),3,n3);

 % Determine which point in which triangle ..............
[in,A] = inmesh(x3,y3,xi,yi);
fnd = find(in);
in = in(fnd);


 % Make a linear interpolation by area method ...........
zi = nan*ones(1,l);
A = A(2:4,:)./A(ones(3,1),:); % Weights
zi(fnd) = sum(d(:,in).*A);    % Interpolation itself


 % Incorporate gradient information ......................
if is_grad & p>0

  % Calculate a cross product (normal to triangles)
  gx = x3(2:3,:)-x3([1 1],:);
  gy = y3(2:3,:)-y3([1 1],:);
  d  =  d(2:3,:)- d([1 1],:);
  d = [gy(1,:).*d(2,:) - gy(2,:).*d(1,:);
      -gx(1,:).*d(2,:) + gx(2,:).*d(1,:);
       gx(1,:).*gy(2,:)- gx(2,:).*gy(1,:)];
  gt = -d(1:2,:)./d([3 3],:);

  A = A.*(1-A.^p);           % Weights

  % Estimate gradients at node points 
  [gx,gy] = grad2est(x,y,z,i3,'ls');
  gx = reshape(gx(i3),3,n3);
  gx = gx - gt(o3,:);  % Differences with triangles
  gy = reshape(gy(i3),3,n3);
  gy = gy - gt(2*o3,:);

  % Add gradient information
  d = xi(o3,fnd)-x3(:,in);
  gx = d.*gx(:,in);         % dx
  d = yi(o3,fnd)-y3(:,in);
  gx = gx+d.*gy(:,in);      % dy
  zi(fnd) = zi(fnd)+sum(gx.*A);

end

 % Extrapolation outside of the convex hull ..............
if is_extr
  fnd = find(isnan(zi));
  zi(fnd) = extraptr(x,y,z,i3,xi(fnd),yi(fnd));
end

 % Reshape output ...................
zi = reshape(zi,szi(1),szi(2));

