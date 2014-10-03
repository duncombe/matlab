function [YD] = yearday(dat)
% YEARDAY -	returns the day of the year from the given date
%
% USAGE -	[YD]=yearday(date);
%		date - vector [year month day] eg. [92 3 24]
%		YD - vector [ year dayofyear ] eg. [1992 84]
%		argument can be columnwise matrix 
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


% Programming note: 
% 2012-06-18 : note that dat is equivalent to the output of datevec
% 	so yearday is easily obtained from 
% 	fix(datenum(dat)-datenum(dat(1),1,0))


%
%
	modays=[0 31 28 31 30 31 30 31 31 30 31 30 31];
	lydays=[0 31 29 31 30 31 30 31 31 30 31 30 31];
%
	dim=[ 	cumsum(modays);
		cumsum(lydays)
	];
% adjust year to 19?? and find leapyears (LY)
	I=find(dat(:,1)<100);
	dat(I,1)=dat(I,1)+1900;
	yr=rem(dat(:,1),100);
	I=find(yr==0);

	yr(I)=dat(I,1)./100;
	lys=rem(yr,4);
	LY=find(lys==0);
%
	days=dim(1,dat(:,2));
	days(LY)=dim(2,dat(LY,2));
%
	YD=[ dat(:,1) days'+dat(:,3) ];
clear dat modays lydays dim I yr lys days 
return;

