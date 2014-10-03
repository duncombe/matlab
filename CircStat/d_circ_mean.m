function [mu ul ll]=d_circ_mean(alpha, w, dim)
%D_CIRC_MEAN - circular mean in degrees

if nargin<1,
	error('no data');
end;
if nargin<2 || isempty(w), w = ones(size(alpha)); end;

alpha=deg2rad(alpha);

if nargin<3, 
	[mu, ul, ll]=circ_mean(alpha,w);
else
	[mu, ul, ll]=circ_mean(alpha,w,dim);
end;

mu=rad2deg(mu);
ul=rad2deg(ul);
ll=rad2deg(ll);

return;

