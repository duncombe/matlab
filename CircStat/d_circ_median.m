function med = d_circ_median(alpha, dim)
%D_CIRC_MEAN - circular median in degrees


if nargin<1,
	error('no data');
end;

alpha=deg2rad(alpha);

% not so f.....g simple...
if nargin<2, 
	med = circ_median(alpha);
else
	med = circ_median(alpha,dim); 
end

med=rad2deg(med);

return;

