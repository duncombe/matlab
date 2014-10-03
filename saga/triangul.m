function  [no,p,nc] = triangul(x,y,trace)
%  TRIANGUL  Triangulation of a set of points on a plane.
%	N3 = TRIANGUL(X,Y) Performs triangulation of a set of
%	points with coordinates X, Y. Returns a matrix N3 
%	(3 by number of triangles) each row of which represents
%	indices of a triangle (indices into vectors x,y).
%
%	TRIANGUL(X,Y,TRACE) plots results of the triangulation
%	(a patch for every triangle).
%	TRACE = 1  plots results at every iteration.
%	TRACE = 2  plots only final results.
%	TRACE = 3  Creates patches but makes them invisible
%	(can be used for some demonstration purposes).
%
%	TRIANGUL DEMO  is a demonstration of this routine.	

%  Copyright (c) 1995 by Kirill K. Pankratov
%       kirill@plume.mit.edu
%       11/22/94, 02/23/95, 05/22/95

tol = 1e-14;       % Tolerance for cos(angle) comparison
tol_area = 1e-5;   % Tolerance for rel. area of triangles
p_inflate  = 1e-4; % Inflation parameter (0 - no change)

if nargin==0, help triangul, return, end
if nargin<3, trace = 0; end

if nargin==1,     % DEMO mode ..........................
  if strcmp(x,'demo')
    trace = 1;
    disp(' ')
    disp(' This is a demonstration of a triangulation program')
    disp(' ')

    % Generate random data x,y
    n = 200;
    dx1 = rand(1,n).^(1/2);
    dy1 = rand(1,n)*2*pi;
    x = dx1.*cos(dy1);
    y = dx1.*sin(dy1);
  end
end

x = x(:); y = y(:);   % Make column vectors
l = length(x);
if l~=length(y)
  error(' Vectors X and Y must have the same length.')
end

 % Start with a convex hull .................
 % "Inflate" dataset to increase convexity
