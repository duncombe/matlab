function [xi,yi,zi] = mincurvi(xb,yb,zb,xi,yi,n)
% MINCURVI  Interpolation by minimum curvature method.
%	ZI = MINCURVI(X,Y,Z,XI,YI) Interpolates values Z
%	at known at points with coordinates X, Y to
%	values ZI at points with coordinates XI, YI
%	using minimum curvature method.
%
%	For large number of known points it divides
%	the domain into subdomains using the adaptive
%	QUADTREE procedure.
%	MINCURVI(X,Y,Z,XI,YI,[NB ND NMAX]) also allows
%	to specify several parameters of quadtree
%	division:
%	NB   - max. number of points in one block
%	ND   - "depopulation" threshold - if number of
%	  points in a block is less than ND is is
%	  considered "depopulated" and its own "secondary"
%	  neighbours are used for interpolation.
%	NMAX - max. number of points below which domain
%	  is not divided into blocks.
%	Default values [NB ND NMAX] = [32 8 400].
%
%	XI can be a row vector, in which case it specifies
%	a matrix with constant columns. Similarly, YI can
%	be a column vector and it specifies a matrix with 
%	constant rows.
%	[XI,YI,ZI] = MINCURVI(...) also returns matrices
%	XI, YI formed from input vectors XI,YI in the way
%	described above.
%
%	See also GRIDDATA, OBJMAP, QUADTREE.

%	Method used in MINCURVI is similar to that of
%	used in GRIDDATA. However MINCURVI is much more
%	memory-efficient for large number of points and
%	more robust since it uses mean and slope removal
%	(program DETREND2).

%  Copyright (c) 1995 by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/25/95, 09/15/95

 % Defaults and parameters ...............
n_dflt = [32 8]; % Default for max. number of 
                  % points in elementary block and
                  % "depopulation" threshold
nmax = 400;       % Default for max. number of points
                  % not to be divided into blocks
verbose = 1;      % Verbosity (shows number of blocks
                  % processed
is_scale = 1;     % Scale variables

 % Handle input ..........................
if nargin==0, help mincurvi, return, end
if nargin==1
 if strcmp(xb,'info'), more on, type mapinfo, more off, return, end
end
if nargin<5
  error('  Not enough input arguments')
end
if nargin<6,
  n = n_dflt;
end
if n==[], n = n_dflt; end
n = max(n,1);
if length(n)==1, n(2) = ceil(n(1)/4); end
if length(n)>=3, nmax = n(3); end
n = n(:)';
n(1:2) = fliplr(sort(n(1:2)));

 % Check input coordinates and make matrices XI, YI
 % if necessary
[msg,xb,yb,zb,xi,yi] = xyzchk(xb,yb,zb,xi,yi);
if length(msg)>0, error(msg); end

 % Check for coincident points ................
[r,zb] = uniquept([xb(:) yb(:)],zb(:));
xb = r(:,1); yb = r(:,2);

 % Scales ...............
if is_scale
  xsc = max(xb)-min(xb);
  ysc = max(yb)-min(yb);
  xb = xb/xsc; xi = xi/xsc;
  yb = yb/ysc; yi = yi/ysc;
end


 % Calculate quadtree divison into blocks and
 % related objects
[x,y,s,nb,lb,ind,bx,by,Na,Lx,Ly,Sp,npb] = ...
           mkblocks(xb,yb,xi,yi,n(1),nmax);
zb = zb(:);

 % Mask for underpopulated blocks .......
isup = npb<n(2);

 % Remove mean and trend ................
[zb,r0,g] = detrend2(xb,yb,zb);
zsc = max(zb)-min(zb);

 % Quick exit if residual z is 0
if zsc==0
  % Put mean and slope back
  zi = g(1)+(xi-r0(1))*g(2)+(yi-r0(2))*g(3);
  if nargout<=1, xi = zi; end
  return
end
zb = zb/zsc;

 % Initialize output and weights
zi = zeros(size(xi));
wi = zi;

if verbose
  fprintf('Number of blocks: %g\nProcessing:\n',lb) 
end

 % Process each block sequentially *****************
for jj=1:lb

  [ibp,iip,w,Dx,Dy] = ptsinblk(jj,x,y,Na,Sp,...
                             Lx,Ly,nb,isup);
  ob = ones(size(ibp));

  % Green's function matrix for basis points
  r = Dx.^2+Dy.^2;
  mask = find(~r);
  r(mask) = ones(size(mask));
  r = r.*(log(r)-2);
  r(mask) = zeros(size(mask));
  v = r\zb(ibp);

  % Interpolation points ...................
  len = length(iip);
  n_chunk = ceil(len/nmax);
  for j1=1:n_chunk    % Process each chunk
    % Get current chunk
    nn = min(len,j1*nmax);
    i_ch = (j1-1)*nmax+1:nn;
    w_ch = w(i_ch);
    i_ch = iip(i_ch);
    och = ones(size(i_ch));

    Dx = x(i_ch,ob)-x(ibp,och)';
    Dy = y(i_ch,ob)-y(ibp,och)';
    r = Dx.^2+Dy.^2;
    mask = find(~r);
    r(mask) = 2*ones(size(mask));
    r = r.*(log(r)-2);
    r(mask) = zeros(size(mask));

    % Interpolation itself ...................
    i_ch = i_ch-nb;
    zi(i_ch) = zi(i_ch)+w_ch.*(r*v);
    wi(i_ch) = wi(i_ch)+w_ch;
  end

  % Verbose mode, tell tyhe block is processed
  if verbose, fprintf('%g,',jj); end

end
if verbose, fprintf('\n All done.\n'); end

zi = zi./wi;     % Divide by weights

 % Put mean and slope back
zi = zi*zsc;
zi = zi+g(1)+(xi-r0(1))*g(2)+(yi-r0(2))*g(3);

if nargout<=1, xi = zi; end

