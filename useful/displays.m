function [HANDLES]=displaystn(S,T,P,CO)
% DISPLAYSTN - 	displays salinity, temperature and pressure data as p/t, p/s & t/s
%
% USAGE - 	[handles]=displaystn(D,co) 
%		[handles]=displaystn(s,t,p,co)
% 
% EXPLANATION -	handles: Handles to the three subplots
%		D:	interpreted as matrix D=[ s t p ]
%		s:	salinity parameter, used as x values for p/s and t/s plot 
%		t:	temperature parameter, used as y values for t/s plot 
%			and x values for p/t plot
%		p:	pressure parameter used as y values for p/t and p/s 
%			plots 
%		co:	optional colour/symbol string for plot function
%
% SEE ALSO -	HOLDSTN, STPAXIS
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae, 94-12-23, sfri & ldeo
%
% PROG MODS -	HANDLES added 97-04-15, aboard Dr F. Nansen
% 		2000-02-24: Edit help text, aboard Algoa
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
% 
%		

if (nargin == 1),
	s=S(:,1); t=S(:,2); p=S(:,3); co='r';
elseif (nargin == 2),
	t=S(:,2); p=S(:,3); s=S(:,1); co=T;
elseif (nargin == 3),
	s=S; t=T; p=P; co='r';
elseif (nargin == 4),
	s=S; t=T; p=P; co=CO;
else
	error('usage: displaystn(D,co) or displaystn(s,t,p,co) where D=[s,t,p]');
end;
handle1=subplot(1,3,1);
plot(t,p,co);set(gca,'ydir','reverse');
handle2=subplot(1,3,2);
plot(s,p,co);set(gca,'ydir','reverse');
handle3=subplot(1,3,3);
plot(s,t,co);
HANDLES=[handle1,handle2,handle3];
return;

