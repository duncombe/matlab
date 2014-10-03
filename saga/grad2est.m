function  [nx,ny,d] = grad2est(x,y,z,meth,opt)
% GRAD2EST 2-d Gradient estimation at irregular data.
%	[NX,NY] = GRAD2EST(X,Y,Z) Estimates horizontal
%	gradient at points with coordinates X, Y and 
%	"height" data Z.
%
%	[NX,NY] = GRAD2EST(X,Y,Z,METHOD,OPT) also accepts
%	input arguments METHOD and OPT.
%	METHOD can be one of the following: 
%	'triang'  - performs triangulation
%	'neighb'  - uses coordinate sorting routine NEIGHB
%	    to find neighbouring points.
%	'leastsquares', or simply 'ls' - uses least-square
%	plane fit (routine GRAD2LS)
%	'crossproduct', or simply 'cp' - uses triangulation
%	and combination of cross-products of triangle edges
%	for gradient estimation (routine GRAD2TCP).
%	In all cases abbreviations (like 'cro', 'tri') are valid.
%	OPT  can be option vector to GRAD2TCP (see that routine
%	for details).
%	
%	[NX,NY] = GRADTLS(X,Y,Z,N) Accepts triangulation matrix N
%	(so that it does not do it itself).
%	GRADTLS(X,Y,Z,N,'ls') or GRADTLS(X,Y,Z,N,'cp') are also
%	valid.

%  Copyright (c) 1995 by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/11/95

 % Defaults and parameters ...............
meth_dflt = 'leastsq';
Flags = str2mat('triangulate','neighbours','leastsquares','ls',...
                'crossproduct','cp');

 % Handle input ..........................
if nargin==0, help grad2est, return, end
if nargin<5, opt = []; end
if nargin<4, meth = meth_dflt; end

of = ones(size(Flags,1),1);
Ntr = [];

 % Check if 4-th argument is triangulation matrix
meth_n = [1 1];
if min(size(meth))==3,
  Ntr = meth;
  if nargin==5,
    meth = opt; opt = [];
    meth_n(1) = 0;
  end
end

 % Process "method" .......................
if isstr(meth)
  len = min(length(meth),size(Flags,2));
  A = Flags(:,1:len)==meth(of,1:len);
  nc = find(all(A'));
  if     nc==1, meth_n = [1 1];
  elseif nc==2, meth_n = [2 1];
  elseif nc==3 | nc==4, meth_n(2) = 1;
  elseif nc==5 | nc==6, meth_n(2) = 2;
  end

else

  sz = size(meth);
  mm = [min(sz) max(sz)];
  if mm(1)==1 & mm(2)>2 & mm(2)<=5
    % Interpret as parameter vector to GRAD2CP
    opt = meth;
    meth_n = [1 2];
  else
    sz = min(2,max(sz));
    meth_n(1:len) = meth(1:len);
  end

end


 % If triangulation matrix is supplied, transpose if needed
sz = size(Ntr);
if sz(1)>3, Ntr = Ntr'; end

 % Find neighbours of each point by triangulating (TRIANGUL)
 % or coordinate sorting  (NEIGHB)
if meth_n(1)==1,
  Ntr = triangul(x,y);

elseif meth_n(1)>1
  %Ntr = neighb(x,y);  % Not ready yet ???????????

end


 % Change 0 to 1 if triangulation was already made
meth_n(1) = max(1,meth_n(1));


 % Gradient estimation itself ...............................
 % Call GRAD2LS (least-squares) or GRAD2TCP (cross-product)
if     all(meth_n==[1 1])
  [nx,ny,d] = grad2ls(x,y,z,Ntr,1);

elseif all(meth_n==[2 1])
  [nx,ny,d] = grad2ls(x,y,z,Ntr,2);

elseif all(meth_n==[1 2])
  [nx,ny] = grad2tcp(x,y,z,Ntr,opt);

end

