function h=tptrack(tracks,plotarg)

% Function to plot T/P groundtracks.  Odd-numbered tracks are ASCENDING.
% Tracks are from 1:254
%
% USAGE:   TPTRACK(TRACKS, LINESTYLE)
%
% Deirdre Byrne, U Maine, 00/06/21

orbitfile = '~/matlab/useful/jason.mat';
if exist(orbitfile) == 2
  eval(['load ' orbitfile])
else
  disp([ 'Unable to find ' orbitfile])
  return
end

if nargin == 1
  plotarg = 'r-';
end

tracks = tracks(:)';
han = [];
if ~isempty(get(0,'children'))
  xax = get(gca,'xlim');
else
  xax = [];
end

holdarg = ishold;
if ~holdarg
  hold on;
end

% descending tracks
i = find(rem(tracks,2) == 1);
s = length(i);
if s > 0
  % make x
  x = reftrack(:,1)*ones(1,s) + ones(3127,1)*eqxlon(tracks(i));
  x = [x; nan*ones(1,s)];
  x = x(:);
  
  % make y
  y = reftrack(:,2)*ones(1,s);
  y = [y; nan*ones(1,s)];
  y = y(:);
  
  % see if x needs to wraparound
  if ~isempty(xax)
    if any(x < xax(1) | x > xax(2));
      xp = []; yp = [];
      j = [find(x < xax(1) | x > xax(2))];
      lenx = length(x);
      i = [0; find(diff(j) > 1); length(j)];
      j = [j; lenx+1];
      for k = 1:2*length(i)-1
	l = zeros(1,2);
	if rem(k,2) == 1
	  kk = floor(k/2) + 1;
	  if k > 1
	    l(1) = j(i(kk)) + 1;
	  else
	    l(1) = 1;
	  end
	  l(2) = j(i(kk)+1) - 1;
	else
	  kk = floor(k/2);
	  l(1) = j(i(kk) + 1);
	  l(2) = j(i(kk+1));
	end
	xp = [xp; x(l(1):l(2)); nan];
	yp = [yp; y(l(1):l(2)); nan];
      end
      j = [find(xp < xax(1))];
      xp(j) = xp(j)+360;
      j = [find(xp > xax(2))];
      xp(j) = xp(j)-360;
    else
      xp = x;
      yp = y;
    end
    clear x y
  end

  han = plot(xp, yp, plotarg);

end

% ascending tracks
i = find(rem(tracks,2) == 0);
s = length(i);
if s > 0
  % make x
  x = reftrack(:,1)*ones(1,s) + ones(3127,1)*eqxlon(tracks(i));
  x = [x; nan*ones(1,s)];
  x = x(:);
  % make y
  y = flipud(reftrack(:,2))*ones(1,s);
  y = [y; nan*ones(1,s)];
  y = y(:);

  % see if x needs to wraparound
  if ~isempty(xax)
    if any(x < xax(1) | x > xax(2));
      xp = []; yp = [];
      j = [find(x < xax(1) | x > xax(2))];
      lenx = length(x);
      i = [0; find(diff(j) > 1); length(j)];
      j = [j; lenx+1];
      for k = 1:2*length(i)-1
	l = zeros(1,2);
	if rem(k,2) == 1
	  kk = floor(k/2) + 1;
	  if k > 1
	    l(1) = j(i(kk)) + 1;
	  else
	    l(1) = 1;
	  end
	  l(2) = j(i(kk)+1) - 1;
	else
	  kk = floor(k/2);
	  l(1) = j(i(kk) + 1);
	  l(2) = j(i(kk+1));
	end
	xp = [xp; x(l(1):l(2)); nan];
	yp = [yp; y(l(1):l(2)); nan];
      end
      j = [find(xp < xax(1))];
      xp(j) = xp(j)+360;
      j = [find(xp > xax(2))];
      xp(j) = xp(j)-360;
    else
      xp = x;
      yp = y;
    end
    clear x y
  end
  
  han = [han; plot(xp, yp, plotarg)];
  
end

if ~holdarg
  hold off
end

if nargout == 1;
  h=han;
end
return

