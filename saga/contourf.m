function  [cout,hp] = contourf(arg1,arg2,arg3,arg4,arg5)
% CONTOURF  Filled contour plot.
%	Similar to CONTOUR command but fills the space between
%	contour lines with uniform color (according to the
%	figure colormap) instead of just contour lines.
%	Syntax is similar to the CONTOUR command.
%	CONTOURF(Z), CONTOURF(X,Y,Z), CONTOURF(Z,N),
%	CONTOURF(Z,V) and CONTOURF(X,Y,Z,V) are valid options.
%	Also allows  CONTOURF(...,EC) where EC is the edgecolor of 
%	patches (contour lines); EC should be a string such as
%	'r','g','b','y','c','m','w','k', or 'none'.
%	[C,H] = CONTOURF(...) returns contour matrix C and
%	handles H of patches used in filling between contours.

%  For correct results needs auxillary program ISINPOLY.M

%  Copyright (c) 1995 by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	9/2/94, 10/25/94

%  Revised 12/01/94 (bug found by Dr. Phil Morgan,
%  morgan@ml.csiro.au)

 % Defaults and parameters ......................................
edgecolordflt = 'k';    % Edge color of patches

 % Check if auxillary file ISINPOLY around
ishere = exist('isinpoly');

 % Handle input ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
if nargin < 1, error('Not enough input arguments.'), end
isxy = 0;
if nargin>2
  if any(size(arg1)==1)&any(size(arg2)==1), isxy = 1; end
end
if isxy          % If vectors x and y are input
  x = arg1; y = arg2; z = arg3;
else             % The first argument is matrix  z
  z = arg1;
  [ly,lx] = size(z);
  x = 1:lx; y = 1:ly;
end

 % Get edgecolor argument if input .........................
last_arg = []; edgecolor = '';
if nargin>1, last_arg = eval(['arg' num2str(nargin)]); end
is = isstr(last_arg);
if is
  last_arg = last_arg(last_arg>='a');
  if last_arg~=[], edgecolor = last_arg; end
end
if edgecolor=='',
  edgecolor = edgecolordflt;
else
  nargin = nargin-1;
end

 % Sizes and limits ........................................
lx = length(x); ly = length(y);
xmin = min(x);  xmax = max(x);
ymin = min(y);  ymax = max(y);

 % Pass arguments to the CONTOUR program ...................
arguments = 'arg1';
for jj = 2:nargin
  arguments = [arguments ',arg' num2str(jj)];
end
eval(['[cc,hl] = contour(' arguments ');']);

 % Check all contours for "open/closed" ^^^^^^^^^^^^^^^^^^^^^^^^^
lcc = length(cc);
jj = 1; jc = 1;   % Initialize
while jj<lcc      % Get beginnings and ends of all contours
  lc = cc(2,jj);
  num = jj+(1:lc);
  xc = cc(1,num);
  yc = cc(2,num);
  nb(jc) = jj+1;
  ne(jc) = jj+lc;
  open(jc) = any(xc==xmin|xc==xmax|yc==ymin|yc==ymax);
  if open(jc)
    xe = [xe; xc(1) xc(lc)];
    ye = [ye; yc(1) yc(lc)];
  end
  zc(jc) = cc(1,jj);  % Level
  % Min and max
  cmin(jc,:) = [min(xc) min(yc)];
  cmax(jc,:) = [max(xc) max(yc)];
  jj = jj+lc+1;
  jc = jc+1;
end
fndo = find(open);
noopen = 0;

if fndo==[]   % If no open contours
  noopen = 1;
  open = [open 1];
  fndo = length(open);
  nb = [nb 2]; ne = [ne 1];
  zc = [zc z(1,1)];
  xe = [xmin xmin];
  ye = [ymin ymin]; 
end
open = cumsum(open).*open;
[zc,ind] = sort(zc);
open = open(ind);
nb = nb(ind); ne = ne(ind);
fndo = find(open);
xe = xe(open(fndo),:);
ye = ye(open(fndo),:);

ncont = length(open);
fnd = [1 find(diff(zc))+1];
levels = zeros(1,ncont);
levels(fnd) = ones(size(fnd));
levels = cumsum(levels);
nlevel = max(levels)+1;       % Nmb. of different levels

 % Sort open ends by apc (along-perimeter coordinate) ..........
coordp = [xmin xmax xmax xmin; ymin ymin ymax ymax];
apccorn = [xmin+ymin xmax+ymin xmax+ymax 2*xmax-xmin+ymax];
coordp = [coordp [xe(:,1)' xe(:,2)'; ye(:,1)' ye(:,2)']];
apc = (xe==xmin)|(ye==ymax);
lapc = 2*(xmax+ymax);
apc = (lapc-xe-ye).*apc+(xe+ye).*(~apc);
lapc = size(apc,1);
apc = [apccorn apc(:,1)' apc(:,2)'];
bore = [zeros(1,4) ones(1,lapc) 2*ones(1,lapc)];
napc = [zeros(1,4) fndo fndo];
[apc,ind] = sort(apc);
napc = napc(ind);                   % # of contour
fndc = min(find(napc));
napc = [napc napc(1:fndc)];
bore = bore(ind);                   % Beginning or end
bore = [bore bore(1:fndc)];
coordp = coordp(:,ind);
coordp = [coordp coordp(:,1:fndc)]; % Coordinates of boundary pts
lapc = length(napc);


 % Calculate the coordinates of "open" patches ^^^^^^^^^^^^^^^^^^^
newplot;
p = zeros(nlevel,1);  % Initialize patches handles
jp = 1;
intv = zeros(1,lapc); % Along-perimeter intervals (to be covered)
intv(1) = 1;
fnd = find(napc);
jo = 0;

 % While not all the boundaries is covered ``````````````````````1
