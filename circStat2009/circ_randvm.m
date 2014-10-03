function alpha = circ_randvm(theta, kappa, n)

% [p alpha] = circ_randvm(theta, kappa, n)
%   Simulates n random angles from a von Mises distribution, with preferred 
%   direction thetahat and concentration parameter kappa.
%
%   Input:
%     [theta    preferred direction, default is 0]
%     [kappa    width, default is 1]
%     [n        number of samples, defailt is 10]
%
%   Output:
%     alpha     samples from von Mises distribution
%
%
%   References:
%     Statistical analysis of circular data, Fisher, sec. 3.3.6, p. 49
%
% Circular Statistics Toolbox for Matlab

% By Marc J. Velasco, 2009
% velasco@ccs.fau.edu
% Distributed under Open Source BSD License




if nargin < 3
    n = 10;
end
if nargin < 2
    kappa = 1;
end
if nargin < 1
    theta = 0;
end

% uniform distribution
if kappa < 1e-6
    alpha = 2*pi*rand(n,1);
    return
end

% other cases
a = 1 + sqrt((1+4*kappa.^2));
b = (a - sqrt(2*a))/(2*kappa);
r = (1 + b^2)/(2*b);

alpha = zeros(n,1);
for j = 1:n
    
    while(1)
        u = rand(3,1);
    
        z = cos(pi*u(1));
        f = (1+r*z)/(r+z);
        c = kappa*(r-f);

        if ( u(2) < c * (2-c) || u(2) <= c * exp(1-c))
            break;
        end
    end
    
    if (u(3) > .5)
        alpha(j) = theta + acos(f);
    else
        alpha(j) = theta - acos(f);
    end

    alpha(j) = angle(exp(i*alpha(j)));
end






