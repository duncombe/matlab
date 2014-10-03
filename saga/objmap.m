function [xi,yi,zi,em] = objmap(xb,yb,zb,xi,yi,fun,p,err,n)
% OBJMAP Objective mapping interpolation.
%	[ZI,EM] = OBJMAP(...,[LX LY],E) Specifies
%	lengthscales LX, LY and relative error E
%	(0 < E < 1) for "classical" gaussian correlation 
%	function 
%	C(x,y) = E*D(x,y)+(1-E)*exp(-(x/LX)^2-(y/LY)^2),
%	where D - Dirac delta function.
%
%	OBJMAP(...,'FUN',P,E)  Allows to specify the
%	correlation function 'FUN' as a string (expression
%	or function name) depending on x, y, r(r^2=x^2+y^2)
%	and parameters (such as lengthscales) in the vector
%	P.
%
%	For large number of known points it divides
%	the domain into subdomains using the adaptive
%	QUADTREE procedure.
%
%	OBJMAP(...,[LX LY],E,OPT) or 
%	OBJMAP(...,'FUN',P,E,OPT) also allows OPT vector
%	argument to specify several parameters of quadtree
%	division:
%	OPT = [NB ND NMAX PB VERBOSE], where
%	NB   - max. number of points in one block
%	ND   - "depopulation" threshold - if number of
%	  points in a block is less than ND is is
%	  considered "depopulated" and its own "secondary"
%	  neighbours are used for interpolation.
%	NMAX - max. number of points below which domain
%	  is not divided into blocks.
%	PB - X,Y scales as part of average block sizes,
%	VERBOSE - verbosity (1 - display some values and
%	  number of processed blocks.
%	Default values [NB ND NMAX PB V] = [32 8 500 1/3 1].
%
%	For more information about quadtree division and
%	options see TREEINFO and TREEDEMO.
%
%	XI can be a row vector, in which case it specifies
%	a matrix with constant columns. Similarly, YI can
%	be a column vector and it specifies a matrix with 
%	constant rows.
%	[XI,YI,ZI] = OBJMAP(...) also returns matrices
%	XI, YI formed from input vectors XI,YI in the way
%	described above.
%
%	See also GRIDDATA, MINCURVI, KRIGING, QUADTREE.

%  Copyright (c) 1995 by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/25/95, 05/31/95

 % Defaults and parameters .............................
n_dflt = [32 8];  % Default for max. and min number of 
                  %  points in elementary block
nmax = 500;       % Default for max number of points
                  %  to be treated as one block
part_blk = 1/3;   % Default for x and y lengthscales
                  %  as parts of average block sizes
                  % when LY, LY not specified.
verbose = 1;      % Verbosity (shows some parameters and 
                  % number of blocks processed).


 % Handle input ........................................
if nargin==0, help objmap, return, end
if nargin==1
 if strcmp(xb,'info'), more on, type mapinfo, more off, return, end
end
if nargin<5
  error('  Not enough input arguments')
end

 % Insert defaults for missing arguments
if nargin<9, n = 0; end
if nargin<8, err = 0; end
if nargin<7, p = 0; end
if nargin<6, fun = 0; end
is_call = isstr(fun);  % If function name or expression

if is_call   % Function name or expression
  call = callchk(fun,'r');
else         % Lengthscales for gaussian form
  n = err;
  err = p;
  sc = fun;
  call = '';
end

if ~length(sc), sc = [0 0]; end
if length(sc)==1, sc = sc([1 1]); end
sc = max(sc,0); end

 % Options (vector n)
if n==0 | n==[], n = n_dflt; end
len = length(n);
if len>=3, nmax = n(3); end
if len>=4, part_blk = n(4); end
if len>=5, verbose = n(5); end

 % Relative error:
if err==[], err=0; end  % Not empty
err = min(err,1);       % Not larger than 1

 % If error map is needed
is_err = (nargout==2) | (nargout==4);
if is_err, em = zeros(size(xi)); end

 % Check input coordinates and make matrices XI, YI
 % if necessary
[msg,xb,yb,zb,xi,yi] = xyzchk(xb,yb,zb,xi,yi);
if length(msg)>0, error(msg); end


 % Calculate quadtree divison into blocks and
 % related objects
[xx,yy,s,nb,lb,ind,bx,by,Na,Lx,Ly,Sp,npb] = ...
           mkblocks(xb,yb,xi,yi,n(1),nmax);

if any(~sc) | sc==[]
  if lb==1, part_blk = part_blk/sqrt(nb/n(1)); end
  sc = max(sc,[mean(diff(Lx')), mean(diff(Ly'))]*part_blk);
end

 % Process basis values vector ZB
szb = size(zb);
is_vec = 0; err_only = 0;
if any(szb==1) | prod(szb)==nb
  zb = zb(:);
elseif min(szb)>1
  if szb(2)==nb, zb = zb'; end
  is_vec = 1;
elseif zb==[]
  err_only = 1;
end
szb = size(zb);
oz = ones(1,szb(2));

 % Mask for underpopulated blocks .......
isup = npb<n(2);

 % Remove mean and trend ................
for jj=1:szb(2)
  [zb(:,jj),rc,gc] = detrend2(xb,yb,zb(:,jj));
  r0(jj,:) = rc;
  g(jj,:) = gc;
end

 % Initialize output and weights
zi = zeros(prod(size(xi)),szb(2));
wi = zeros(prod(size(xi)),1);
er1 = 1-err;

 % Tell some parameters and number of blocks ......
if verbose
  fprintf('\n')
  if ~is_call
    fprintf('Scales: %g, %g\n',sc(1),sc(2))
  end
  fprintf('Relative error: %g \n',err) 
  fprintf('Number of blocks: %g\nProcessing:\n',lb) 
end

 % Process each block sequentially **********************
for jj=1:lb   % Begin blocks ```````````````````````````0

  [ibp,iip,w,x,y] = ptsinblk(jj,xx,yy,Na,Sp,...
                             Lx,Ly,nb,isup);
  ob = ones(size(ibp));
  oi = ones(size(iip));

  % Green's function (covariance) matrix for basis points
  if is_call
    r = sqrt(x.^2+y.^2);
    eval(call);
  else
    r = exp(-(x/sc(1)).^2-(y/sc(2)).^2);
  end
  r = er1*r+err*eye(size(r));    % Add errors
  A = r;
  if ~err_only, v = r\zb(ibp,:); end

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
    x = xx(i_ch,ob)-xx(ibp,och)';
    y = yy(i_ch,ob)-yy(ibp,och)';

    % Calculate covariance matrix
    if is_call
      r = sqrt(x.^2+y.^2);
      eval(call);
    else
      r = exp(-(x/sc(1)).^2-(y/sc(2)).^2);
    end
    r = r*er1;

    % Interpolation itself ...................
    i_ch = i_ch-nb;
    if ~err_only
      zi(i_ch,:) = zi(i_ch,:)+w_ch(:,oz).*(r*v);
    end
    wi(i_ch) = wi(i_ch)+w_ch;

    % Calculate errors
    if is_err & err>0
      r = r';
      em(i_ch) = em(i_ch)+w_ch./(1-sum(r.*(A\r))/er1)';
    end

  end

  % Verbose mode, tell that a block is processed
  if verbose, fprintf('%g,',jj); end

end  % End all blocks ''''''''''''''''''''''''''''''''''0

if verbose, fprintf('\n All done.\n'); end

zi = zi./wi(:,oz);     % Divide by weights

sz = size(xi);
wi = reshape(wi,sz(1),sz(2));
if is_err & err>0
  em = wi./em;     % Invert error map
end

 % Put mean and slope back ...............
for jj = 1:szb(2)
  zi(:,jj) = zi(:,jj)+g(jj,1)+(xi(:)-r0(jj,1))*g(jj,2);
  zi(:,jj) = zi(:,jj)+(yi(:)-r0(jj,2))*g(jj,3);
end

 % Reshape if scalar z value
if ~is_vec & ~err_only
  zi = reshape(zi,sz(1),sz(2));
end

 % If XI, YI are not needed
if nargout<=2,  xi = zi; yi = em; end

