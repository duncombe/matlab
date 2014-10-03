function [rh]=mydens(S,T)
% MYDENS - 	calculates the density of seawater at the surface 
%		using the australian utility but allowing matrix argument
%
% USAGE -	[rh]=mydens(S,T)
%		[rh]=mydens(D)
% 
% EXPLANATION -	D:	interpreted as matrix D=[ s t p ]
%		s:	salinity parameter
%		t:	temperature parameter
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% PROG MODS -	
%
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
%

if (nargin == 1),
	s=S(:,1); t=S(:,2); p=S(:,3);
elseif (nargin == 2),
	s=S; t=T;
else
	error('usage: [rh]=mydens0(D) or [rh]=mydens0(s,t) where D=[s,t,p]');
end;

rh=sw_dens0(s,t);

return;

