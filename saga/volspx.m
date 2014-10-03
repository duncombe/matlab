function v = volspx(R)
%	VOLSPX  Volume of a simplex.
%	V = VOLSPX(R) Calculates a volume inside a
%	n-dimensional simplex (n+1 set of points).

%  Copyright (c) 1995 by Kirill K. Pankratov
%       kirill@plume.mit.edu
%       04/21/95, 05/22/95

sz = size(R);
d = min(size(R));
 % Transpose so that vertical size is larger
if sz(1)<sz(2), R = R'; end

 % Make last point origin of coordinate system
R = R(1:d,:)-R((d+1)*ones(d,1),:);

 % Now calculate a volume (D/n!)
v = abs(det(R))/prod(1:d);

