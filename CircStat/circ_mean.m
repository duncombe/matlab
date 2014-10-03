function [mu ul ll] = circ_mean(alpha, w, dim)
%
% mu = circ_mean(alpha, w)
%   Computes the mean direction for circular data.
%
%   Input:
%     alpha	sample of angles in radians
%     [w		weightings in case of binned angle data]
%     [dim  compute along this dimension, default is 1]
%
%     If dim argument is specified, all other optional arguments can be
%     left empty: circ_mean(alpha, [], dim)
%
%   Output:
%     mu		mean direction
%     ul    upper 95% confidence limit
%     ll    lower 95% confidence limit 
%
% PHB 7/6/2008
%
% References:
%   Statistical analysis of circular data, N. I. Fisher
%   Topics in circular statistics, S. R. Jammalamadaka et al. 
%   Biostatistical Analysis, J. H. Zar
%
% Circular Statistics Toolbox for Matlab

% By Philipp Berens, 2009
% berens@tuebingen.mpg.de - www.kyb.mpg.de/~berens/circStat.html

% This function does not do what is expected. If size(alpha) is
% [1,n] then the expectation is 1 mean of n samples, not n means
% of 1 sample each. Sure, if dim is specified then go ahead, use
% what is requested, otherwise use the expected value of dim. 
if nargin < 3
  if length(size(alpha)==2),
	[m,n]=size(alpha);
	if m==1, dim=2; else dim=1; end;
  else
  	dim = 1;
  end
end

if nargin < 2 || isempty(w)
  % if no specific weighting has been specified
  % assume no binning has taken place
	w = ones(size(alpha));
else
  if size(w,2) ~= size(alpha,2) || size(w,1) ~= size(alpha,1) 
    error('Input dimensions do not match');
  end 
end

% compute weighted sum of cos and sin of angles
r = sum(w.*exp(1i*alpha),dim);

% obtain mean by
mu = angle(r);

% confidence limits if desired
if nargout > 1
  t = circ_confmean(alpha,0.05,w,[],dim);
  ul = mu + t;
  ll = mu - t;
end
