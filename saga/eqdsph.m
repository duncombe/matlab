function [x,y,z] = eqdsph(n,tol)
%  EQDSPH  Equilibrium distribution of points on a sphere
%	[X,Y,Z] = EQDSPH(N)  Calculates "equilibrium" 
%	distribution of N points on a unit sphere.
%	EQDSPH(N,TOL) also can specify the tolerance for
%	the disbalanve of "forces".
%
%	EQDSPH uses "electron dynamics" method - that is
%	"solves" kinetic equation for repellent points
%	moving freely along the sphere until reaching
%	approximately equilibrium positions.
	
%  Copyright (c) 1995 by Kirill K. Pankratov
%       kirill@plume.mit.edu
%       05/10/95

 % Defaults and parameters
tol_dflt = 1e-3;    % Default for tolerance
iter_max = 200;
l_ch = 20;
part = 1/5;
a = .6;
e = 1e-8;           % Substitute for zero

if nargin<2, tol = tol_dflt; end

 % Scale ..................
d = sqrt(2*pi/n);
tol = tol*sqrt(n);

 % Auxillary ..............
l_ch = min(l_ch,n);
n_chunk = ceil(n/l_ch);
o_ch = ones(1,l_ch);
on = ones(n,1);

 % Initialization .........
R = randsph(n);
x = R(:,1);
y = R(:,2);
z = R(:,3);

 % Iterate - solve "charged particles dynamics" equation
 % until (approximate) equilibrium
vx = zeros(size(x)); vy = vx; vz = vx;
vmax = 1;
iter = 0;
while vmax>tol & iter<iter_max
  iter=iter+1;
  part = part*.978;
  a = a*.99;

  for jj=1:n_chunk
    i_ch = (1:l_ch)+(jj-1)*l_ch;
    if jj==n_chunk, i_ch = n-l_ch+1:n; end

    vv = x(i_ch)';
    Xd = x(:,o_ch)-vv(on,:);
    vv = y(i_ch)';
    Yd = y(:,o_ch)-vv(on,:);
    vv = z(i_ch)';
    Zd = z(:,o_ch)-vv(on,:);
    R2 = -(Xd.^2+Yd.^2+Zd.^2+e).^(-1);

    Xd = Xd.*R2;
    Yd = Yd.*R2;
    Zd = Zd.*R2;

    % Velocities
    vx(i_ch) = sum(Xd)';
    vy(i_ch) = sum(Yd)';
    vz(i_ch) = sum(Zd)';
  end

  % Project velocities on a surface
  pr = x.*vx+y.*vy+z.*vz;
  vx = vx-pr.*x;
  vy = vy-pr.*y;
  vz = vz-pr.*z;

  if iter==1, vxh = vx; vyh = vy; vzh = vz; end
  vx = vxh*(1-a)+vx*a;
  vy = vyh*(1-a)+vy*a;
  vz = vzh*(1-a)+vz*a;
  vxh = vx; vyh = vy; vzh = vz;

  % Timestep
  v2 = sqrt(vx.^2+vy.^2+vz.^2);
  vmax = max(v2);
  vmean = sqrt(mean(v2));
  dt = part*d/vmax;

  % Update coordinates
  x = x+dt*vx;
  y = y+dt*vy;
  z = z+dt*vz;

  % Normalize
  pr = sqrt(x.^2+y.^2+z.^2);
  x = x./pr;
  y = y./pr;
  z = z./pr;


%[vmax part vx(1)]
end

if nargout < 2, x = [x y z]; end
