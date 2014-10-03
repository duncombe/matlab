function [pval G] = circ_gtest(alpha, idx, w)
%
% [pval, G] = circ_gtest(alpha,w)
%   Computes a multisample test by Stephens for equality of modal
%   vectors with common unknown large dispersion parameter
%
%   H0: each sample has been drawn from the same distribution
%   HA: samples have been drawn from populations with differing modes but
%   common dispersion
%
%   Assumption: Underlying von-Mises distributions
%
%
%   Input:
%     alpha	angles in radians
%     idx   number 1 through n, indicating which sample the data comes from
%     [w		number of incidences in case of binned angle data]

%   Output:
%     pval  p-value 
%     G     value of the G-statistic
%
% PHB 3/16/2009
%
% References:
%  Multi-sample tests for the Fisher distribution for directions, M. A.
%     Stephens, 1969
%  More Multi-sample Tests for the von Mises distribution, G. J. G. Upton, 1976
%
% Circular Statistics Toolbox for Matlab

% By Philipp Berens, 2009
% berens@tuebingen.mpg.de - www.kyb.mpg.de/~berens/circStat.html
% Distributed under Open Source BSD License

if size(alpha,2) > size(alpha,1)
	alpha = alpha';
end

if size(idx,2) > size(idx,1)
	idx = idx';
end

if ~all(size(idx)==size(alpha))
  error('Input dimensions do not match.')
end

if nargin < 3
  w = ones(size(alpha));
else
  if length(alpha)~=length(w)
    error('Input dimensions do not match.')
  end
end

n = sum(w);

u = unique(idx);
s = length(u);
rl = zeros(s,1);
nn = rl;

% compute the single sample resultant vectors and their lengths
for i=1:s
  iu = idx==u(i);
  nn(i) = sum(iu);
  rl(i) = circ_r(alpha(iu),w(iu)) * nn(i);  
end
Z = sum(rl) / n;

% test applicability
if ~all(nn(i)>=10)
  error('Sample size to small. All samples must be >= 10.');
end

if ~all(rl./nn>.55)
  warning('Test criteria not fullfilled. R_i/N_i < .55 for some i.') %#ok<WNTAG>
end

% compute the resultant vector across all samples
W = circ_r(alpha,w);

% compute G
G = (W-Z)/(Z-1)*(n-s)/(s-1);

% compute p-value 
pval = 1-fcdf(G,2*(s-1),2*(n-s));



  
  









