%function [hi,W] = loess2d_irreg(x,t,h,Sx,St,xi,ti)
function [hi] = loess2d_irreg2(x,t,h,Sx,St,xi,ti,xdim)
%Quadratic loess smoother for data sampled irregularly in 2D.
%   The quadratic loess is a "locally-weighted" least-squares fit
%   to a quadratic surface.  Points are downweighted
%   with distance from the point being estimated.  This implentation 
%   downweights with scaled distance, r,like (1-r^3)^3 and doesn't use
%   any data outside the ellipse defined by the span where r=1.)
%   This version returns NaNs for grid points that are outside 
%   the span of all data points.  The "span" widths specify the filtering 
%   properties of the smoother-- the filter half-power points are roughly
%   equivalent to a boxcar filter with width of 0.6*Span.
%
%
%[hi,W] = loess2d_semi_regular2(x,t,h,Sx,St,xi,ti,xdim)
%
%  This version is the same as loess2d_semi_regular, except it 
%    exploits reularity in the space dimension instead of the time 
%    dimension for speeding up the computation.
%  -->If your input data has a longer space dimension, use this version.
%
% Inputs:
%   x=  one of the independent variables for samples
%	(must be same size as h)
%   t=  the other independent variable for samples
%	(must be same size as h)
%   Sx= Smoother span for x diminsion (may be 0; halfpower passband is ~0.6*Sx)
%   St= Smoother span for t diminsion
%   xi= desired grid for x dimension
%   ti= desired grid for t dimension
%   h=  2D matrix of the data corresponding to (x,t)
%   xdim= the dimension of h that corresponds to the x coordinate (1 or 2)
%
% Outputs:
%   hi= estimates on new grid
%   W (disabled)=  Weight matrix giving the linear combination 
%       of the original data that maps the original data
%       to the gridded data (i.e., W*h=hi)
%

% Plan was to add this, but it seems this could be done by controlling
%  number of data points required for fit.
% New "option" (must edit code):
%   If variable badflag is set to 1, the matrix inversion in the 
%   least-squares fit will be checked.  If the matrix inversion is
%   ill conditioned (as defined by 
%
if 1==2%test values
x=lon;
t=yday;
%h=h;
Sx=20;
St=7;

xi=min(x)+5:10:max(x)-5;
ti=min(t)+5:5:max(t)-5;
end%if test

% Make sure inpuut data are vectors
x=x(:);t=t(:);h=h(:);


%Make sure x,t, and h are the same size
if ~isequal(size(h),size(x)) | ~isequal(size(h),size(t))
  error('Input data and coordinate matrices must be the same size(loess2d_semi_regular.m)')
end

if xdim==1
  [numx,numt]=size(h);
elseif xdim==2
  % Force x to be in 1st dimension
  h=h';
  x=x';
  t=t';
  [numx,numt]=size(h);  
else
  error('Input xdim must be either 1 or 2 (loess2d_semi_regular.m)')
end

% Drop nondata
ff=find(isnan(h));
x(ff)=[];
t(ff)=[];
h(ff)=[];



% preallocate output
hi=NaN*ones(length(xi),length(ti));
%W=zeros(length(xi).*length(ti),length(x));



nn=0;
% loop over index of input coordinates
for n=1:length(xi)

 %Take a subset of lons to limit search radius
 xsind=find(abs(x-xi(n))<=1.5.*Sx);
 xs=x(xsind);
 hs=h(xsind);
 ts=t(xsind);
 xsind;

  for m=1:length(ti)
  nn=nn+1;%index into gridded dim of weight matrix
  
  
    xpt=xi(n);
    tpt=ti(m);

    % Determine distances from gridpoint
    xdist=xpt-xs;
    tdist=tpt-ts;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % For specified spans:
    % compute scale-weighted distance
    if Sx==0
    r = sqrt((tdist./St).^2);%display('this part');
    else
    r = sqrt((xdist./Sx).^2)+sqrt((tdist./St).^2);
    end
    
    % Select data with r<=1
    ffu=find(r<=1);
    ffunan=find(isnan(hs(ffu)));
    ffu(ffunan)=[];
    r=r(ffu);
    xdist=xdist(ffu);
    tdist=tdist(ffu);
    xvals=xs(ffu);
    tvals=ts(ffu);
    hvals=hs(ffu);
    
    %Make xdist, tdist, and hvals vectors for least sq fit
    xdist=xdist(:);tdist=tdist(:);hvals=hvals(:);

  
    % compute local weighted least squares quadratic estimate (loess)
    
   if length(ffu)>8
    
    % Make matrix of quadratics for fit
    %A = [ones(size(xvals)) xvals xvals.^2 ones(size(tvals)) tvals tvals.^2];
    if Sx==0
    A = [ones(size(tdist)) tdist tdist.^2];
    else
    A = [ones(size(xdist)) xdist xdist.^2 tdist tdist.^2 xdist.*tdist];
    end
    
    % 'Tricubic' weighting function
    w = (1-r.^3).^3;
    
    
    %According to Larry O'Neill's code, this is more efficent:
    %w = 1 - r.^3;
    %w = w.*w.*w;
    
    w=diag(w);
    % Weight data pts:
    Ap = w*A;
    hp = w*hvals;
    
    % c is the vector of coefficients of the quadratic fit:
    % fit = c(1) + c(2)*x + c(3)*x^2
    
    % solve least-squares fit of Ap*c = hp
    %c = Ap\hp;
    R=inv(Ap'*Ap)*Ap';
    c = R*hp;
    weight_i=R*w;
%    W(nn,ffu)=weight_i(1,:);%This will need modification if all data are not searched at once
    
    % Evaluate fitted value:
    % Formally, hi = [1 xdist xdist.^2 tdist tdist.^2 xdist.*tdist]*c, 
    % but since we moved origin to grid pt the estimate is just c(1)
    hi(n,m) = c(1);

  end
  
end
end
