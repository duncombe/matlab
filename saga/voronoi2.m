function [xc,yc,S,Nt,ln] = voronoi2(x,y,opt)
% VORONOI2 Planar Voronoi diagram.
%	[XV,YV,V,T] = VORONOI2(X,Y)  Calculates
%	Voronoi diagram of points with coordinates X, Y.
%	Returns coordinates XV, YV of Voronoi vertices
%	(circumcenters of Delaunay triangles), index
%	matrix V into vectors XV, YV of Voronoi
%	polygons for each points and intex matrix T of
%	Delaunay triangulation of an input set.
%	VORONOI2(X,Y) without output arguments or
%	[...,L] = VORONOI2(X,Y,1) also plots Voronoi
%	diagram.

% Copyright (c)  Kirill K. Pankratov
%       kirill@plume.mit.edu
%       06/12/95

 % Handle input .............................
if nargin==0, help voronoi2, return, end
if nargin<3, opt=0; end   % No plotting

x = x(:);
y = y(:);
np = length(x);

 % Approximate set diameter
lim = [min(x) max(x) min(y) max(y)];
d = sqrt((lim(2)-lim(1)).^2+(lim(4)-lim(3)).^2);

 % Delaunay triangulation ...................
Nt = triangul(x,y);
ntr = size(Nt,2);

 % Convex hull
ich = convex2(x,y);
ll = length(ich);
ii = [2:ll 1];
i1 = (x(ich(ii))-x(ich))';
i2 = (y(ich(ii))-y(ich))';
a = sqrt(i1.^2+i2.^2);
dv = [i2./a; -i1./a]*2*d;
 % Open direction azimuth
a0 = atan2(dv(2,:),dv(1,:));
dv = dv'+[3*x(ich(ii))+x(ich) 3*y(ich(ii))+y(ich)]/4;

%plot(x,y,'o'),hold
%plot(x(ich),y(ich)),plot(dv(:,1),dv(:,2),'*'),pause

 % Append to lists of points and triangles
x = [x; dv(:,1)];
y = [y; dv(:,2)];
Nt = [Nt [ich'; ich(ii)'; np+(1:ll)]];
ntr = size(Nt,2);
np0 = np;
np = np+ll;

 % Calculate circumferences
[i1,a] = circmsph([x y],Nt);
xc = i1(:,1);
yc = i1(:,2);

 % Calculate matrix of connections
i1 = 1:ntr;
i1 = i1(ones(3,1),:);
S = sparse(i1,Nt,1,ntr,np);

 % Entries into a sparse matrix ...........
 % i1 - ind. of triangles, i2 - indices of points
[i1,i2] = find(S);
len = length(i2);

 % Indexing for a full matrix
ii = find(diff([0; i2])); % Pointers to new points
dv = diff([ii; len+1]);
lv = max(dv);
ind = ones(size(i2));
ll = length(ii);
ind(ii(2:ll)) = lv-dv(1:ll-1)+1;
ind = cumsum(ind);
S = zeros(lv,np); % Create a matrix for putting angles

 % Angles ...........................
a = atan2(yc(i1)-y(i2),xc(i1)-x(i2));

 % Sort angles for each points ............
S(ind) = a;
ii = find(~S);
S(ii) = 20*ones(size(ii));
ii = S(:,ich)<a0(ones(lv,1),:);
S(:,ich) = S(:,ich)+2*pi*ii;
[S,i2] = sort(S);

ii = 0:lv:lv*np-1;
ii = ii(ones(lv,1),:);
i2 =  i2+ii;

 % Now put indices of triangles ...........
S = zeros(lv,np);
S(ind) = i1;   % Insert indices
S = S(i2);     % Rearrange according to angles

 % Plotting the diagram .........
if opt | nargout<1
  plot(x(1:np0),y(1:np0),'o')
  for jj=1:np;
    nn = S(:,jj);
    nn = nn(find(nn));
    ln(jj) = line('xdata',xc(nn),'ydata',yc(nn));
  end
  axis square, axis equal
end

