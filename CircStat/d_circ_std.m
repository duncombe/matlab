function [s s0]=d_circ_std(alpha, w, d, dim)
%D_CIRC_STD - circular std in degrees
%
% see circ_std
% 

if nargin<1,
	error('no data');
end;
if nargin<2 || isempty(w), w = ones(size(alpha)); end;
if nargin<3 || isempty(d), d = 0; end;
if nargin<4, dim=1; end;

alpha=deg2rad(alpha);

[s,s0]=circ_std(alpha,w,d,dim);

s=rad2deg(s);
s0=rad2deg(s0);

return;

