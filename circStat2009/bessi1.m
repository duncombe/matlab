function I1 = bessi1(x)

% I1 = bessi1(x)
%     Bessel function for p = 1
%
%     Reference:
%       Statistical analysis of circular data, Fisher, equations
%           3.37, 3.39, 3.40; pg. 50
%
% Circular Statistics Toolbox for Matlab

% By Marc J. Velasco, 2009
% velasco@ccs.fau.edu
% Distributed under Open Source BSD License

I1 = zeros(size(x));
y   = zeros(size(x));
ax = abs(x);
less = find(ax < 3.75);
grtr = find(ax >= 3.75);

if ( ~isempty(less) )			% ax(i) < 3.75 
   y(less) = x(less) / 3.75;
   y(less) = y(less).*y(less);
   I1(less) = ax(less).*(0.5+y(less).*(0.87890594+y(less).*(0.51498869 ...
                            +y(less).*(0.15084934 +y(less).*(0.2658733e-1 ...
                            +y(less).*(0.301532e-2+y(less).*0.32411e-3))))));
end

if ( ~isempty(grtr) )			% ax(i) >= 3.75 
   y(grtr)=3.75./ax(grtr);
   I1(grtr) = 0.2282967e-1+y(grtr).*(-0.2895312e-1+y(grtr).*(0.1787654e-1 ...
                           -y(grtr).*0.420059e-2));
   I1(grtr) = 0.39894228+y(grtr).*(-0.3988024e-1+y(grtr).*(-0.362018e-2 ...
                         +y(grtr).*(0.163801e-2+y(grtr).*(-0.1031555e-1 ...
                         +y(grtr).*I1(grtr)))));
   I1(grtr) = I1(grtr) .* (exp(ax(grtr))./sqrt(ax(grtr)));
end

neg = find(x < 0);
if ( ~isempty(neg) )
   I1(neg) = -I1(neg);
end

