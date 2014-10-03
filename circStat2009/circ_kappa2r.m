function r = circ_kappa2r(kappa, p)
% r = circ_kappa2r(kappa, [p])
%   Computes the mean resultant length for a von Mises
%   distribution with concentration parameter kappa.  
%
%   See also circ_r2kappa for the 'inverse' function (for case p==1)
%
%   Input:
%     kappa     concentration parameter of a von Mises distribution
%     [p        Bessel function parameter, default is 1]
%
%   Output:
%     r         mean resultant vector length
%
%   References:
%     Statistical analysis of circular data, Fisher, equation 3.36
%
%   Notes:
%     uses bessi0, bessi1
%     subscript p is valid for p=1,2,3,...
%     uses Ap(k) = Ip(k)/I0(k) (3.36)
%     uses global variable APTABLE
%
% Circular Statistics Toolbox for Matlab

% By Marc J. Velasco, 2009
% velasco@ccs.fau.edu
% Distributed under Open Source BSD License


r = [];

global APTABLE; % [ kappa p alpha(kappa)]
if isempty(APTABLE)
    APTABLE = [0 1 0];
end
if nargin < 2
    p = 1;
end


rindex = (APTABLE(:,1) == kappa) & (APTABLE(:,2) == p);

% if the value has already been computed
if sum(rindex)
    % Table lookup
    r = APTABLE(rindex, 3);

else
    % calculate
    if p == 1
        r = bessi1(kappa)./bessi0(kappa);
    elseif p >= 2
        r = bessip(kappa, p)./bessi0(kappa);
    end
    % add value to table
    APTABLE(end+1,:) = [kappa, p, r];
end



















