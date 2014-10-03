function  [T,ctb,depth]=common_timebase(N,t0,dt,tn)	% {{{
%COMMON_TIMEBASE - interpolate temperatures onto common timebase
% 
%USAGE -	[T,ctb,depth]=common_timebase(N,t0,dt,tn)
%
%EXPLANATION -	
%
%SEE ALSO -	
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2013-01-07 
% 
%	$Revision: 1.1 $
%	$Date: 2013-01-10 17:59:00 $
%	$Id: common_timebase.m,v 1.1 2013-01-10 17:59:00 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
% 
% }}}

% License {{{
% -------
%
%     This program is free software: you can redistribute it and/or
% modify it under the terms of the GNU General Public License as
% published by the Free Software Foundation, either version 3 of
% the License, or (at your option) any later version.
% 
%     This program is distributed in the hope that it will be
% useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public
% License along with this program.  If not, see
% <http://www.gnu.org/licenses/>.
% 
% See accompanying script gpl-3.0.m
% 
% }}}

% N structures of data N{:}.temp N{:}.mday
% T output of interpolated temperatures

if exist('dt','var')~=1, dt=[]; end
if isempty(dt)
	% find out the max time difference
	for i=1:length(N)
		D(i)=mode(diff(N{i}.mday));
	end 
	dt=max(D);
end

if exist('t0','var')~=1, t0=[]; end
if isempty(t0)
	for i=1:length(N)
		m0(i)=N{i}.mday(1);
	end
	t0=ceil(max(m0)/dt)*dt; % round up to integer multiples of dt
end

if exist('tn','var')~=1, tn=[]; end
if isempty(tn)
	for i=1:length(N)
		mn(i)=N{i}.mday(end);
	end
	tn=floor(min(mn)/dt)*dt; % round down to integer multiples of dt
end

% make the common time base the same shape as the input
ctb=[t0:dt:tn].';


for i=1:length(N)
	T{i}=interp1(N{i}.mday,N{i}.temp,ctb);
	depth{i}=N{i}.depth;
end

