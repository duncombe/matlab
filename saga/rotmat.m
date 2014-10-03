function  R = rotmat(d,th)
% Rotational (unitary) matrix.
%	R = ROTMAT(D) produces a random rotation
%	matrix of dimension D.

%  Copyright (c) 1995 by Kirill K. Pankratov
%       kirill@plume.mit.edu
%       09/22/95


 % Handle input .............................
if nargin==0, d = 3; end
if nargin<2, th = []; end

 % Component pairs ..........................
C = combin(d,2);
n = size(C,1);
[i1,i2] = find(C');
i1 = fliplr(reshape(i1,2,n));

 % Angles ....................
thr = (2*rand(n,1)-1)*pi;
thr(1:length(th)) = th;

c = cos(thr);
s = sin(thr);

R = eye(d);
for jj = 1:n
  ii = i1(:,jj);
  cc = c(jj); ss = s(jj);
  A = eye(d);
  A(ii,ii) = [cc ss; -ss cc];
  R = R*A;
end

