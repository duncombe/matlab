function [x,y,z] = tubes(xa,ya,za,r,v2,np)
% TUBES  Plotting a tube-like surface.
%	[X,Y,Z] = TUBES(XA,YA,ZA,RAD,V,NP) calculates 
%	coordinates of a tube-like (or hose-like)
%	surface with axis curve given by XA, YA, ZA
%	radius (thickness) RAD (scalar of vector of
%	the same length LA = length(XA). RAD can be
%	also 1 by 2 or LA by 2 vector in which case it
%	specifies semiaxes of elliptical (as opposed
%	to circular) cross-section.
%	V specifies the direction of one of 2 basis
%	vectors in the tube cross-section. By default
%	it is aligned along the curvature of the tube
%	axis direction. It can be specified as a string
%	such as 'xy' or 'z' in which case it lies in the
%	XY plane, 'xz' or 'y' - in XZ plane, etc, or 
%	explicitly as 1 by 3 or LA by 3 vector.

%	See also SURFACE, TORUS, 

%  Copyright (c) 1995 by Kirill K. Pankratov
%       kirill@plume.mit.edu
%       05/17/95

 % Defaults and parameters .................
np_dflt = 20;
r_dflt = 1;
v2_dflt = 'crv';
opt = 0;
tol = 1e-12; end

 % Handle input ............................
if nargin < 6, np = np_dflt; end
if nargin < 5, v2 = v2_dflt; end
if nargin < 4, r  =  r_dflt; end

if r==[], r = r_dflt; end

 % Make all coordinates column vectors .....
xa = xa(:);
ya = ya(:);
za = za(:);
la = length(xa);

ola = ones(la,1);
szr = size(r);
if max(szr)==1, r = r(ones(la,2)); end
if all(szr==[2 1]), r = r'; szr = fliplr(szr); end
if all(szr==[1 2]), r = r(ola,:); end
szr = size(r);
if szr(2)==la, r = r'; end
if size(r,2)==1, r = r(:,[1 1]); end

if v2==[], v2 = v2_dflt; end
szr = size(v2);
if min(szr)==1
  v2 = v2(:)';
  v2 = v2(ones(la,1),:);
  opt = 4;
end
if all(szr==[3 la]), v2 = v2'; end
if all(size(v2)==[la 3]), opt = 4; end
if isstr(v2)
  opt =  3*(strcmp(v2,'xy')|strcmp(v2,'z'));
  opt = opt+2*(strcmp(v2,'xz')|strcmp(v2,'y'));
  opt = opt+(strcmp(v2,'yz')|strcmp(v2,'x'));
end

 % Auxillary
o3 = ones(1,3);
onp = ones(1,np);


 % Calculate direction along the axis ........
bv2 = [xa ya za];
[bv1,dr] = gradient(bv2);
%edges = [dr(2,:)-dr(1,:); dr(la,:)-dr(la-1,:)];
%dr(2:la-1,:) = dr(3:la,:)-dr(1:la-2,:);
%dr([1 la],:) = edges;
nrm = sqrt(sum(dr'.^2))';  % Length
nrm = nrm+eps*sign(nrm)+(~nrm);
dr = dr./nrm(:,o3);        % Normalize

 % Calculate second basis vector - in the plane 
 % perpendicular to the axis .............
if opt==0
  [bv2,bv1] = gradient(dr);
  if all(all(abs(bv1')<tol)), opt = 3; end
  nrm = sqrt(sum(bv1'.^2))'; % Length
  nrm = nrm+eps*sign(nrm)+(~nrm);
  bv1 = bv1./nrm(:,o3);      % Normalize
end

if opt<4 & opt>0  % The plane (xy,xz, or yz) is specified
  if ~any(abs(dr(:,opt))<tol), opt = rem(opt,3)+1; end
  a = ones(1,3);
  a(opt) = 0;
  a = find(a);
  bv1 = zeros(size(dr));
  bv1(:,a(1)) = -dr(:,a(2));
  bv1(:,a(2)) =  dr(:,a(1));
  nrm = find(all(~bv1'));
  if nrm~=[]
    bv1(nrm,a) = bv1(nrm,a)*nan;
    bv1(:,a(1)) = fillmiss(bv1(:,a(1)))
    bv1(:,a(2)) = fillmiss(bv1(:,a(2)))
  end

elseif opt==4
  bv1 = v2;

end


 % Third basis vector ....................
bv2 = cross(dr',bv1')';

 % Now calculate coordinates of a tube ^^^^^^^^^^

 % Generic tube coordinates ..............
th = linspace(0,2*pi,np);
xg = r(:,1)*cos(th);
yg = r(:,2)*sin(th);

 % Coordinates transformation ............
x = xg.*bv1(:,onp)  +yg.*bv2(:,onp);
y = xg.*bv1(:,2*onp)+yg.*bv2(:,2*onp);
z = xg.*bv1(:,3*onp)+yg.*bv2(:,3*onp);

x = x+xa(:,onp);
y = y+ya(:,onp);
z = z+za(:,onp);

 % Plotting ..............................
if nargout<2
  s = surface(x,y,z);
  x = s;
end

