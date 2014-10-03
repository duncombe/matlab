function [s,t,p,c,r,h,I,II,ascdisp,watermass]=ctdstats(stp,level,pl)
% CTDSTATS - 	returns twolayer stats for ctd station
% 
% USAGE -	[s,t,p,c,r,h,I,II,ascdisp,aaiw,nadw,aabw]=ctdstats(stp,level,pl)
%		s,t,p,c,r  =  two element vectors of upper and lower layer
%			salt, temp, pressure, sound speed, density
%		h = depth of level isotherm
%		I = index to upper layer pts
%		II = index to lower layer pts
%		level = thermocline isotherm [10C]
%		pl = display results as you go along (boolean) [1]
%		watermass = [stp_vector, index] at tmax, smin, smax, & tmin 
%				(sw, aaiw, nadw, aabw)
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
% 

if nargin==0, 
	disp('Requires input arguments');
	help ctdstats; 
end; 

if ~exist('level'), level=10; end;
if ~exist('pl'), pl=1; end;

I=find(stp(:,2)>level);
II=find(stp(:,2)<=level);

n=length(I);
h=stp(I(n),3)+(stp(II(1),3)-stp(I(n),3)).*(level-stp(I(n),2))...
		./(stp(II(1),2)-stp(I(n),2));
s=[stats(stp(I,1)), stats(stp(II,1))];
t=[stats(stp(I,2)), stats(stp(II,2))];
p=[stats(stp(I,3)), stats(stp(II,3))];
c=[stats(mysvel(stp(I,:))), stats(mysvel(stp(II,:)))];
r=[stats(mydens(stp(I,:))), stats(mydens(stp(II,:)))];

ascdisp = [	sprintf(['salinity \t' form(2)],s), ...
		sprintf(['temp     \t' form(2)],t), ...
		sprintf(['pressure \t' form(2)],p), ...
		sprintf(['sound spd\t' form(2)],c), ...
		sprintf(['density  \t' form(2)],r), ...
		sprintf('interface\t%g dbar (%g degC)',[h,level]) ];

if pl, disp(ascdisp); end;

[i,k]=size(stp);

[junk,tmax]=maxi(stp(:,2)); watermass=[stp(tmax,:) tmax];
[junk,smin]=mini(stp(:,1)); watermass=[watermass; stp(smin,:) smin];
[junk,smax]=maxi(stp(smin:i,1)); watermass=[watermass; stp(smin+smax,:) smin+smax]; 
[junk,tmin]=mini(stp(smax:i,2)); watermass=[watermass; stp(smax+tmin,:) smax+tmin];

return;

disp(sprintf(['salinity \t' form(2)],s))
disp(sprintf(['temp     \t' form(2)],t))
disp(sprintf(['pressure \t' form(2)],p))
disp(sprintf(['sound spd\t' form(2)],c))
disp(sprintf(['density  \t' form(2)],r))
disp(sprintf(['level    \t' form(2)],h))

	[junk,smin]=min(stp(:,1));
	[junk,tmax]=max(stp(:,2));
	[junk,pmax]=max(stp(:,3));

	level=(stp(tmax,2)-stp(smin,2))./2+stp(smin,2);

return;

