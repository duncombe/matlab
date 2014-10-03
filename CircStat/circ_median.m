function med = circ_median(alpha,dim)
%
% med = circ_median(alpha)
%   Computes the median direction for circular data.
%
%   Input:
%     alpha	sample of angles in radians
%     [dim  compute along this dimension, default is 1, must 
%           be either 1 or 2 for circ_median]
%
%   Output:
%     mu		mean direction
%
%   circ_median can be slow for large datasets
%
% PHB 3/19/2009
%
% References:
%   Biostatistical Analysis, J. H. Zar (26.6)
%
% Circular Statistics Toolbox for Matlab

% By Philipp Berens, 2009
% berens@tuebingen.mpg.de - www.kyb.mpg.de/~berens/circStat.html

%PROGRAM MODS
% 
%  2010/11/09  CMDR
% 	Ensure that slow function circ_dist2 is called only once. 
% 	Use scalar operators unless you need the matrix
% 	operation.
%  2010/12/28 
% 	Merging 2010e release
%  2011-11-09 
% 	Fix bug affecting even data size (was lines 45 and 46 in 2010f,
% 	lines 68 and 69 in this file at this time)
% 

% This function does not do what is expected. If size(alpha) is
% [1,n] then the expectation is 1 mean of n samples, not n means
% of 1 sample each. Sure, if dim is specified then go ahead, use
% what is requested, otherwise use the expected value of dim. 
if nargin < 2
  if length(size(alpha)==2),
	[m,n]=size(alpha);
	if m==1, dim=2; else dim=1; end;
  else
  	dim = 1;
  end
end

M = size(alpha);
med = NaN(M(3-dim),1);
for i=1:M(3-dim)
  if dim == 2
    beta = alpha(i,:).';
  elseif dim ==1
    beta = alpha(:,i);
  else
    error('circ_median only works along first two dimensions')
  end

% bring all data into the first revolution
  beta = mod(beta,2.*pi);
  n = size(beta,1);

  dd = circ_dist2(beta,beta);
  m1 = sum(dd>=0,1);
  m2 = sum(dd<=0,1);

  dm = abs(m1-m2);
  if mod(n,2)==1
    [m idx] = min(dm);
  else
    m = min(dm);
    idx = find(dm==m,2);
  end

  if m > 1
    warning('Ties detected.') %#ok<WNTAG>
  end

  md = circ_mean(beta(idx));

  if abs(circ_dist(circ_mean(beta),md)) > abs(circ_dist(circ_mean(beta),md+pi))
    md = mod(md+pi,2.*pi);
  end
  
  med(i) = md;
end

if dim == 2
  med = med.';
end

return;
