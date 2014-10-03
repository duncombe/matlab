function [mp cbar sbar] = circ_moment(alpha, w, p)

% [mp cbar sbar] = circ_moment(alpha, w, p)
%   Calculates the complex p-th moment of the angular data in angle.
%
%   Input:
%     alpha     sample of angles
%     [w        weightings in case of binned angle data]
%     [p        p-th moment to be computed, default is p=1]
%
%   Output:
%     mp        complex moment
%     cbar      real part
%     sbar      imaginary part
%
%
%   References:
%     Statistical analysis of circular data, Fisher, p. 33, Eq. 2.14-2.15
%
% Circular Statistics Toolbox for Matlab

% By Marc J. Velasco, 2009
% velasco@ccs.fau.edu
% Distributed under Open Source BSD License


alpha = alpha(:);

if nargin < 2
  w = ones(size(alpha));
else 
  w = w(:);
end

if nargin < 3
    p = 1;
end

n = length(alpha);
cbar = sum(cos(p*alpha'*w))/n;
sbar = sum(sin(p*alpha'*w))/n;
mp = cbar + i*sbar;
