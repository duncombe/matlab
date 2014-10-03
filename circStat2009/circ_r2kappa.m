function kappa = circ_r2kappa(r)
% kappa = circ_r2kappa(r)
%   Computes concentration parameter kappa of a von Mises distribution from
%   the mean resultant vector length.
%
%   Input:
%     r       mean resultant vector length, 0<=r<=1
%
%   Output:
%     kappa   ML estimate of the von Mises concentration parameter
%
%   Reference:
%     Statistical analysis of circular data, Fisher, equation 17.2.5
%     Batschelet, 1981, Appendix, Table B
%
%   Notes:
%     Bessel1(kappa)/Bessel0(kappa) = r
%     Using the table lookup, estimates of kappa are reasonably accurate 
%     to around .01.  The largest Kappa returned is 60 (~ infinity as r -> 1).
%
% Circular Statistics Toolbox for Matlab

% By Marc J. Velasco, 2009
% velasco@ccs.fau.edu
% Distributed under Open Source BSD License

mysize = 400;
maxKappa = 60;
mystep = 1/mysize;
R = 0:mystep:1;


kappatable = zeros(1,length(R));
Gamma = 0:(mystep/2):maxKappa;
Amp = bessi1(Gamma)./bessi0(Gamma);
for i = 1:length(R)
    [tmp j] = min(abs(Amp-R(i)));
    kappatable(i)   = Gamma(j(1));
end

kappa = kappatable(round(mysize*r)+1);
