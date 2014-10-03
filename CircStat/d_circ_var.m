function [S s]=d_circ_std(alpha, varargin)
% 
%D_CIRC_VAR - variance for circular data in degrees
%
% see circ_std, circ_var
% 

if nargin<1,
	error('no data');
end;
% if nargin<2 || isempty(w), w = ones(size(alpha)); end;
% if nargin<3 || isempty(d), d = 0; end;
% if nargin<4, dim=1; end;

alpha=deg2rad(alpha);

[S,s]=circ_var(alpha, varargin);

rad2deg2=@(x)x.*(180./pi).^2;

S=rad2deg2(S);
s=rad2deg2(s);

return;

