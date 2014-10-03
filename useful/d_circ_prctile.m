function Y = d_circ_prctile(varargin)
%D_CIRC_MEAN - circular percentiles in degrees


if nargin<1,
	error('no data');
end;

x = deg2rad(varargin{1});

Y = rad2deg(circ_mean(x,varargin{2:end}));




return;

