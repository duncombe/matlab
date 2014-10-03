function [nx,ny,del] = grad2ls(x,y,z,N,opt)
% GRADTLS Gradient estimation using least-squares fit.
%	[NX,NY] = GRAD2LS(X,Y,Z,N) Estimates horizontal
%	gradient at points with coordinates X, Y and 
%	"height" data Z.
%
%	[NX,NY,D] = GRAD2LS(...) also returns vector D
%	(of the same size as NX, NY) equal to the 
%	discriminant (Sxx*Syy-Sxy^2) in least-squares
%	inversion. It can be used as an estimate of robust-
%	ness of gradient estimation.

%  Copyright (c) 1995 by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/10/95

e = 1e-9;
opt_dflt = 1;
isN = 0;

 % Handle input ..........................
if nargin==0, help gradtls, return, end
if nargin<4, opt = opt_dflt; isN = 0; end


 % Sizes and dimensions ..................
is_clmn = 0;
if size(x,1)>1, is_clmn = 1; end
x = x(:); y = y(:); z = z(:);
d = 3;
n_spx = size(N,2);

 % Get neighbour connections and indexing matrices
[Ns,Ni1,Ni2] = spx2nbr(N);

 % Construct coordinate difference matrices
Xs = reshape((x(Ni1)-x(Ni2)),d*d,n_spx);
Xs = sparse(Ni1,Ni2,Xs);
Ys = reshape((y(Ni1)-y(Ni2)),d*d,n_spx);
Ys = sparse(Ni1,Ni2,Ys);
Zs = reshape((z(Ni1)-z(Ni2)),d*d,n_spx);
Zs = sparse(Ni1,Ni2,Zs);

 % Correct coordinate difference matrices:
 % Divide by number of neighbours  (Ns)
I = find(Ns);
Xs(I) = Xs(I)./Ns(I);
Ys(I) = Ys(I)./Ns(I);
Zs(I) = Zs(I)./Ns(I);


 % Now the gradient estimation itself .........

 % Summation terms for least-squares inversion
sxx = full(sum(Xs.^2));
syy = full(sum(Ys.^2));
sxy = full(sum(Xs.*Ys));
sxz = full(sum(Xs.*Zs));
syz = full(sum(Ys.*Zs));

 % Discriminant ..............
del = sxx.*syy-sxy.^2;
del = del+e*sign(del);
ii = find(~del);
del(ii) = ones(size(ii));

 % Inversion itself ..........
nx = (sxz.*syy-syz.*sxy)./del;
ny = (syz.*sxx-sxz.*sxy)./del;

 % Transpose if needed
if is_clmn, nx = nx'; ny = ny'; del = del'; end
