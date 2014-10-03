function [spx,F] = initspx(R)
% INITSPX  Initialize a simplex out of a set of points.
%	S = INITSPX(R)  Returns indices to points of 
%	of a subset of R which forms a simplex in
%	n-dimensional space.
%	The program tried to choose a simplex with a 
%	maximum volume.

%  Copyright (c) 1995  by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/03/95

[n_pts,d] = size(R); % Nmb. of points and dimension
od = ones(d,1);      % Auxillary vector

 % Make mean point origin od coord. system
r0 = mean(R);
R = (R-r0(ones(n_pts,1),:))';

 % Successively extract the most distant point;
 % Remove projection of all vectors to the vector
 % to the most distant point, repeat the procedure 
 % for until getting effectively 1-d array
spx = zeros(1,d+1);
for jj=1:d-1
  r2 = sum(R.^2);
  [cc,nn] = max(r2);
  spx(jj) = nn;

  nrm = R(:,nn);
  cc = sqrt(nrm'*nrm);
  nrm = nrm./(cc+(~cc));

  proj = nrm'*R;  % Projections to a current direction
  R = R-nrm*proj; % Residuals
end

 % Find the largest component of the 1-d residual 
 % vector
nrm = sum(abs(R'));
[cc,nn] = max(nrm);
r2 = R(nn,:);  % Extract largest component

[cc,nn] = min(r2);
spx(d) = nn;
[cc,nn] = max(r2);
spx(d+1) = nn;

 % Extract only unique points
r0 = [1 find(diff(spx))];
spx = spx(find(r0));

 % Make a matrix of facets if needed
if nargout>1
  d = length(spx);
  r2 = ~eye(d);
  F = spx(ones(d,1),:)';
  F = reshape(F(r2),d-1,d)';
end

