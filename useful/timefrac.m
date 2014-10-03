function [T]=timefrac(YMD)
% TIMEFRAC -	time as a fraction of a year 
%
% USAGE - 	[T]=timefrac(YMD)
%
% EXPLANATION -	T - time as a fraction
%		YMDHMS - [year month day hour minute second] matrix
%
% SEE ALSO -	day2date, date2day
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	1998-11-11
%
% PROG MODS -	1999-06-23 change how deal with wide arrays passed
%		2007-09-10 error message on return from date2day
%			with badly formed arrays
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

[m,n]=size(YMD);
if n<6, YMD=[YMD,zeros(m,6-n)]; end;
[ymd,ly]=date2day(YMD(:,1:6));
if size(ymd,1)~=size(ly,1),
	disp('error in date2day: returns disparate size matrices');
	T=[];
	return;
end;
T=ymd(:,1)+(ymd(:,2)+(YMD(:,4)+(YMD(:,5)+YMD(:,6)./60)./60)./24)./(365+ly);
return;