Edge = inflate([x y],p_inflate);
x = Edge(:,1);
y = Edge(:,2);
i_new = convex2(x,y);
i_new = [i_new(:)' i_new(1)];
l_e = length(i_new);
nc = l_e-1;           % Length of the convex hull
%plot(x(i_new),y(i_new),'*',x,y,'o'),pause %///////////////////

 % Determine sign of contour ................
xc = x(i_new);
yc = y(i_new);
sgn = (xc(2:l_e)-xc(1:l_e-1))'*(yc(2:l_e)+yc(1:l_e-1));
sgn = sign(sgn);

 % Index vector (0 - for points out of "active zone"
ind = ones(size(x))';

 % Initialization ...........................
Edge = [i_new(1:l_e-1); i_new(2:l_e)];
l_e = l_e-1;
num3 = [];         % Initialize output matrix
p = [];
iter = 0;
Sall = sparse(Edge(1,:),Edge(2,:),1,l,l);


 % Start moving "front" inside .................................
while any(ind) & Edge~=[]   % Until front collapses ```````````0
  iter = iter+1;

  l_e = size(Edge,2);
  ind = ind>0;
  ind(Edge(:)) = 1:l_e*2;

  % Extract still "active" points
  i_ind = find(ind);
  xc = x(i_ind);
  yc = y(i_ind);

  % Reshape Edge matrix
  num3c = Edge;
  Edge = zeros(2,l_e*2);
  Edge(:,1:2:2*l_e) = num3c;

  % Calculate maximal angle points ........................
  % Loops to save memory
  i_new = zeros(1,l_e);
  for jj = 1:l_e % For all valid pairs ````````````````````1
    jc = jj*2-1;
    ic0 = (jc-1)*2+[1 4];
    ic1 = ic0+[1 -1];
    xc_fr = x(Edge(:,jc));
    yc_fr = y(Edge(:,jc));
    Edge(ic0) = Edge(:,jc);
    Edge(ic1) = [0 0]';

    dx1 = xc_fr(1)-xc; % First lever
    dy1 = yc_fr(1)-yc;
    dx2 = xc_fr(2)-xc; % Second lever
    dy2 = yc_fr(2)-yc;
    a = (dx1.*dx2+dy1.*dy2); % Cross product

    % Mask (eliminate) points "behind" the front line
    mask = sign(dx1.*dy2-dx2.*dy1);
    mask = (mask==sgn);

    % Product of lengths
    dx1 = (dx1.^2+dy1.^2);
    dx2 = (dx2.^2+dy2.^2);
    dx1 = sqrt(dx1.*dx2);

    % Take care of zero length
    nn = find(~dx1);
    dx1(nn) = dx1(nn)+1;

    a = a./dx1+2*mask;      % Cosine
    a(nn) = a(nn)+2;

    nn = find(a<-1+tol);
    a(nn) = a(nn)+2;

    % Find minimum cosine (max. angle)
    amin = min(a);
    nn = find(a<=amin+tol);
    nn = i_ind(nn);

    % If several points, check that new edge does not
    % cross other existing edges
    mask = find(all(Edge)); % All other edges
    lc = length(mask)+jj;
    len = length(nn);
    ii = zeros(size(nn));
    % For each point and edge check crossing .........
    for jj1 = 1:len-(len==1)
      dy1 = [Edge(:,mask) num3c(:,1:jj)];
      dx1 = reshape(x(dy1),2,lc);
      dy1 = reshape(y(dy1),2,lc);

      dd = [xc_fr(1); x(nn(jj1))];
      dx2 = dd(:,ones(1,lc));
      dd = [yc_fr(1); y(nn(jj1))];
      dy2 = dd(:,ones(1,lc));
      a = iscross(dx1,dy1,dx2,dy2);
      ii(jj1) = any(a==1);

      dd = [xc_fr(2); x(nn(jj1))];
      dx2 = dd(:,ones(1,lc));
      dd = [yc_fr(2); y(nn(jj1))];
      dy2 = dd(:,ones(1,lc));
      a = iscross(dx1,dy1,dx2,dy2);
      ii(jj1) = ii(jj1) | any(a==1);
    end

    nn = [nn(~ii) nn(1)];
    nn = nn(1);  % Now the unique point

    % Insert the point into Edge matrix
    Edge(ic1) = [nn nn]';

  end   % End all pairs of the front points '''''''''''''''1

  % Add new triangles ......................
  num3c = reshape(Edge,4,l_e);
  num3c = num3c([1 2 4],:);
  num3 = [num3 num3c];

  ind(Edge(:)) = 2*ones(1,l_e*4); % Front pts. = 2


  % Take care of repeat elements ^^^^^^^^^^^^^^^^^^^^^^^^^^^

  % Sparse matrices
  S = sparse(Edge(1,:),Edge(2,:),1:l_e*2,l,l);

  % Exclude symmetric pairs (folded edges)
  % and repeated pairs
  Sb = S>0;
  Sb = Sb-(Sb&Sb');               % Folded edges
  Sb = Sb-((Sb&Sall)|(Sb&Sall')); % Old repeats
  S = S.*Sb;

  Sall = Sall|Sb;  % Add current pairs to collection

  [dx1,dx2] = find(S);
  Edge = [dx1 dx2]';
  l_e = size(Edge,2);

  % Update list of active points ............
  ind(Edge(:)) = 3*ones(1,l_e*2);
  ind = ind==1 | ind==3;

  if trace  % Show work in progress ^^^^^^^^^^^^^^^^^^^^^^^^^^^
    % Initialize a plot .....................
    if iter==1
      cla
      if trace==1, plot(x,y,'o'),drawnow, end
      hold on
    end

    % Update a plot (new triangles) .........
    l3c = size(num3c,2);
    x3 = reshape(x(num3c),3,l3c);
    y3 = reshape(y(num3c),3,l3c);
    p = [p; patch(x3,y3,iter*ones(1,1))];
    set(p,'erasemode','back')
    if trace==1, drawnow, end
  end

end   % End while '''''''''''''''''''''''''''''''''''''''''''''0

if trace==3, set(p,'visible','off'), end

 % Check uniqueness of triangles ............
num3 = sort(num3)';
num3 = unique(num3)';

 % Check if any triangle have zeros area .......................
a = ( x(num3(2,:))-x(num3(1,:)) ) .* ( y(num3(3,:))-y(num3(1,:)) );
a = a-( x(num3(3,:))-x(num3(1,:)) ) .* ( y(num3(2,:))-y(num3(1,:)) );
a = abs(a);
a = a/mean(a);
ii = find(abs(a)<tol_area);
num3(:,ii) = [];

if nargout>0, no = num3; end

if ~trace & nargout>1, p = nc; end