while ~jo&fnd~=[]
  if noopen, jo=1; end
  fndc = fnd(1);
  intv(fndc) = 1;
  ccoord = [];
  clevel = [];
  isopen = 1;
  pointsp = [];

  % Continue a contour until it is closed `````````````````` 2
  while isopen
    % Start with beginning of a contour ........
    nc = napc(fndc);            % # of current contour
    clevel = [clevel nc];
    fndc1 = find(napc(1:lapc-1)==nc);
    pointsp = [pointsp fndc1];
    fndc1 = fndc1(fndc1~=fndc); % The other end of the contour
    numc = nb(nc):ne(nc);
    if bore(fndc)==2, numc = fliplr(numc); end
    ccoord = [ccoord cc(:,numc)];

    % Along the perimeter .....................
    fndc = fndc1+(1:min(find(napc(fndc1+1:lapc))));
    ccoord = [ccoord coordp(:,fndc)];
    intv(fndc) = ones(size(fndc));
    fndc = max(fndc);   % Last point
    isopen = ~(any(pointsp==fndc)|fndc==lapc);
  end  % End one open contour '''''''''''''''''''''''''''''' 2

  % Determine which height interval is surrounded by a contour
  ismore = 0;
  zin = zc(clevel);

  if min(zin)<max(zin)  % Easy if between 2 different levels

    ismore = 1;

  elseif ishere % If only 1 level find a grid point and compare

    % Find 4 grid pts. surrounding the first point of a contour
    fndc = max([max(find(x<=ccoord(1,1))) 1]);   % x
    fndc = [fndc fndc+1]-(fndc>=lx);
    xsq = x(fndc);
    fndc = max([max(find(y<=ccoord(2,1))) 1]);   % y
    fndc = [fndc fndc+1]-(fndc>=ly);
    ysq = y(fndc);
    xsq = xsq([1 2 2 1]);         % Make a rectangle
    ysq = ysq([1 1 2 2]);
    is = isinpoly(xsq,ysq,ccoord(1,:),ccoord(2,:));  % Is inside
    fndc  = find(is~=.5);          % Discard pts. on the contour
    if fndc~=[], fndc = fndc(1);
    else, fndc = 1; end
    is  = is(fndc);
    nx = find(xsq(fndc)==x);
    ny = find(ysq(fndc)==y);
    zis = z(ny,nx);
    ismore = (zis>zin(1)&is)|(zis<zin(1)&~is);
  end

  % Create a patch ...................................
  p(jp) = patch('xdata',ccoord(1,:),'ydata',ccoord(2,:));
  ccol = levels(min(clevel))+ismore;
  set(p(jp),'cdata',ccol,'facecolor','flat')
  set(p(jp),'edgecolor',edgecolor)
  jp = jp+1;
  fnd = min(find(~intv&napc));
end  % End patchs for "open" contours''''''''''''''''''''''''''' 1


 % Now create patchs for closed contours ^^^^^^^^^^^^^^^^^^^^^^^^
fnd = find(open);
zopenmin = min(zc(fnd));
zopenmax = max(zc(fnd));
out = zc<zopenmin|zc>zopenmax;

 % Find which contours are inside which ...............
fnd = find(~open&~out);
lfnd = length(fnd);
ind = ones(lfnd,1);
isin = cmax(fnd,ind);
isin = isin<isin';
isin = isin&(cmax(fnd,2*ind)<cmax(fnd,2*ind)');
isin = isin&(cmin(fnd,2*ind)>cmin(fnd,2*ind)');
isin = isin&(cmin(fnd,ind)>cmin(fnd,ind)');
[isin,ind] = sort(-sum(isin));
if fnd==[], ind=[]; end

num = 1:min(find(~out))-1;
nc = max(find(~out))+1;
num = [fnd(ind) fliplr(num)];
ismore = zeros(size(num));
num = [num nc:ncont];
ismore = [ismore ones(size(nc:ncont))];

for jj = 1:length(num)     % Make all "closed" patchs `````````` 1
  nc = num(jj);
  numc = nb(nc):ne(nc);
  ccoord = cc(:,numc);

  % Find points inside or outside ......................
  if ~out(nc)&ishere
    % Find 4 grid pts. surrounding the first point of a contour
    fndc = max([max(find(x<=ccoord(1,1))) 1]);    % x
    fndc = [fndc fndc+1]-(fndc>=lx);
    xsq = x(fndc);
    fndc = max([max(find(y<=ccoord(2,1))) 1]);    % y
    fndc = [fndc fndc+1]-(fndc>=ly);
    ysq = y(fndc);
    xsq = xsq([1 2 2 1]);          % Make a rectangle
    ysq = ysq([1 1 2 2]);
    is = isinpoly(xsq,ysq,ccoord(1,:),ccoord(2,:));  % Is inside
    fndc  = find(is~=.5);          % Discard pts on the contours
    if fndc~=[], fndc = fndc(1);
    else, fndc = 1; end
    is  = is(fndc);
    nx = find(xsq(fndc)==x);
    ny = find(ysq(fndc)==y);
    zis = z(ny,nx);
    ismore(jj) = (zis>zc(nc)&is)|(zis<zc(nc)&~is);
  end

  % Create a patch itself ..............................     
  p(jp) = patch('xdata',ccoord(1,:),'ydata',ccoord(2,:));
  ccol = levels(nc)+ismore(jj);
  set(p(jp),'cdata',ccol,'facecolor','flat')
  set(p(jp),'edgecolor',edgecolor)
  jp = jp+1;
end  % End "closed" patches '''''''''''''''''''''''''''''''''''' 1

axis([xmin xmax ymin ymax]);


 % Output ..............................................
if nargout > 0
  cout = cc;
  hp = p(find(p));
end

