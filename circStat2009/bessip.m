function Ip = bessip(kappa, p)

% Ip = bessip(kappa, p)
%     Generic version of Bessel function for arbitrary p
%
%     Reference:
%       Statistical analysis of circular data, Fisher, equations
%           3.37, 3.39, 3.40; pg. 50
%
% Circular Statistics Toolbox for Matlab

% By Marc J. Velasco, 2009
% velasco@ccs.fau.edu
% Distributed under Open Source BSD License

if p == 0
    Ip = bessi0(kappa);
elseif p == 1
    Ip = bessi1(kappa);
elseif p == 2
    Ip = bessi0(kappa) - (2/kappa)*bessi1(kappa);
elseif p == 3
    Ip = bessi1(kappa) - (4/kappa)*bessip(kappa, 2);
elseif p >= 4
    Ip = bessip(kappa, p-2) - ((2*(p-1)/kappa)*bessip(kappa, p-1));
end
