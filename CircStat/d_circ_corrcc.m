function [rho pval]=d_circ_corrcc(alpha1, alpha2)
%D_CIRC_MEAN - circular corr coef in degrees


if nargin<2 , error('no data'); end;

alpha1=deg2rad(alpha1);
alpha2=deg2rad(alpha2);

[rho, pval]=circ_corrcc(alpha1, alpha2);

return;

