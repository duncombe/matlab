function y = tpgety(irev,ix)
%
% TPGETY --   Find latitude of a given T/P measurement, given pass number
%           and along-track distance.
%           
% USAGE:    y = tpgety(irev,ix)
%
%           irev = a pass number, range 1-254
%           
%           ix = a vector of along track locations, range 1-3127
%


% Author D. A. Byrne?

orbitfile = '~/matlab/useful/jason.mat';

if nargin < 1
  help tpgety
  return
end

if nargin == 1
  ix = 1:3127;
end

if nargin == 2
  if any(ix > 3127 | ix < 1)
    disp('along-track index must be between 1 and 3127')
    return
  end
end

if any(irev < 1 | irev > 254)
  disp('track numbers must be between 1 and 254')
  return
end

if exist(orbitfile) == 2
  eval(['load ' orbitfile])
else
  disp([ 'Unable to find ' orbitfile])
  return
end

y = nan*ones(length(ix),length(irev));
i = find(rem(irev,2) == 1);
if ~isempty(i)
  y(:,i) = reftrack(ix,2)*ones(1,length(i));
end
i = find(rem(irev,2) == 0);
if ~isempty(i)
  tmp = flipud(reftrack(:,2));
  y(:,i) = tmp(ix)*ones(1,length(i));
end
return
