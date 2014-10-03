function [ibp,iip,w,Dx,Dy] = ptsinblk(jj,x,y,Nb,Sp,...
                             Lx,Ly,n0,isup)
% PTSINBLK  Block pre-processing for interpolation routines.
%	Used in MINCURVI, OBJMAP, KRIGING.
%
%	Input:
%	JJ    - index of current block
%	X,Y   - coordinates of basis and interp. points
%	NA    - adjacency matrix
%	SP    - sparse matrix of indices of points in blocks
%	LX,LY - matrices (nb by 2) of limits of blocks
%	N0    - number of basis points   
%	ISUP  - mask for underpopulated blocks
%
%	Output:
%	IBP   - indices of basis points used for current
%	        block
%	IIP   - indices of interpolation points
%	W     - weights
%	DX,DY - distance matrices of basis points

%  Copyright (c) 1995 by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/25/95

%  1. Find neighbouring blocks, get all basis and 
%     interpolation points in all these blocks
%  2. For underpopulated neighb. blocks find "secondary"
%     neighbours. Get basis points from these new blocks.
%  3. Calculate distances Dx,Dy matrix between basis points
%  4. Calculate weights for interp. points outside the
%     current block

np = length(x);

 % Neighbours of a current block
mask_nb = Nb(jj,:);

 % Find "secondary" neighbouring blocks - neighbours of
 % underpopulated blocks
i_up = find(mask_nb & isup); % Underpopulated blocks
a = zeros(size(mask_nb));
len = length(i_up);

if len==1
  a = Nb(i_up,:);
elseif len>1
  a = any(Nb(i_up,:));  % Find neighb of underpop. blocks
end
a = a & ~mask_nb;     % Leave only those outside

 % Get all points in the current block and its immediate
 % neighbours 
i_nb = find(mask_nb);
if length(i_nb)<=1
  mask_p = full(Sp(i_nb,:));
else
  mask_p = full(any(Sp(i_nb,:)));
end      % All pts. in cur. blocks


 % Get basis points from neighbours of underpopulated blocks
i_nb = find(a);
if length(i_nb)==1
  mask_p = mask_p+2*full(Sp(i_nb,:));
elseif length(i_nb)>1
  mask_p = mask_p+2*full(any(Sp(i_nb,:)));
end
mask_p = mask_p';

 % Separate basis and interpolation points
 % Basis points:
ibp = find(mask_p(1:n0));
xb = x(ibp);
yb = y(ibp);

 % Interpolation points
iip = find( mask_p(n0+1:np)==1 | mask_p(n0+1:np)==3 );
iip = iip+n0;

 % Distance matrix .................................
ob = ones(size(xb));
Dx = xb(:,ob);
Dx = Dx-Dx';
Dy = yb(:,ob);
Dy = Dy-Dy';


 % Calulate weights ................................
xi = x(iip);
yi = y(iip);
w = ones(size(xi));

 % Limits and size of current block
limx = Lx(jj,:);
dx = diff(limx);
limy = Ly(jj,:);
dy = diff(limy);

 % X-weights
ii = find(xi<limx(1));
cc = limx(1)-xi(ii);
w(ii) = 1./(1+16*(cc/dx).^2);
ii = find(xi>limx(2));
cc = limx(1)-xi(ii);
w(ii) = 1./(1+4*(cc/dx).^2);

 % Y-weights
ii = find(yi<limy(1));
cc = limy(1)-yi(ii);
w(ii) = w(ii)./(1+16*(cc/dy).^2);
ii = find(yi>limy(2));
cc = limy(2)-yi(ii);
w(ii) = w(ii)./(1+4*(cc/dy).^2);

