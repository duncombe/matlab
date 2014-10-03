function [nx,ny] = gradtri(x,y,z,N,opt)
% GRADTCP  Gradient estimation at points of
%	triangulated 3-d surface.
%	[Nx,Ny] = GRADTCP(X,Y,Z,N) Accepts
%	coordinates X, Y, Z and a matrix of 
%	triangles N.
%	Estimates horizontal gradient [NX, NY]
%	by "cross-product" method: combining 
%	cross-products (normals*area) of edges of
%	each triangle which has a vertex at a given
%	point.
%	[Nx,Ny] = GRADTCP(X,Y,Z,N,OPT) uses also
%	"normalization options"...

%  Copyright (c) 1995 by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/10/95

 % Defaults and parameters .........
opt_dflt = [0 1 0 0 0];

 % Handle input ....................
if nargin<5, opt = opt_dflt; end
if nargin<4, N = triangul(x,y); end

 % Auxillary ........
d = 3;
od = ones(d,1);
is_clmn = 0;
if size(x,1)>1, is_clmn = 1; end
x = x(:); y = y(:); z = z(:);
R = [x y z]';

 % Process options .................
if opt==[], opt = opt_dflt; end
opt = opt(:)';
sz = size(opt);
a = zeros(1,5);
if isstr(opt)
  % Not yet available ????????
else
  if max(sz)==1
    a(min(abs(opt),5)) = 1;
  else
    len = min(sz(2),5);
    a(1:len) = opt(1:len);
  end
  opt = a;
end


 % Set up differences vectors ..........
R1 = R(:,N(2,:))-R(:,N(1,:));
R2 = R(:,N(3,:))-R(:,N(1,:));

 % Cross-product (normal*area of each triangle).....
Nrm = cross(R1,R2);

 % Check sign, make it positive
ii = find(Nrm(3,:)<0);
Nrm(:,ii) = -Nrm(:,ii);


 % Calculate different normalization options .......
l1 = sum(R1.^2);  % Lengths of edges
l2 = sum(R2.^2);
l1 = l1.*l2;
l2 = sqrt(l1);

nx = sum(Nrm.^2); % Lengths of normals
ny = sqrt(l1);
cc = mean([l1; l2]');

L = ones(5,length(l1));
L(2:3,:) = [cc(1)./l2; cc(2)./l1];
cc = mean([nx; ny]');
L(4:5,:) = [cc(1)./ny; cc(2)./nx];


 % Normalization itself ..............
l1 = opt*L;
Nrm = Nrm./l1(od,:);

 % Now for each points add together normals from all
 % triangles having a vertex in this point .........
l1 = Nrm(1,:);
nx = full(sparse(1,N,l1(od,:)));
l1 = Nrm(2,:);
ny = full(sparse(1,N,l1(od,:)));
l1 = Nrm(3,:);
l1 = full(sparse(1,N,l1(od,:)));

 % Now make a gradient estimate itself .............
nx = -nx./l1;
ny = -ny./l1;

 % Transpose if needed
if is_clmn, nx = nx'; ny = ny'; del = del'; end

