function [No,mi] = addpt2ch(R,Ni,nn,Nrm)
% ADDPT2CH Adding external point to an convex hull
%	[NO,MI] = ADDPT2CH(R,NI,NN,NRM) Adds a point
%	with index NN from data set R to a (partial)
%	convex hull NI of set R. Returns new convex 
%	hull index matrix NO and a mask MI into rows
%	of old convex hull NI (0 - for eliminated
%	facets).

%  Copyright (c) 1995 by Kirill K. Pankratov
%       kirill@plume.mit.edu
%       05/18/95

 % Sizes ..................
[n_fac,d] = size(Ni);
od = ones(d,1);

 % Inside point ...........
n_pts = size(R,1);
a = zeros(n_pts,1);
a(Ni) = ones(size(Ni));
r0 = mean(R(a,:));

 % Calculate normals ......
if nargin<4, Nrm=zeros(size(Ni)); end
if all(all(~Nrm))
  for jj=1:n_fac
    Nrm(jj,:) = (R(Ni(jj,:),:)\od)';
  end
  ii = find(Nrm*r0'>1);
  Nrm(ii,:) = -Nrm(ii,:);
end

 % Find which facets are "inside"
mi = Nrm*R(nn,:)'<=1;  % 0-out, 1-stay

 % Create new facets .....................
Nin = Ni(~mi,:);
No = spx2fac([Nin nn(ones(size(Nin,1),1))],0);
No = sort(No')';
[No,ii,cnt] = unique([Nin; No]);
No = No(cnt<2,:);

 % Combine ald and new facets ............
No = [Ni(mi,:); No];
