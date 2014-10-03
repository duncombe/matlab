function y = minfilt1(x,n,blksz,DIM)
%MEDFILT1  One dimensional minimum filter.
%	Y = MEDFILT1(X,N) returns the output of the order N, one dimensional
%	minimum filtering of X.  Y is the same size as X; for the edge points,
% 	 X is extended by n/2 of the left and right values of X.
%
%	If you do not specify N, MEDFILT1 uses a default of N = 3.
%	For N odd, Y(k) is the median of X( k-(N-1)/2 : k+(N-1)/2 ).
%	For N even, Y(k) is the median of X( k-N/2 : k+N/2-1 ).
%
%	Y = MEDFILT1(X,N,BLKSZ) uses a for-loop to compute BLKSZ ("block size") 
%	output samples at a time.  Use this option with BLKSZ << LENGTH(X) if 
%	you are low on memory (MEDFILT1 uses a working matrix of size
%	N x BLKSZ).  By default, BLKSZ == LENGTH(X); this is the fastest
%	execution if you have the memory for it.
%
%	For matrices and N-D arrays, Y = MEDFILT1(X,N,[],DIM) or 
%	Y = MEDFILT1(X,N,BLKSZ,DIM) operates along the dimension DIM.
% 
%
%	See also MEDIAN, FILTER, SGOLAYFILT, and MEDFILT2 in the Image
%	Processing Toolbox.
% 	See also MAXFILT1 and MINFILT1 in the Useful Toolbox!
% 

%	Author(s): L. Shure and T. Krauss, 8-3-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.1 $  $Date: 2012-06-18 01:02:21 $
% 	Mods by CM Duncombe Rae
% 
%PROGRAM MODS:
%  2000-03-24
% 	Based on Mathworks medfilt1, but extends the endpoints instead of making them zero.
%  2011/01/20 
% 	updated to Matlab 2008b
%  2012-06-17 
% 	So what's special about the median? Might also have maximum,
% 	minimum. Make it so!
%

% Validate number of input arguments
error(nargchk(1,4,nargin,'struct'));
if nargin < 2, n = []; end
if nargin < 3, blksz = []; end
if nargin < 4, DIM = []; end

% Check if the input arguments are valid
if isempty(n)
  n = 3;
end

if ~isempty(DIM) && DIM > ndims(x)
	error(generatemsgid('InvalidDimensions'),'Dimension specified exceeds the dimensions of X.')
end

% Reshape x into the right dimension.
if isempty(DIM)
	% Work along the first non-singleton dimension
	[x, nshifts] = shiftdim(x);
else
	% Put DIM in the first (row) dimension (this matches the order 
	% that the built-in filter function uses)
	perm = [DIM,1:DIM-1,DIM+1:ndims(x)];
	x = permute(x,perm);
end

% Verify that the block size is valid.
siz = size(x);
if isempty(blksz),
	blksz = siz(1); % siz(1) is the number of rows of x (default)
else
	blksz = blksz(:);
end

% Initialize y with the correct dimension
y = zeros(siz); 

% Call medfilt1D (vector)
for i = 1:prod(siz(2:end)),
	y(:,i) = medfilt1D(x(:,i),n,blksz);
end

% Convert y to the original shape of x
if isempty(DIM)
	y = shiftdim(y, -nshifts);
else
	y = ipermute(y,perm);
end


%-------------------------------------------------------------------
%                       Local Function
%-------------------------------------------------------------------
function y = medfilt1D(x,n,blksz)
%MEDFILT1D  One dimensional median filter.
%
% Inputs:
%   x     - vector
%   n     - order of the filter
%   blksz - block size

nx = length(x);
if rem(n,2)~=1    % n even
    m = n/2;
else
    m = (n-1)/2;
end
% Instead of extending the ends with zero, flip the tailing bits out
X = [flipud(x(1:m,1)); x; flipud(x((end-m+1):end,1))];
y = zeros(nx,1);

% Work in chunks to save memory
indr = (0:n-1)';
indc = 1:nx;
for i=1:blksz:nx
    ind = indc(ones(1,n),i:min(i+blksz-1,nx)) + ...
          indr(:,ones(1,min(i+blksz-1,nx)-i+1));
    xx = reshape(X(ind),n,min(i+blksz-1,nx)-i+1);
    y(i:min(i+blksz-1,nx)) = min(xx,[],1);
end
