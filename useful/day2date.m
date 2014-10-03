function [dat] = day2date(YD)
% DAY2DATE -	returns the western style date from the given year and day
%
% USAGE - 	[dat]=day2date(YD);
%
%		YD is vector [ year dayofyear ] eg. [92 84]
%		dat is vector [year month day] eg. [1992 3 24]
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

dim=[0 31 29 31 30 31 30 31 31 30 31 30 31];
if YD(1) < 100, YD(1) =YD(1)+1900; end;
yr=rem(YD(1),100);
if yr==0, yr=YD(1)./100; end;
if rem(yr,4)==0, dim(3)=29; else dim(3)=28; end;
mo=1; 
da=YD(2); 
while da>dim(mo+1), 
	da=da-dim(mo+1);
	mo=mo+1; 
end;
dat=[ YD(1) mo da ];
return;

