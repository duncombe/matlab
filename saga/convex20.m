function e = convex20(n0,n1,num,x,y)
% CONVEX20 Primitive for CONVEX2 (convex hull of a two-
%	dimensional dataset).

%  Copyright (c) 1995 by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	04/19/95, 05/21/95

x0 = x(n0); y0 = y(n0);
x1 = x(n1); y1 = y(n1);


 % Calculate cross-product to find the outermost point
p = (x-x0)*(y1-y0)-(y-y0)*(x1-x0);
ii = find(p>0);

if ii==[]      % Stop

  e = num(n1);

else           % Continue recursion

  p = p(ii);
  [xm,nm] = max(p);  % Find outermost point
  num = [num([n0 n1]); num(ii)];
  nm = nm+2;
  
  x = [x0; x1; x(ii)];
  y = [y0; y1; y(ii)];

  e1 = convex20(1,nm,num,x,y);
  e2 = convex20(nm,2,num,x,y);
  e = [e1; e2];

end
