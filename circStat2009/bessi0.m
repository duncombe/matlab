function I0 = bessi0(x)

% I0 = bessi0(x)
%     Bessel function for p = 0
%
%     Reference:
%       Statistical analysis of circular data, Fisher, equations
%           3.37, 3.39, 3.40; pg. 50
%
% Circular Statistics Toolbox for Matlab

% By Marc J. Velasco, 2009
% velasco@ccs.fau.edu
% Distributed under Open Source BSD License


I0 = zeros(size(x));
y   = zeros(size(x));
ax = abs(x);
less = find(ax < 3.75);
grtr = find(ax >= 3.75);

if ( ~isempty(less) )			% ax(i) < 3.75 
   y(less) = x(less) / 3.75;
   y(less) = y(less).*y(less);
   I0(less) = 1.0+y(less).*(3.5156229+y(less).*(3.0899424 ...
                  +y(less).*(1.2067492 +y(less).*(0.2659732 ...
                  +y(less).*((0.360768e-1)+y(less).*0.45813e-2)))));
end

if ( ~isempty(grtr) )			% ax(i) >= 3.75 
   y(grtr)=3.75./ax(grtr);
   I0(grtr)= (exp(ax(grtr))./sqrt(ax(grtr))).*(0.39894228 ...
              +y(grtr).*((0.1328592e-1) +y(grtr).*((0.225319e-2) ...
              +y(grtr).*((-0.157565e-2) +y(grtr).*((0.916281e-2) ...
              +y(grtr).*((-0.2057706e-1)+y(grtr).*((0.2635537e-1) ...
              +y(grtr).*((-0.1647633e-1)+y(grtr).*0.392377e-2)))))))); 
end
