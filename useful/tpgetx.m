function x = tpgetx(irev,ix)
%
% TPGETX --   Find longitude of a given T/P measurement, given pass number
%           and along-track distance.
%           
% USAGE:    x = tpgetx(irev,ix)

% Author D. A. Byrne?


%
%           irev = a pass number, range 1-254
%           ix = a vector of along track locations, range 1-3127
%

orbitfile = '~/matlab/useful/jason.mat';

if nargin < 1
  help tpgetx
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

x = reftrack(ix,1)*ones(1,length(irev)) + ones(length(ix),1)*eqxlon(irev);

return
