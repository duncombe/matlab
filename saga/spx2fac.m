function Nf = spx2fac(Ns,flag)
% SPX2FAC  List of simplices to list of faces.
%	NF = SPX2FAC(NS) accepts matrix NS (n_spx
%	by d+1 where d - dimension) with each row 
%	indices of a simplex. 
%	Returns matrix NF with each row indices of 
%	(unique) facets. 

%  Copyright (c) 1995 by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/15/95

if nargin<2, flag = 1; end

 % Sizes and dimensions ........
[n_spx,d] = size(Ns);
d = d-1;

 % Auxillary indexing vectors and matrices
A = eye(d+1);
[I1,I2] = meshgrid(1:d+1,1:n_spx);
I1 = I1';
I2 = I2';
A = A(:,I1(:));

 % Reshape simplices matrix
Nf = Ns';
Nf = Nf(:,I2(:));
Nf = reshape(Nf(find(~A)),d,n_spx*(d+1))';

 % Make it unique
if flag, Nf = unique(Nf); end

