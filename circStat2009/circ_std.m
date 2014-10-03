function s = circ_std(alpha, w, d, type)
% s = circ_std(alpha, w, d)
%   Computes circular standard deviation for circular data 
%   (equ. 26.20, Zar).   
%
%   Input:
%     alpha	sample of angles in radians
%     [w		weightings in case of binned angle data]
%     [d    spacing of bin centers for binned data, if supplied 
%           correction factor is used to correct for bias in 
%           estimation of r]
%     [type use any of 26.20 or 26.21 as the defintion for circular
%           standard deviation. valid options are 'std' and 'mardia',
%           respectively. default is 'std'.]
%
%   Output:
%     s     circular standard deviation
%
% PHB 6/7/2008
%
% References:
%   Biostatistical Analysis, J. H. Zar
%
% Circular Statistics Toolbox for Matlab

% By Philipp Berens, 2009
% berens@tuebingen.mpg.de - www.kyb.mpg.de/~berens/circStat.html
% Distributed under Open Source BSD License

% check vector size
if size(alpha,2) > size(alpha,1)
	alpha = alpha';
end

if nargin<2
  % if no specific weighting has been specified
  % assume no binning has taken place
	w = ones(size(alpha));
else
  w = w(:);
end

if nargin<3
  % per default do not apply correct for binned data
  d = 0;
end

if nargin<4
  type = 'std';
end

% compute mean resultant vector length
r = circ_r(alpha,w,d);

switch type
  case 'std'
    s = sqrt(2*(1-r));      % 26.20
  case 'mardia'
    s = sqrt(-2*log(r));    % 26.21
  otherwise
    error('Deviation type not defined.')
end



