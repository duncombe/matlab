function md = circ_median(alpha)
%
% mu = circ_median(alpha, w)
%   Computes the median direction for circular data.
%
%   Input:
%     alpha	sample of angles in radians
%
%   Output:
%     mu		mean direction
%
% PHB 3/19/2009
%
% References:
%   Biostatistical Analysis, J. H. Zar (26.6)
%
% Circular Statistics Toolbox for Matlab

% By Philipp Berens, 2009
% berens@tuebingen.mpg.de - www.kyb.mpg.de/~berens/circStat.html
% Distributed under Open Source BSD License

if size(alpha,2) > size(alpha,1)
	alpha = alpha';
end
alpha = mod(alpha,2*pi);
n = length(alpha);




m1 = sum(circ_dist2(alpha,alpha)>0,1);
m2 = sum(circ_dist2(alpha,alpha)<0,1);

if mod(n,2)==1
  idx = find(m1==m2);
else
  dm = abs(m1-m2);
  m = min(dm);
  if m ~= 1
    warning('Incorrect number of minimal elements.') %#ok<WNTAG>
  end
  idx = find(dm==m,2);
end

md = circ_mean(alpha(idx));
  
if abs(circ_dist(circ_mean(alpha),md)) > abs(circ_dist(circ_mean(alpha),md+pi))
  md = mod(md+pi,2*pi);
end

  