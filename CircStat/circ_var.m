function [S2 s2] = circ_var(alpha, w, d, dim)
% s = circ_var(alpha, w, d, dim)
%   Computes circular variance for circular data 
%   (equ. 26.17/18, Zar).   
%
%   Input:
%     alpha	sample of angles in radians
%     [w		number of incidences in case of binned angle data]
%     [d    spacing of bin centers for binned data, if supplied 
%           correction factor is used to correct for bias in 
%           estimation of r]
%     [dim  compute along this dimension, default is 1]
%
%     If dim argument is specified, all other optional arguments can be
%     left empty: circ_var(alpha, [], [], dim)
%
%   Output:
%     S2     circular variance 1-r (units are radians^2)
%     s2     angular variance 2*(1-r) (units are radians^2)
%
% PHB 6/7/2008
%
% References:
%   Statistical analysis of circular data, N.I. Fisher
%   Topics in circular statistics, S.R. Jammalamadaka et al. 
%   Biostatistical Analysis, J. H. Zar
%
% Circular Statistics Toolbox for Matlab

% By Philipp Berens, 2009
% berens@tuebingen.mpg.de - www.kyb.mpg.de/~berens/circStat.html

if nargin < 4
  dim = 1;
end

if nargin < 3 || isempty(d)
  % per default do not apply correct for binned data
  d = 0;
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

% compute mean resultant vector length
r = circ_r(alpha,w,d,dim);

% apply transformation to var
S2 = 1 - r;
s2 = 2 * S2;
%
% Zar also has the variance measure, s0 = -2 log r 
